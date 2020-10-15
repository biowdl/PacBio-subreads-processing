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
import "bam2fastx.wdl" as bam2fastx
import "ccs.wdl" as ccs
import "tasks/fastqc.wdl" as fastqc
import "samtools.wdl" as samtools
import "isoseq3.wdl" as isoseq3
import "lima.wdl" as lima
import "tasks/multiqc.wdl" as multiqc
import "pbbam.wdl" as pbbam

workflow SubreadsProcessing {
    input {
        File subreadsFile
        File? subreadsIndexFile
        File barcodesFasta
        String libraryDesign = "same"
        Boolean ccsMode = true
        Boolean splitBamNamed = true
        Boolean runIsoseq3Refine = false
        Int limaCores = 2
        Int ccsCores = 2
        Int ccsChunks = 2
        Boolean generateFastq = false
        Map[String, String] dockerImages = {
            "bam2fastx": "quay.io/biocontainers/bam2fastx:1.3.0--he1c1bb9_8",
            "biowdl-input-converter": "quay.io/biocontainers/biowdl-input-converter:0.2.1--py_0",
            "ccs": "quay.io/biocontainers/pbccs:5.0.0--0",
            "fastqc": "quay.io/biocontainers/fastqc:0.11.9--0",
            "isoseq3": "quay.io/biocontainers/isoseq3:3.3.0--0",
            "lima": "quay.io/biocontainers/lima:1.11.0--0",
            "python3": "python:3.7-slim",
            "multiqc": "quay.io/biocontainers/multiqc:1.9--pyh9f0ad1d_0",
            "pacbio-merge": "lumc/pacbio-merge:0.2"
        }
    }

    meta {allowNestedInputs: true}

    # The name of the subreads, to be used to determine output filenames.
    File subreadsName = basename(subreadsFile, ".subreads.bam")

    # Get the CCS chunks.
    call ccsChunks as createChunks {
        input:
            chunkCount = ccsChunks,
            dockerImage = dockerImages["python3"]
    }

    # Index the input bamfile.
    if (!defined(subreadsIndexFile)) {
        call pbbam.Index as pbindex {
            input:
                bamFile = subreadsFile
        }
    }

    File subreadsIndex = select_first([pbindex.index, subreadsIndexFile])
    File subreadsBam = select_first([pbindex.indexedBam, subreadsFile])

    scatter (chunk in createChunks.chunks) {
        # Convert chunk from 1/10 to 1 to determine output filename.
        String chunkNumber = sub(chunk, "/.*$", "")

        call ccs.CCS as ccs {
            input:
                subreadsFile = subreadsBam,
                subreadsIndexFile = subreadsIndex,
                outputPrefix = subreadsName + "_chunk" + chunkNumber,
                cores = ccsCores,
                chunkString = chunk,
                dockerImage = dockerImages["ccs"]
        }
    }
    # Merge the bam files again.
    call samtools.Merge as merge {
        input:
            bamFiles = ccs.ccsBam,
            outputBamPath = subreadsName + ".ccs.bam"
    }

    # Merge the report for MultiQC.
    call mergePacBio as MergeCCSReport {
        input:
            reports = ccs.ccsReport,
            mergedReport = subreadsName + ".ccs.report.json"
    }

    call lima.Lima as lima {
        input:
            libraryDesign = libraryDesign,
            ccsMode = ccsMode,
            splitBamNamed = splitBamNamed,
            inputBamFile = merge.outputBam,
            barcodeFile = barcodesFasta,
            outputPrefix = subreadsName,
            cores = limaCores,
            dockerImage = dockerImages["lima"]
    }

    scatter (pair in zip(lima.limaBam, lima.limaBamIndex)) {
        File bamFile = pair.left
        File bamFileIndex = pair.right

        if (runIsoseq3Refine) {
            String refineOutputPrefix = sub(basename(bamFile, ".bam"), "fl", "flnc")
            call isoseq3.Refine as refine {
                input:
                    inputBamFile = bamFile,
                    inputBamIndex = bamFileIndex,
                    primerFile = barcodesFasta,
                    outputDir = "refine",
                    outputNamePrefix = refineOutputPrefix,
                    dockerImage = dockerImages["isoseq3"]
            }

            call fastqc.Fastqc as fastqcRefine {
                input:
                    seqFile = refine.refineBam,
                    outdirPath = "refine/" + basename(refine.refineBam, ".bam") + "-fastqc",
                    format = "bam",
                    threads = 4,
                    dockerImage = dockerImages["fastqc"]
            }

            if (generateFastq) {
                call bam2fastx.Bam2Fastq as bam2FastqRefine {
                    input:
                        bam = [refine.refineBam],
                        bamIndex = [refine.refineBamIndex],
                        outputPrefix =  "fastq-files/" + basename(refine.refineBam, ".bam"),
                        dockerImage = dockerImages["bam2fastx"]
                }
            }
        }

        if (! runIsoseq3Refine) {
            call fastqc.Fastqc as fastqcLima {
                input:
                    seqFile = bamFile,
                    outdirPath = basename(bamFile, ".bam") + "-fastqc",
                    format = "bam",
                    threads = 4,
                    dockerImage = dockerImages["fastqc"]
            }

            if (generateFastq) {
                call bam2fastx.Bam2Fastq as bam2FastqLima {
                    input:
                        bam = [bamFile],
                        bamIndex = [bamFileIndex],
                        outputPrefix = "fastq-files/" + basename(bamFile, ".bam"),
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


    Array[File] qualityReports = flatten([fastqcHtmlReport, fastqcZipReport])

    call multiqc.MultiQC as multiqcTask {
        input:
            reports = qualityReports,
            outDir = "multiqc",
            dataDir = true,
            dockerImage = dockerImages["multiqc"]
    }

    output {
        File ccsReads = merge.outputBam
        File ccsIndex = merge.outputBamIndex
        File ccsReport = MergeCCSReport.MergedReport
        Array[File] ccsStderr = ccs.ccsStderr
        Array[File] limaReads = lima.limaBam
        Array[File] limaIndex = lima.limaBamIndex
        Array[File] limaSubreadset = lima.limaXml
        File limaStderr = lima.limaStderr
        File limaJson = lima.limaJson
        File limaCounts = lima.limaCounts
        File limaReport = lima.limaReport
        File limaSummary = lima.limaSummary
        Array[String] samples = sampleName
        Array[File] workflowReports = qualityReports
        File multiqcReport = multiqcTask.multiqcReport
        File? multiqcZip = multiqcTask.multiqcDataDirZip
        Array[File?] fastqFiles = fastqFile
        Array[File?] refineReads = refine.refineBam
        Array[File?] refineIndex = refine.refineBamIndex
        Array[File?] refineConsensusReadset = refine.refineConsensusReadset
        Array[File?] refineSummary = refine.refineFilterSummary
        Array[File?] refineReport = refine.refineReport
        Array[File?] refineStderr = refine.refineStderr
    }

    parameter_meta {
        # inputs
        barcodesFasta: {description: "Fasta file with the barcodes used in the PacBio experiment.", category: "common"}
        subreadsFile: {description: "The PacBio subreads file that contains the raw PacBio reads.", category: "common"}
        subreadsIndexFile: {description: ".pbi file for the subreadsFile. If not specified, the subreadsFile will be indexed automatically." , category: "advanced"}
        libraryDesign: {description: "Barcode structure of the library design.", category: "advanced"}
        ccsMode: {description: "Ccs mode, use optimal alignment options.", category: "advanced"}
        splitBamNamed: {description: "Split bam file(s) by resolved barcode pair name.", category: "advanced"}
        generateFastq: {description: "Generate fastq files from demultiplexed bam files.", category: "common"}
        runIsoseq3Refine: {description: "Run isoseq3 refine for de-novo transcript reconstruction. Do not set this to true when analysing dna reads.", category: "advanced"}
        limaCores: {description: "The number of CPU cores to be used by lima.", category: "advanced"}
        ccsCores: {description: "The number of CPU cores to be used by ccs.", category: "advanced"}
        ccsChunks: {description: "The number of chunks to be used by ccs.", category: "advanced"}
        dockerImages: {description: "The docker image(s) used for this workflow. Changing this may result in errors which the developers may choose not to address.", category: "advanced"}

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

task ccsChunks {
    input {
        Int chunkCount
        String dockerImage = "python:3.7-slim"
    }

    command {
        set -e
        python <<CODE

        for i in range(1, ~{chunkCount} + 1):
            print(i, ~{chunkCount}, sep="/")
        CODE
    }

    runtime {
        docker: dockerImage
    }

    output {
        Array[String] chunks = read_lines(stdout())
    }
}

task mergePacBio {
    input {
        Array[File]+ reports
        String mergedReport
        String dockerImage = "lumc/pacbio-merge:0.2"
    }

    command {
        set -e
        mkdir -p $(dirname ~{mergedReport})
        pacbio_merge \
            --reports ~{sep=" " reports} \
            --json-output ~{mergedReport}
    }

    runtime {
        docker: dockerImage
    }

    output {
        File MergedReport = mergedReport
    }

    parameter_meta {
        # inputs
        reports: {description: "The PacBio report files to merge.", category: "required"}
        mergedReport: {description: "The location the merged PacBio report file should be written to.", category: "common"}
        dockerImage: {description: "The docker image used for this task. Changing this may result in errors which the developers may choose not to address.",
                      category: "advanced"}
    }
}
