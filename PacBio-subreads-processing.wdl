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
import "tasks/bam2fastx.wdl" as bam2fastx
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
        Int limaCores = 2
        Int ccsCores = 2
        Boolean generateFastq = false
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
                cores = ccsCores,
                dockerImage = dockerImages["ccs"]
        }

        call lima.Lima as lima {
            input:
                libraryDesign = libraryDesign,
                ccsMode = ccsMode,
                splitBamNamed = splitBamNamed,
                inputBamFile = ccs.ccsBam,
                barcodeFile = subreads.barcodes_file,
                outputPrefix = outputDirectory + "/" + subreads.subreads_id + "/" + subreads.subreads_id,
                cores = limaCores,
                dockerImage = dockerImages["lima"]
        }

        scatter (bamFile in lima.limaBam) {
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
                        seqFile = refine.refineBam,
                        outdirPath = outputDirectory + "/" + subreads.subreads_id + "/" + basename(refine.refineBam, ".bam") + "-fastqc",
                        format = "bam",
                        threads = 4,
                        dockerImage = dockerImages["fastqc"]
                }

                if (generateFastq) {
                    call bam2fastx.Bam2Fastq as bam2FastqRefine {
                        input:
                            bam = [refine.refineBam],
                            bamIndex = [refine.refineBamIndex],
                            outputPrefix = outputDirectory + "/" + subreads.subreads_id + "/fastq-files/" + basename(refine.refineBam, ".bam"),
                            dockerImage = dockerImages["bam2fastx"]
                    }
                }
            }

            if (! runIsoseq3Refine) {
                call fastqc.Fastqc as fastqcLima {
                    input:
                        seqFile = bamFile,
                        outdirPath = outputDirectory + "/" + subreads.subreads_id + "/" + basename(bamFile, ".bam") + "-fastqc",
                        format = "bam",
                        threads = 4,
                        dockerImage = dockerImages["fastqc"]
                }

                if (generateFastq) {
                    call bam2fastx.Bam2Fastq as bam2FastqLima {
                        input:
                            bam = [bamFile],
                            bamIndex = lima.limaBamIndex,
                            outputPrefix = outputDirectory + "/" + subreads.subreads_id + "/fastq-files/" + basename(bamFile, ".bam"),
                            dockerImage = dockerImages["bam2fastx"]
                    }
                }
            }

            File fastqcHtmlReport = select_first([fastqcRefine.htmlReport, fastqcLima.htmlReport])
            File fastqcZipReport = select_first([fastqcRefine.reportZip, fastqcLima.reportZip])

            # Determine the sample name from the bam file name. This is needed
            # because the sample names are determine from the headers in the
            # fasta file, which is not accessible from the WDL.
            String sampleName = sub(sub(bamFile, ".*--", ""),".bam", "")

            if (generateFastq) {
                File? fastqFile = select_first([bam2FastqRefine.fastqFile, bam2FastqLima.fastqFile])
            }
        }
    }

    Array[File] qualityReports = flatten([flatten(fastqcHtmlReport), flatten(fastqcZipReport)])

    call multiqc.MultiQC as multiqcTask {
        input:
            reports = qualityReports,
            outDir = outputDirectory + "/multiqc",
            dataDir = true,
            dockerImage = dockerImages["multiqc"]
    }

    output {
        Array[File] ccsReads = ccs.ccsBam
        Array[File] ccsIndex = ccs.ccsBamIndex
        Array[File] ccsReport = ccs.ccsReport
        Array[File] ccsStderr = ccs.ccsStderr
        Array[File] limaReads = flatten(lima.limaBam)
        Array[File] limaIndex = flatten(lima.limaBamIndex)
        Array[File] limaSubreadset = flatten(lima.limaXml)
        Array[File] limaStderr = lima.limaStderr
        Array[File] limaJson = lima.limaJson
        Array[File] limaCounts = lima.limaCounts
        Array[File] limaReport = lima.limaReport
        Array[File] limaSummary = lima.limaSummary
        Array[String] samples = flatten(sampleName)
        Array[File] workflowReports = qualityReports
        File multiqcReport = multiqcTask.multiqcReport
        File? multiqcZip = multiqcTask.multiqcDataDirZip
        Array[File?] fastqFiles = flatten(fastqFile)
        Array[File?] refineReads = flatten(refine.refineBam)
        Array[File?] refineIndex = flatten(refine.refineBamIndex)
        Array[File?] refineConsensusReadset = flatten(refine.refineConsensusReadset)
        Array[File?] refineSummary = flatten(refine.refineFilterSummary)
        Array[File?] refineReport = flatten(refine.refineReport)
        Array[File?] refineStderr = flatten(refine.refineStderr)
    }

    parameter_meta {
        # inputs
        subreadsConfigFile: {description: "Configuration file describing input subread BAMs and barcode files.", category: "required"}
        outputDirectory: {description: "The directory to which the outputs will be written.", category: "advanced"}
        dockerImagesFile: {description: "The docker image used for this workflow. Changing this may result in errors which the developers may choose not to address.", category: "required"}
        libraryDesign: {description: "Barcode structure of the library design.", category: "advanced"}
        ccsMode: {description: "Ccs mode, use optimal alignment options.", category: "advanced"}
        splitBamNamed: {description: "Split bam file(s) by resolved barcode pair name.", category: "advanced"}
        generateFastq: {description: "Generate fastq files from demultiplexed bam files.", category: "common"}
        runIsoseq3Refine: {description: "Run isoseq3 refine for de-novo transcript reconstruction. Do not set this to true when analysing dna reads.", category: "advanced"}
        limaCores: {description: "The number of CPU cores to be used by lima.", category: "advanced"}

        # outputs
        ccsReads: {description: "Consensus reads file(s)."}
        ccsIndex: {description: "Index of consensus reads file(s)."}
        ccsReport: {description: "Ccs results report file(s)."}
        ccsStderr: {description: "Ccs stderr log file(s)."}
        limaReads: {description: "Demultiplexed reads file(s)."}
        limaIndex: {description: "Index of demultiplexed reads file(s)."}
        limaSubreadset: {description: "Xml file of the subreadset(s)."}
        limaStderr: {description: "Lima stderr log file(s)."}
        limaJson: {description: "Lima json file(s)."}
        limaCounts: {description: "Lima counts file(s)."}
        limaReport: {description: "Lima report file(s)."}
        limaSummary: {description: "Lima summary file(s)."}
        samples: {description: "The name(s) of the sample(s)."}
        workflowReports: {description: "A collection of all metrics."}
        fastqFiles: {description: "Fastq files extracted from bam files."}
        multiqcReport: {description: "The multiqc html report."}
        multiqcZip: {description: "The multiqc data zip file."}
        refineReads: {description: "Filtered reads file(s)."}
        refineIndex: {description: "Index of filtered reads file(s)."}
        refineConsensusReadset: {description: "Refine consensus readset xml file(s)."}
        refineSummary: {description: "Refine summary file(s)."}
        refineReport: {description: "Refine report file(s)."}
        refineStderr: {description: "Refine stderr log file(s)."}
    }
}
