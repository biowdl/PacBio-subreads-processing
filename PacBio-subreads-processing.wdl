version 1.0

# Copyright (c) 2020 Sequencing Analysis Support Core - Leiden University Medical Center
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import "structs.wdl" as structs
import "tasks/ccs.wdl" as ccs
import "tasks/common.wdl" as common
import "tasks/fastqc.wdl" as fastqc
import "tasks/isoseq3.wdl" as isoseq3
import "tasks/lima.wdl" as lima
import "tasks/multiqc.wdl" as multiqc

workflow SubreadsProcessing {
    input {
        File subreadsConfigFile
        String outputDirectory = "."
        File dockerImagesFile
        String libraryDesign = "same"
        Boolean ccsMode = true
        Boolean splitBamNamed = true
        Boolean runIsoseq3Refine = false
    }

    meta {allowNestedInputs: true}

    call common.YamlToJson as convertDockerImagesFile {
        input:
            yaml = dockerImagesFile,
            outputJson = outputDirectory + "/dockerImages.json"
    }

    Map[String, String] dockerImages = read_json(convertDockerImagesFile.json)

    SubreadsConfig subreadsConfig = read_json(subreadsConfigFile)
    Array[Subreads] allSubreads = subreadsConfig.subreads

    scatter (subreads in allSubreads) {
        call ccs.CCS as ccs {
            input:
                subreadsFile = subreads.subreads_file,
                outputPrefix = outputDirectory + "/" + subreads.subreads_id + "/" + subreads.subreads_id,
                dockerImage = dockerImages["ccs"]
        }

        call lima.Lima as lima {
            input:
                libraryDesign = libraryDesign,
                ccsMode = ccsMode,
                splitBamNamed = splitBamNamed,
                inputBamFile = ccs.outputCCSfile,
                barcodeFile = subreads.barcodes_file,
                outputPrefix = outputDirectory + "/" + subreads.subreads_id + "/" + subreads.subreads_id,
                dockerImage = dockerImages["lima"]
        }

        scatter (bamFile in lima.outputFLfile) {
            if (runIsoseq3Refine) {
                String refineOutputPrefix = sub(basename(bamFile, ".bam"), "fl", "flnc")
                call isoseq3.Refine as refine {
                    input:
                        inputBamFile = bamFile,
                        primerFile = subreads.barcodes_file,
                        outputDir = outputDirectory + "/" + subreads.subreads_id,
                        outputNamePrefix = refineOutputPrefix,
                        dockerImage = dockerImages["isoseq3"]
                }

                call fastqc.Fastqc as fastqcRefine {
                    input:
                        seqFile = refine.outputFLNCfile,
                        outdirPath = outputDirectory + "/" + subreads.subreads_id + "/" + basename(refine.outputFLNCfile, ".bam") + "-fastqc",
                        format = "bam",
                        threads = 4,
                        dockerImage = dockerImages["fastqc"]
                }
            }

            if (!runIsoseq3Refine) {
                call fastqc.Fastqc as fastqcLima {
                    input:
                        seqFile = bamFile,
                        outdirPath = outputDirectory + "/" + subreads.subreads_id + "/" + basename(bamFile, ".bam") + "-fastqc",
                        format = "bam",
                        threads = 4,
                        dockerImage = dockerImages["fastqc"]
                }
            }

            File fastqcHtmlReport = select_first([fastqcRefine.htmlReport, fastqcLima.htmlReport])
            File fastqcZipReport = select_first([fastqcRefine.reportZip, fastqcLima.reportZip])

            # Determine the sample name from the bam file name. This is needed
            # because the sample names are determine from the headers in the
            # fasta file, which is not accessible from the WDL.
            String sampleName = sub(sub(bamFile, ".*--", ""),".bam", "")
        }
    }

    Array[File] outputReports = flatten([flatten(fastqcHtmlReport), flatten(fastqcZipReport)])

    call multiqc.MultiQC as multiqcTask {
        input:
            reports = outputReports,
            outDir = outputDirectory + "/multiqc",
            dataDir = true,
            dockerImage = dockerImages["multiqc"]
    }

    output {
        Array[File] outputCCS = ccs.outputCCSfile
        Array[File] outputCCSindex = ccs.outputCCSindexFile
        Array[File] outputCCSreport = ccs.outputReportFile
        Array[File] outputCCSstderr = ccs.outputSTDERRfile
        Array[File] outputLima = flatten(lima.outputFLfile)
        Array[File] outputLimaIndex = flatten(lima.outputFLindexFile)
        Array[File] outputLimaSubreadset = flatten(lima.outputFLxmlFile)
        Array[File] outputLimaStderr = lima.outputSTDERRfile
        Array[File] outputLimaJson = lima.outputJSONfile
        Array[File] outputLimaCounts = lima.outputCountsFile
        Array[File] outputLimaReport = lima.outputReportFile
        Array[File] outputLimaSummary = lima.outputSummaryFile
        Array[File] outputHtmlReport = flatten(fastqcHtmlReport)
        Array[File] outputZipReport = flatten(fastqcZipReport)
        File outputMultiqcReport = multiqcTask.multiqcReport
        File? outputMultiqcReportZip = multiqcTask.multiqcDataDirZip
        Array[File?] outputRefine = flatten(refine.outputFLNCfile)
        Array[File?] outputRefineIndex = flatten(refine.outputFLNCindexFile)
        Array[File?] outputRefineConsensusReadset = flatten(refine.outputConsensusReadsetFile)
        Array[File?] outputRefineSummary = flatten(refine.outputFilterSummaryFile)
        Array[File?] outputRefineReport = flatten(refine.outputReportFile)
        Array[File?] outputRefineStderr = flatten(refine.outputSTDERRfile)
        Array[String] outputSamples = flatten(sampleName)
    }

    parameter_meta {
        # inputs
        subreadsConfigFile: {description: "Configuration file describing input subread BAMs and barcode files.", category: "required"}
        outputDirectory: {description: "The directory to which the outputs will be written.", category: "advanced"}
        dockerImagesFile: {description: "The docker image used for this workflow. Changing this may result in errors which the developers may choose not to address.", category: "required"}
        libraryDesign: {description: "Barcode structure of the library design.", category: "advanced"}
        ccsMode: {description: "CCS mode, use optimal alignment options.", category: "advanced"}
        splitBamNamed: {description: "Split BAM output by resolved barcode pair name.", category: "advanced"}
        runIsoseq3Refine: {description: "Run isoseq3 refine for de-novo transcript reconstruction. Do not set this to true when analysing DNA reads.", category: "advanced"}

        # outputs
        outputCCS: {description: "Consensus reads output file(s)."}
        outputCCSindex: {description: "Index of consensus reads output file(s)."}
        outputCCSreport: {description: "CCS results report file(s)."}
        outputCCSstderr: {description: "CCS STDERR log file(s)."}
        outputLima: {description: "Demultiplexed reads output file(s)."}
        outputLimaIndex: {description: "Index of demultiplexed reads output file(s)."}
        outputLimaSubreadset: {description: "XML file of the subreadset(s)."}
        outputLimaStderr: {description: "Lima STDERR log file(s)."}
        outputLimaJson: {description: "Lima JSON file(s)."}
        outputLimaCounts: {description: "Lima counts file(s)."}
        outputLimaReport: {description: "Lima report file(s)."}
        outputLimaSummary: {description: "Lima summary file(s)."}
        outputRefine: {description: "Filtered reads output file(s)."}
        outputRefineIndex: {description: "Index of filtered reads output file(s)."}
        outputRefineConsensusReadset: {description: "Refine consensus readset XML file(s)."}
        outputRefineSummary: {description: "Refine summary file(s)."}
        outputRefineReport: {description: "Refine report file(s)."}
        outputRefineStderr: {description: "Refine STDERR log file(s)."}
        outputHtmlReport: {description: "FastQC output HTML file(s)."}
        outputZipReport: {description: "FastQC output support file(s)."}
        outputMultiqcReport: {description: "The MultiQC html report."}
        outputMultiqcReportZip: {description: "The MultiQC data zip file."}
        outputSamples: {description: "The name(s) of the sample(s)."}
    }
}
