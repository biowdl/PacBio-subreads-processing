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
import "tasks/lima.wdl" as lima
import "tasks/isoseq3.wdl" as isoseq3

workflow SampleWorkflow {
    input {
        Sample sample
        String outputDirectory = "."
        String libraryDesign = "same"
        Boolean ccsMode = true
        Boolean splitBamNamed = true
        Map[String, String] dockerImages
    }

    Array[Readgroup] readgroups = sample.readgroups

    scatter (readgroup in readgroups) {
        String readgroupIdentifier = sample.id + "-" + readgroup.lib_id + "-" + readgroup.id
        call ccs.CCS as executeCCS {
            input:
                subreadsFile = readgroup.R1,
                outputPrefix = outputDirectory + "/" + readgroupIdentifier,
                dockerImage = dockerImages["ccs"]
        }

        call lima.Lima as executeLima {
            input:
                libraryDesign = libraryDesign,
                ccsMode = ccsMode,
                splitBamNamed = splitBamNamed,
                inputBamFile = executeCCS.outputCCSfile,
                barcodeFile = sample.barcode,
                outputPrefix = outputDirectory + "/" + readgroupIdentifier,
                dockerImage = dockerImages["lima"]
        }

        scatter (bamFile in executeLima.outputFLfile) {
            call isoseq3.Refine as executeRefine {
                input:
                    inputBamFile = bamFile,
                    primerFile = sample.barcode,
                    outputPrefix = outputDirectory + "/" + readgroupIdentifier
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
        Array[File] outputRefine = executeRefine.outputFLNCfile
        Array[File] outputRefineIndex = executeRefine.outputFLNCindexFile
        Array[File] outputRefineConsensusReadset = executeRefine.outputConsensusReadsetFile
        Array[File] outputRefineSummary = executeRefine.outputFilterSummaryFile
        Array[File] outputRefineReport = executeRefine.outputReportFile
        Array[File] outputRefineStderr = executeRefine.outputSTDERRfile
    }
}
