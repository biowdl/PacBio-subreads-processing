version 1.0

# Copyright (c) 2019 Leiden University Medical Center
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import "tasks/ccs.wdl" as ccs
import "tasks/fastqc.wdl" as fastqc
import "tasks/isoseq3.wdl" as isoseq3
import "tasks/lima.wdl" as lima
import "tasks/multiqc.wdl" as multiqc
import "tasks/pacbio.wdl" as pacbio
import "tasks/pbbam.wdl" as pbbam
import "/exports/sasc/jboom/WDL/UPDATE/tasks/samtools.wdl" as samtools

workflow SubreadsProcessing {
    input {
        File subreadsFile
        File barcodesFasta
        String libraryDesign = "same"
        String outputDirectory = "."
        Int ccsChunks = 2
        Boolean ccsMode = true
        Boolean splitBamNamed = true
        Boolean runIsoseq3Refine = false
        Boolean generateFastq = false

        File? subreadsIndexFile

        Int limaThreads = 2
        Int ccsThreads = 2
        Int fastqcThreads = 4
        Map[String, String] dockerImages = {
            "biowdl-input-converter": "quay.io/biocontainers/biowdl-input-converter:0.3.0--pyhdfd78af_0",
            "ccs": "quay.io/biocontainers/pbccs:6.0.0--h9ee0642_2",
            "fastqc": "quay.io/biocontainers/fastqc:0.11.9--hdfd78af_1",
            "isoseq3": "quay.io/biocontainers/isoseq3:3.4.0--0",
            "lima": "quay.io/biocontainers/lima:2.2.0--h9ee0642_0",
            "python3": "python:3.7-slim",
            "multiqc": "quay.io/biocontainers/multiqc:1.10.1--pyhdfd78af_1",
            "pbbam": "quay.io/biocontainers/pbbam:1.6.0--h058f120_1",
            "samtools": "quay.io/biocontainers/samtools:1.12--h9aed4be_1"
        }
    }

    meta {
        allowNestedInputs: true
    }

    # The name of the subreads, to be used to determine output filenames.
    File subreadsName = basename(subreadsFile, ".subreads.bam")

    # Get the CCS chunks.
    call pacbio.ccsChunks as createChunks {
        input:
            chunkCount = ccsChunks,
            dockerImage = dockerImages["python3"]
    }

    # Index the input bamfile.
    if (!defined(subreadsIndexFile)) {
        call pbbam.Index as pbIndex {
            input:
                bamFile = subreadsFile,
                dockerImage = dockerImages["pbbam"]
        }
    }

    File subreadsIndex = select_first([pbIndex.index, subreadsIndexFile])
    File subreadsBam = select_first([pbIndex.indexedBam, subreadsFile])

    scatter (chunk in createChunks.chunks) {
        # Convert chunk from 1/10 to 1 to determine output filename.
        String chunkNumber = sub(chunk, "/.*$", "")

        call ccs.CCS as ccs {
            input:
                subreadsFile = subreadsBam,
                subreadsIndexFile = subreadsIndex,
                outputPrefix = outputDirectory + "/ccs/" + subreadsName + ".chunk." + chunkNumber,
                threads = ccsThreads,
                chunkString = chunk,
                dockerImage = dockerImages["ccs"]
        }
    }

    # Merge the bam files again.
    call samtools.Merge as mergeBams {
        input:
            bamFiles = ccs.ccsBam,
            outputBamPath = outputDirectory + "/ccs/" + subreadsName + ".merged.ccs.bam",
            dockerImage = dockerImages["samtools"]
    }

    call lima.Lima as lima {
        input:
            libraryDesign = libraryDesign,
            ccsMode = ccsMode,
            splitBamNamed = splitBamNamed,
            inputBamFile = mergeBams.outputBam,
            barcodeFile = barcodesFasta,
            outputPrefix = outputDirectory + "/lima/" + subreadsName,
            threads = limaThreads,
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
                    outputDir = outputDirectory + "/refine",
                    outputNamePrefix = refineOutputPrefix,
                    dockerImage = dockerImages["isoseq3"]
            }

            call fastqc.Fastqc as fastqcRefine {
                input:
                    seqFile = refine.refineBam,
                    outdirPath = outputDirectory + "/fastqc/" + basename(refine.refineBam, ".bam") + "-fastqc",
                    format = "bam",
                    threads = fastqcThreads,
                    dockerImage = dockerImages["fastqc"]
            }

            if (generateFastq) {
                call samtools.Fastq as bam2FastqRefine {
                    input:
                        inputBam = refine.refineBam,
                        outputRead1 = outputDirectory + "/fastq-files/" + basename(refine.refineBam, ".bam") + "_temp.fastq.gz",
                        outputRead0 = outputDirectory + "/fastq-files/" + basename(refine.refineBam, ".bam") + ".fastq.gz",
                        outputQuality = true,
                        compressionLevel = 1,
                        threads = 3,
                        dockerImage = dockerImages["samtools"]
                }
            }
        }

        if (!runIsoseq3Refine) {
            call fastqc.Fastqc as fastqcLima {
                input:
                    seqFile = bamFile,
                    outdirPath = outputDirectory + "/fastqc/" + basename(bamFile, ".bam") + "-fastqc",
                    format = "bam",
                    threads = fastqcThreads,
                    dockerImage = dockerImages["fastqc"]
            }

            if (generateFastq) {
                call samtools.Fastq as bam2FastqLima {
                    input:
                        inputBam = bamFile,
                        outputRead1 = outputDirectory + "/fastq-files/" + basename(bamFile, ".bam") + "_temp.fastq.gz",
                        outputRead0 = outputDirectory + "/fastq-files/" + basename(bamFile, ".bam") + ".fastq.gz",
                        outputQuality = true,
                        compressionLevel = 1,
                        threads = 3,
                        dockerImage = dockerImages["samtools"]
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
            File? fastqFile = select_first([bam2FastqRefine.read0, bam2FastqLima.read0])
            File? extraFastqFile = select_first([bam2FastqRefine.read1, bam2FastqLima.read1])
        }
    }

    Array[File] qualityReports = flatten([fastqcHtmlReport, fastqcZipReport])

    call multiqc.MultiQC as multiqcTask {
        input:
            reports = qualityReports,
            outDir = outputDirectory + "/multiqc",
            dataDir = true,
            dockerImage = dockerImages["multiqc"]
    }

    output {
        File ccsReads = mergeBams.outputBam
        File ccsIndex = mergeBams.outputBamIndex
        Array[File] ccsReport = ccs.ccsReport
        Array[File] ccsJsonReport = ccs.ccsJsonReport
        Array[File] ccsStderr = ccs.ccsStderr
        Array[File] zmwMetrics = ccs.zmwMetrics
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
        Array[File?] extraFastqFiles = extraFastqFile
        Array[File?] refineReads = refine.refineBam
        Array[File?] refineIndex = refine.refineBamIndex
        Array[File?] refineConsensusReadset = refine.refineConsensusReadset
        Array[File?] refineSummary = refine.refineFilterSummary
        Array[File?] refineReport = refine.refineReport
        Array[File?] refineStderr = refine.refineStderr
    }

    parameter_meta {
        # inputs
        subreadsFile: {description: "The PacBio subreads file that contains the raw PacBio reads.", category: "common"}
        barcodesFasta: {description: "Fasta file with the barcodes used in the PacBio experiment.", category: "common"}
        libraryDesign: {description: "Barcode structure of the library design.", category: "advanced"}
        ccsMode: {description: "Ccs mode, use optimal alignment options.", category: "advanced"}
        splitBamNamed: {description: "Split bam file(s) by resolved barcode pair name.", category: "advanced"}
        runIsoseq3Refine: {description: "Run isoseq3 refine for de-novo transcript reconstruction. Do not set this to true when analysing dna reads.", category: "advanced"}
        ccsChunks: {description: "The number of chunks to be used by ccs.", category: "advanced"}
        generateFastq: {description: "Generate fastq files from demultiplexed bam files.", category: "common"}
        outputDirectory: {description: "The directory in which the output files will be put.", category: "common"}
        subreadsIndexFile: {description: ".pbi file for the subreadsFile. If not specified, the subreadsFile will be indexed automatically." , category: "advanced"}
        limaThreads: {description: "The number of CPU threads to be used by lima.", category: "advanced"}
        ccsThreads: {description: "The number of CPU threads to be used by ccs.", category: "advanced"}
        fastqcThreads: {description: "The number of CPU threads to be used by fastQC.", category: "advanced"}
        dockerImages: {description: "The docker image(s) used for this workflow. Changing this may result in errors which the developers may choose not to address.", category: "advanced"}

        # outputs
        ccsReads: {description: "Consensus reads file(s)."}
        ccsIndex: {description: "Index of consensus reads file(s)."}
        ccsReport: {description: "Ccs report file(s)."}
        ccsJsonReport: {description: "Ccs results json report file(s)."}
        ccsStderr: {description: "Ccs stderr log file(s)."}
        zmwMetrics: {description: "ZMW metrics json file(s)."}
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
        extraFastqFiles: {description: "Extra fastq files extracted from bam files."}
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
