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

import "sample.wdl" as sampleWorkflow
import "structs.wdl" as structs
import "tasks/biowdl.wdl" as biowdl
import "tasks/common.wdl" as common

workflow Pipeline {
    input {
        File sampleConfigFile
        String outputDirectory = "."
        File dockerImagesFile
    }

    call common.YamlToJson as convertDockerImagesFile {
        input:
            yaml = dockerImagesFile,
            outputJson = outputDirectory + "/dockerImages.json"
    }

    Map[String, String] dockerImages = read_json(convertDockerImagesFile.json)

    call biowdl.InputConverter as convertSampleConfig {
        input:
            samplesheet = sampleConfigFile,
            outputFile = outputDirectory + "/samplesheet.json",
            dockerImage = dockerImages["biowdl-input-converter"]
    }

    SampleConfig sampleConfig = read_json(convertSampleConfig.json)
    Array[Sample] allSamples = sampleConfig.samples

    scatter (sample in allSamples) {
        call sampleWorkflow.SampleWorkflow as executeSampleWorkflow {
            input:
                sample = sample,
                outputDirectory = outputDirectory + "/" + sample.id,
                dockerImages = dockerImages
        }
    }

    output {
        Array[File] outputCCS = flatten(executeSampleWorkflow.outputCCS)
        Array[File] outputCCSindex = flatten(executeSampleWorkflow.outputCCSindex)
        Array[File] outputCCSreport = flatten(executeSampleWorkflow.outputCCSreport)
        Array[File] outputCCSstderr = flatten(executeSampleWorkflow.outputCCSstderr)
        Array[File] outputLima = flatten(executeSampleWorkflow.outputLima)
        Array[File] outputLimaIndex = flatten(executeSampleWorkflow.outputLimaIndex)
        Array[File] outputLimaSubreadset = flatten(executeSampleWorkflow.outputLimaSubreadset)
        Array[File] outputLimaStderr = flatten(executeSampleWorkflow.outputLimaStderr)
        Array[File] outputLimaJson = flatten(executeSampleWorkflow.outputLimaJson)
        Array[File] outputLimaCounts = flatten(executeSampleWorkflow.outputLimaCounts)
        Array[File] outputLimaReport = flatten(executeSampleWorkflow.outputLimaReport)
        Array[File] outputLimaSummary = flatten(executeSampleWorkflow.outputLimaSummary)
        Array[File] outputRefine = flatten(executeSampleWorkflow.outputRefine)
        Array[File] outputRefineIndex = flatten(executeSampleWorkflow.outputRefineIndex)
        Array[File] outputRefineConsensusReadset = flatten(executeSampleWorkflow.outputRefineConsensusReadset)
        Array[File] outputRefineSummary = flatten(executeSampleWorkflow.outputRefineSummary)
        Array[File] outputRefineReport = flatten(executeSampleWorkflow.outputRefineReport)
        Array[File] outputRefineStderr = flatten(executeSampleWorkflow.outputRefineStderr)
    }

    parameter_meta {
    # inputs
    sampleConfigFile: {description: "Samplesheet describing input fasta/fastq files.", category: "required"}
    outputDirectory: {description: "The directory to which the outputs will be written.", category: "advanced"}
    dockerImages: {description: "The docker image used for this workflow. Changing this may result in errors which the developers may choose not to address.", category: "required"}

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
