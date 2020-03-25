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
import "tasks/isoseq3.wdl" as isoseq3

workflow ReadgroupWorkflow {
    input {
        Array[File] inputFiles
        File primerFile
        String outputDirectory
        Map[String, String] dockerImages
    }

    scatter (bamFile in inputFiles) {
        call isoseq3.Refine as executeRefine {
            input:
                inputBamFile = bamFile,
                primerFile = primerFile,
                outputPrefix = outputDirectory,
                dockerImage = dockerImages["isoseq3"]
        }
    }

    output {
        Array[File] outputRefine = flatten(executeRefine.outputFLNCfile)
        Array[File] outputRefineIndex = flatten(executeRefine.outputFLNCindexFile)
        Array[File] outputRefineConsensusReadset = flatten(executeRefine.outputConsensusReadsetFile)
        Array[File] outputRefineSummary = flatten(executeRefine.outputFilterSummaryFile)
        Array[File] outputRefineReport = flatten(executeRefine.outputReportFile)
        Array[File] outputRefineStderr = flatten(executeRefine.outputSTDERRfile)
    }

    parameter_meta {
        # inputs
        inputFiles: {description: "BAM input file(s).", category: "required"}
        primerFile: {description: "Barcode/primer fasta file used in Lima.", category: "required"}
        outputDirectory: {description: "Output directory path + output file prefix.", category: "required"}
        dockerImages: {description: "The docker image used for this task. Changing this may result in errors which the developers may choose not to address.", category: "required"}

        # outputs
        outputRefine: {description: "Filtered reads output file(s)."}
        outputRefineIndex: {description: "Index of filtered reads output file(s)."}
        outputRefineConsensusReadset: {description: "Refine consensus readset XML file(s)."}
        outputRefineSummary: {description: "Refine summary file(s)."}
        outputRefineReport: {description: "Refine report file(s)."}
        outputRefineStderr: {description: "Refine STDERR log file(s)."}
    }
}
