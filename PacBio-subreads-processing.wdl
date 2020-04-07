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
import "tasks/biowdl.wdl" as biowdl
import "tasks/common.wdl" as common
import "tasks/ccs.wdl" as ccs
import "tasks/lima.wdl" as lima
import "tasks/isoseq3.wdl" as isoseq3

workflow Pipeline {
    input {
        File subreadsConfigFile
        String outputDirectory = "."
        File dockerImagesFile
        String libraryDesign = "same"
        Boolean ccsMode = true
        Boolean splitBamNamed = true
    }

    call common.YamlToJson as convertDockerImagesFile {
        input:
            yaml = dockerImagesFile,
            outputJson = outputDirectory + "/dockerImages.json"
    }

    Map[String, String] dockerImages = read_json(convertDockerImagesFile.json)

    SubreadsConfig subreadsConfig = read_json(subreadsConfigFile)
    Array[Subreads] allSubreads = subreadsConfig.subreads

    scatter (subreads in allSubreads) {
        String groupIdentifier = subreads.subreads_id + "/" + subreads.subreads_id
        call ccs.CCS as executeCCS {
            input:
                subreadsFile = subreads.subreads_file,
                outputPrefix = outputDirectory + "/" + groupIdentifier,
                dockerImage = dockerImages["ccs"]
        }

        call lima.Lima as executeLima {
            input:
                libraryDesign = libraryDesign,
                ccsMode = ccsMode,
                splitBamNamed = splitBamNamed,
                inputBamFile = executeCCS.outputCCSfile,
                barcodeFile = subreads.barcodes_file,
                outputPrefix = outputDirectory + "/" + groupIdentifier,
                dockerImage = dockerImages["lima"]
        }

        scatter (bamFile in executeLima.outputFLfile) {
            call isoseq3.Refine as executeRefine {
                input:
                    inputBamFile = bamFile,
                    primerFile = subreads.barcodes_file,
                    outputPrefix = outputDirectory + "/" + groupIdentifier,
                    dockerImage = dockerImages["isoseq3"]
            }
        }
    }

    output {
        Array[File] outputCCS = executeCCS.outputCCSfile
        Array[File] outputCCSindex = executeCCS.outputCCSindexFile
        Array[File] outputCCSreport = executeCCS.outputReportFile
        Array[File] outputCCSstderr = executeCCS.outputSTDERRfile
        Array[File] outputLima = flatten(executeLima.outputFLfile)
        Array[File] outputLimaIndex = flatten(executeLima.outputFLindexFile)
        Array[File] outputLimaSubreadset = flatten(executeLima.outputFLxmlFile)
        Array[File] outputLimaStderr = executeLima.outputSTDERRfile
        Array[File] outputLimaJson = executeLima.outputJSONfile
        Array[File] outputLimaCounts = executeLima.outputCountsFile
        Array[File] outputLimaReport = executeLima.outputReportFile
        Array[File] outputLimaSummary = executeLima.outputSummaryFile
        Array[File] outputRefine = flatten(flatten(executeRefine.outputFLNCfile))
        Array[File] outputRefineIndex = flatten(flatten(executeRefine.outputFLNCindexFile))
        Array[File] outputRefineConsensusReadset = flatten(flatten(executeRefine.outputConsensusReadsetFile))
        Array[File] outputRefineSummary = flatten(flatten(executeRefine.outputFilterSummaryFile))
        Array[File] outputRefineReport = flatten(flatten(executeRefine.outputReportFile))
        Array[File] outputRefineStderr = flatten(flatten(executeRefine.outputSTDERRfile))
    }

    parameter_meta {
        # inputs
        subreadsConfigFile: {description: "Samplesheet describing input fasta/fastq files.", category: "required"}
        outputDirectory: {description: "The directory to which the outputs will be written.", category: "advanced"}
        dockerImagesFile: {description: "The docker image used for this workflow. Changing this may result in errors which the developers may choose not to address.", category: "required"}
        libraryDesign: {description: "Barcode structure of the library design.", category: "advanced"}
        ccsMode: {description: "CCS mode, use optimal alignment options.", category: "advanced"}
        splitBamNamed: {description: "Split BAM output by resolved barcode pair name.", category: "advanced"}

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
    }
}
