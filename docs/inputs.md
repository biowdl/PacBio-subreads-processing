# SubreadsProcessing


## Inputs


### Required inputs
<p name="SubreadsProcessing.barcodesFasta">
        <b>SubreadsProcessing.barcodesFasta</b><br />
        <i>File &mdash; Default: None</i><br />
        Fasta file with the barcodes used in the PacBio experiment.
</p>
<p name="SubreadsProcessing.subreadsFile">
        <b>SubreadsProcessing.subreadsFile</b><br />
        <i>File &mdash; Default: None</i><br />
        The PacBio subreads file that contains the raw PacBio reads.
</p>

### Other common inputs
<p name="SubreadsProcessing.bam2FastqLima.outputRead2">
        <b>SubreadsProcessing.bam2FastqLima.outputRead2</b><br />
        <i>String? &mdash; Default: None</i><br />
        The location the second reads from pairs should be written to.
</p>
<p name="SubreadsProcessing.bam2FastqRefine.outputRead2">
        <b>SubreadsProcessing.bam2FastqRefine.outputRead2</b><br />
        <i>String? &mdash; Default: None</i><br />
        The location the second reads from pairs should be written to.
</p>
<p name="SubreadsProcessing.ccs.minReadQuality">
        <b>SubreadsProcessing.ccs.minReadQuality</b><br />
        <i>Float &mdash; Default: 0.99</i><br />
        Minimum predicted accuracy in [0, 1].
</p>
<p name="SubreadsProcessing.generateFastq">
        <b>SubreadsProcessing.generateFastq</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Generate fastq files from demultiplexed bam files.
</p>
<p name="SubreadsProcessing.lima.minLength">
        <b>SubreadsProcessing.lima.minLength</b><br />
        <i>Int &mdash; Default: 50</i><br />
        Minimum sequence length after clipping.
</p>
<p name="SubreadsProcessing.lima.minPasses">
        <b>SubreadsProcessing.lima.minPasses</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Minimal number of full passes.
</p>
<p name="SubreadsProcessing.lima.minScore">
        <b>SubreadsProcessing.lima.minScore</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Reads below the minimum barcode score are removed from downstream analysis.
</p>
<p name="SubreadsProcessing.lima.minScoreLead">
        <b>SubreadsProcessing.lima.minScoreLead</b><br />
        <i>Int &mdash; Default: 10</i><br />
        The minimal score lead required to call a barcode pair significant.
</p>
<p name="SubreadsProcessing.mergeBams.threads">
        <b>SubreadsProcessing.mergeBams.threads</b><br />
        <i>Int &mdash; Default: 1</i><br />
        Number of threads to use.
</p>
<p name="SubreadsProcessing.outputDirectory">
        <b>SubreadsProcessing.outputDirectory</b><br />
        <i>String &mdash; Default: "."</i><br />
        The directory in which the output files will be put.
</p>
<p name="SubreadsProcessing.pbIndex.outputBamPath">
        <b>SubreadsProcessing.pbIndex.outputBamPath</b><br />
        <i>String? &mdash; Default: None</i><br />
        The location where the BAM file should be written to. The index will appear alongside this link to the BAM file.
</p>
<p name="SubreadsProcessing.refine.requirePolyA">
        <b>SubreadsProcessing.refine.requirePolyA</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Require fl reads to have a poly(A) tail and remove it.
</p>

### Advanced inputs
<details>
<summary> Show/Hide </summary>
<p name="SubreadsProcessing.bam2FastqLima.appendReadNumber">
        <b>SubreadsProcessing.bam2FastqLima.appendReadNumber</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Append /1 and /2 to the read name, or don't. Corresponds to `-n/N`.
</p>
<p name="SubreadsProcessing.bam2FastqLima.excludeFilter">
        <b>SubreadsProcessing.bam2FastqLima.excludeFilter</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Exclude reads with ONE OR MORE of these flags. Corresponds to `-F`.
</p>
<p name="SubreadsProcessing.bam2FastqLima.excludeSpecificFilter">
        <b>SubreadsProcessing.bam2FastqLima.excludeSpecificFilter</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Exclude reads with ALL of these flags. Corresponds to `-G`.
</p>
<p name="SubreadsProcessing.bam2FastqLima.includeFilter">
        <b>SubreadsProcessing.bam2FastqLima.includeFilter</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Include reads with ALL of these flags. Corresponds to `-f`.
</p>
<p name="SubreadsProcessing.bam2FastqLima.memory">
        <b>SubreadsProcessing.bam2FastqLima.memory</b><br />
        <i>String &mdash; Default: "1G"</i><br />
        The amount of memory this job will use.
</p>
<p name="SubreadsProcessing.bam2FastqLima.timeMinutes">
        <b>SubreadsProcessing.bam2FastqLima.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(inputBam) * 2))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="SubreadsProcessing.bam2FastqRefine.appendReadNumber">
        <b>SubreadsProcessing.bam2FastqRefine.appendReadNumber</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Append /1 and /2 to the read name, or don't. Corresponds to `-n/N`.
</p>
<p name="SubreadsProcessing.bam2FastqRefine.excludeFilter">
        <b>SubreadsProcessing.bam2FastqRefine.excludeFilter</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Exclude reads with ONE OR MORE of these flags. Corresponds to `-F`.
</p>
<p name="SubreadsProcessing.bam2FastqRefine.excludeSpecificFilter">
        <b>SubreadsProcessing.bam2FastqRefine.excludeSpecificFilter</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Exclude reads with ALL of these flags. Corresponds to `-G`.
</p>
<p name="SubreadsProcessing.bam2FastqRefine.includeFilter">
        <b>SubreadsProcessing.bam2FastqRefine.includeFilter</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Include reads with ALL of these flags. Corresponds to `-f`.
</p>
<p name="SubreadsProcessing.bam2FastqRefine.memory">
        <b>SubreadsProcessing.bam2FastqRefine.memory</b><br />
        <i>String &mdash; Default: "1G"</i><br />
        The amount of memory this job will use.
</p>
<p name="SubreadsProcessing.bam2FastqRefine.timeMinutes">
        <b>SubreadsProcessing.bam2FastqRefine.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(inputBam) * 2))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="SubreadsProcessing.ccs.all">
        <b>SubreadsProcessing.ccs.all</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Emit all ZMWs.
</p>
<p name="SubreadsProcessing.ccs.allKinetics">
        <b>SubreadsProcessing.ccs.allKinetics</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Calculate mean pulse widths (PW) and interpulse durations (IPD) for every ZMW.
</p>
<p name="SubreadsProcessing.ccs.byStrand">
        <b>SubreadsProcessing.ccs.byStrand</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Generate a consensus for each strand.
</p>
<p name="SubreadsProcessing.ccs.hifiKinetics">
        <b>SubreadsProcessing.ccs.hifiKinetics</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Calculate mean pulse widths (PW) and interpulse durations (IPD) for every HiFi read.
</p>
<p name="SubreadsProcessing.ccs.logLevel">
        <b>SubreadsProcessing.ccs.logLevel</b><br />
        <i>String &mdash; Default: "WARN"</i><br />
        Set log level. Valid choices: (TRACE, DEBUG, INFO, WARN, FATAL).
</p>
<p name="SubreadsProcessing.ccs.maxLength">
        <b>SubreadsProcessing.ccs.maxLength</b><br />
        <i>Int &mdash; Default: 50000</i><br />
        Maximum draft length before polishing.
</p>
<p name="SubreadsProcessing.ccs.memory">
        <b>SubreadsProcessing.ccs.memory</b><br />
        <i>String &mdash; Default: "4G"</i><br />
        The amount of memory available to the job.
</p>
<p name="SubreadsProcessing.ccs.minLength">
        <b>SubreadsProcessing.ccs.minLength</b><br />
        <i>Int &mdash; Default: 10</i><br />
        Minimum draft length before polishing.
</p>
<p name="SubreadsProcessing.ccs.minPasses">
        <b>SubreadsProcessing.ccs.minPasses</b><br />
        <i>Int &mdash; Default: 3</i><br />
        Minimum number of full-length subreads required to generate ccs for a ZMW.
</p>
<p name="SubreadsProcessing.ccs.minSnr">
        <b>SubreadsProcessing.ccs.minSnr</b><br />
        <i>Float &mdash; Default: 2.5</i><br />
        Minimum SNR of subreads to use for generating CCS.
</p>
<p name="SubreadsProcessing.ccs.skipPolish">
        <b>SubreadsProcessing.ccs.skipPolish</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Only output the initial draft template (faster, less accurate).
</p>
<p name="SubreadsProcessing.ccs.subreadFallback">
        <b>SubreadsProcessing.ccs.subreadFallback</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Emit a representative subread, instead of the draft consensus, if polishing failed.
</p>
<p name="SubreadsProcessing.ccs.timeMinutes">
        <b>SubreadsProcessing.ccs.timeMinutes</b><br />
        <i>Int &mdash; Default: 1440</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="SubreadsProcessing.ccs.topPasses">
        <b>SubreadsProcessing.ccs.topPasses</b><br />
        <i>Int &mdash; Default: 60</i><br />
        Pick at maximum the top N passes for each ZMW.
</p>
<p name="SubreadsProcessing.ccsChunks">
        <b>SubreadsProcessing.ccsChunks</b><br />
        <i>Int &mdash; Default: 2</i><br />
        The number of chunks to be used by ccs.
</p>
<p name="SubreadsProcessing.ccsMode">
        <b>SubreadsProcessing.ccsMode</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Ccs mode, use optimal alignment options.
</p>
<p name="SubreadsProcessing.ccsThreads">
        <b>SubreadsProcessing.ccsThreads</b><br />
        <i>Int &mdash; Default: 2</i><br />
        The number of CPU threads to be used by ccs.
</p>
<p name="SubreadsProcessing.createChunks.memory">
        <b>SubreadsProcessing.createChunks.memory</b><br />
        <i>String &mdash; Default: "4G"</i><br />
        The amount of memory this job will use.
</p>
<p name="SubreadsProcessing.dockerImages">
        <b>SubreadsProcessing.dockerImages</b><br />
        <i>Map[String,String] &mdash; Default: {"biowdl-input-converter": "quay.io/biocontainers/biowdl-input-converter:0.3.0--pyhdfd78af_0", "ccs": "quay.io/biocontainers/pbccs:6.0.0--h9ee0642_2", "fastqc": "quay.io/biocontainers/fastqc:0.11.9--hdfd78af_1", "isoseq3": "quay.io/biocontainers/isoseq3:3.4.0--0", "lima": "quay.io/biocontainers/lima:2.2.0--h9ee0642_0", "python3": "python:3.7-slim", "multiqc": "quay.io/biocontainers/multiqc:1.10.1--pyhdfd78af_1", "pbbam": "quay.io/biocontainers/pbbam:1.6.0--h058f120_1", "samtools": "quay.io/biocontainers/samtools:1.12--h9aed4be_1"}</i><br />
        The docker image(s) used for this workflow. Changing this may result in errors which the developers may choose not to address.
</p>
<p name="SubreadsProcessing.fastqcLima.adapters">
        <b>SubreadsProcessing.fastqcLima.adapters</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to fastqc's --adapters option.
</p>
<p name="SubreadsProcessing.fastqcLima.casava">
        <b>SubreadsProcessing.fastqcLima.casava</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --casava flag.
</p>
<p name="SubreadsProcessing.fastqcLima.contaminants">
        <b>SubreadsProcessing.fastqcLima.contaminants</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to fastqc's --contaminants option.
</p>
<p name="SubreadsProcessing.fastqcLima.dir">
        <b>SubreadsProcessing.fastqcLima.dir</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to fastqc's --dir option.
</p>
<p name="SubreadsProcessing.fastqcLima.extract">
        <b>SubreadsProcessing.fastqcLima.extract</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --extract flag.
</p>
<p name="SubreadsProcessing.fastqcLima.javaXmx">
        <b>SubreadsProcessing.fastqcLima.javaXmx</b><br />
        <i>String &mdash; Default: "1750M"</i><br />
        The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</p>
<p name="SubreadsProcessing.fastqcLima.kmers">
        <b>SubreadsProcessing.fastqcLima.kmers</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Equivalent to fastqc's --kmers option.
</p>
<p name="SubreadsProcessing.fastqcLima.limits">
        <b>SubreadsProcessing.fastqcLima.limits</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to fastqc's --limits option.
</p>
<p name="SubreadsProcessing.fastqcLima.memory">
        <b>SubreadsProcessing.fastqcLima.memory</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The amount of memory this job will use.
</p>
<p name="SubreadsProcessing.fastqcLima.minLength">
        <b>SubreadsProcessing.fastqcLima.minLength</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Equivalent to fastqc's --min_length option.
</p>
<p name="SubreadsProcessing.fastqcLima.nano">
        <b>SubreadsProcessing.fastqcLima.nano</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --nano flag.
</p>
<p name="SubreadsProcessing.fastqcLima.noFilter">
        <b>SubreadsProcessing.fastqcLima.noFilter</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --nofilter flag.
</p>
<p name="SubreadsProcessing.fastqcLima.nogroup">
        <b>SubreadsProcessing.fastqcLima.nogroup</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --nogroup flag.
</p>
<p name="SubreadsProcessing.fastqcLima.timeMinutes">
        <b>SubreadsProcessing.fastqcLima.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil(size(seqFile,"G")) * 4</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="SubreadsProcessing.fastqcRefine.adapters">
        <b>SubreadsProcessing.fastqcRefine.adapters</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to fastqc's --adapters option.
</p>
<p name="SubreadsProcessing.fastqcRefine.casava">
        <b>SubreadsProcessing.fastqcRefine.casava</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --casava flag.
</p>
<p name="SubreadsProcessing.fastqcRefine.contaminants">
        <b>SubreadsProcessing.fastqcRefine.contaminants</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to fastqc's --contaminants option.
</p>
<p name="SubreadsProcessing.fastqcRefine.dir">
        <b>SubreadsProcessing.fastqcRefine.dir</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to fastqc's --dir option.
</p>
<p name="SubreadsProcessing.fastqcRefine.extract">
        <b>SubreadsProcessing.fastqcRefine.extract</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --extract flag.
</p>
<p name="SubreadsProcessing.fastqcRefine.javaXmx">
        <b>SubreadsProcessing.fastqcRefine.javaXmx</b><br />
        <i>String &mdash; Default: "1750M"</i><br />
        The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</p>
<p name="SubreadsProcessing.fastqcRefine.kmers">
        <b>SubreadsProcessing.fastqcRefine.kmers</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Equivalent to fastqc's --kmers option.
</p>
<p name="SubreadsProcessing.fastqcRefine.limits">
        <b>SubreadsProcessing.fastqcRefine.limits</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to fastqc's --limits option.
</p>
<p name="SubreadsProcessing.fastqcRefine.memory">
        <b>SubreadsProcessing.fastqcRefine.memory</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The amount of memory this job will use.
</p>
<p name="SubreadsProcessing.fastqcRefine.minLength">
        <b>SubreadsProcessing.fastqcRefine.minLength</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Equivalent to fastqc's --min_length option.
</p>
<p name="SubreadsProcessing.fastqcRefine.nano">
        <b>SubreadsProcessing.fastqcRefine.nano</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --nano flag.
</p>
<p name="SubreadsProcessing.fastqcRefine.noFilter">
        <b>SubreadsProcessing.fastqcRefine.noFilter</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --nofilter flag.
</p>
<p name="SubreadsProcessing.fastqcRefine.nogroup">
        <b>SubreadsProcessing.fastqcRefine.nogroup</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --nogroup flag.
</p>
<p name="SubreadsProcessing.fastqcRefine.timeMinutes">
        <b>SubreadsProcessing.fastqcRefine.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil(size(seqFile,"G")) * 4</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="SubreadsProcessing.fastqcThreads">
        <b>SubreadsProcessing.fastqcThreads</b><br />
        <i>Int &mdash; Default: 4</i><br />
        The number of CPU threads to be used by fastQC.
</p>
<p name="SubreadsProcessing.libraryDesign">
        <b>SubreadsProcessing.libraryDesign</b><br />
        <i>String &mdash; Default: "same"</i><br />
        Barcode structure of the library design.
</p>
<p name="SubreadsProcessing.lima.guess">
        <b>SubreadsProcessing.lima.guess</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Try to guess the used barcodes, using the provided mean score threshold, 0 means guessing deactivated.
</p>
<p name="SubreadsProcessing.lima.guessMinCount">
        <b>SubreadsProcessing.lima.guessMinCount</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Minimum number of ZMWs observed to whitelist barcodes.
</p>
<p name="SubreadsProcessing.lima.logLevel">
        <b>SubreadsProcessing.lima.logLevel</b><br />
        <i>String &mdash; Default: "WARN"</i><br />
        Set log level. Valid choices: (TRACE, DEBUG, INFO, WARN, FATAL).
</p>
<p name="SubreadsProcessing.lima.maxInputLength">
        <b>SubreadsProcessing.lima.maxInputLength</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Maximum input sequence length, 0 means deactivated.
</p>
<p name="SubreadsProcessing.lima.maxScoredAdapters">
        <b>SubreadsProcessing.lima.maxScoredAdapters</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Analyze at maximum the provided number of adapters per ZMW, 0 means deactivated.
</p>
<p name="SubreadsProcessing.lima.maxScoredBarcodePairs">
        <b>SubreadsProcessing.lima.maxScoredBarcodePairs</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Only use up to N barcode pair regions to find the barcode, 0 means use all.
</p>
<p name="SubreadsProcessing.lima.maxScoredBarcodes">
        <b>SubreadsProcessing.lima.maxScoredBarcodes</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Analyze at maximum the provided number of barcodes per ZMW, 0 means deactivated.
</p>
<p name="SubreadsProcessing.lima.memory">
        <b>SubreadsProcessing.lima.memory</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The amount of memory available to the job.
</p>
<p name="SubreadsProcessing.lima.minEndScore">
        <b>SubreadsProcessing.lima.minEndScore</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Minimum end barcode score threshold is applied to the individual leading and trailing ends.
</p>
<p name="SubreadsProcessing.lima.minRefSpan">
        <b>SubreadsProcessing.lima.minRefSpan</b><br />
        <i>Float &mdash; Default: 0.5</i><br />
        Minimum reference span relative to the barcode length.
</p>
<p name="SubreadsProcessing.lima.minScoringRegion">
        <b>SubreadsProcessing.lima.minScoringRegion</b><br />
        <i>Int &mdash; Default: 1</i><br />
        Minimum number of barcode regions with sufficient relative span to the barcode length.
</p>
<p name="SubreadsProcessing.lima.minSignalIncrease">
        <b>SubreadsProcessing.lima.minSignalIncrease</b><br />
        <i>Int &mdash; Default: 10</i><br />
        The minimal score difference, between first and combined, required to call a barcode pair different.
</p>
<p name="SubreadsProcessing.lima.peek">
        <b>SubreadsProcessing.lima.peek</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Demux the first N ZMWs and return the mean score, 0 means peeking deactivated.
</p>
<p name="SubreadsProcessing.lima.peekGuess">
        <b>SubreadsProcessing.lima.peekGuess</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Try to infer the used barcodes subset, by peeking at the first 50,000 ZMWs.
</p>
<p name="SubreadsProcessing.lima.scoredAdapterRatio">
        <b>SubreadsProcessing.lima.scoredAdapterRatio</b><br />
        <i>Float &mdash; Default: 0.25</i><br />
        Minimum ratio of scored vs sequenced adapters.
</p>
<p name="SubreadsProcessing.lima.scoreFullPass">
        <b>SubreadsProcessing.lima.scoreFullPass</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Only use subreads flanked by adapters for barcode identification.
</p>
<p name="SubreadsProcessing.lima.timeMinutes">
        <b>SubreadsProcessing.lima.timeMinutes</b><br />
        <i>Int &mdash; Default: 30</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="SubreadsProcessing.limaThreads">
        <b>SubreadsProcessing.limaThreads</b><br />
        <i>Int &mdash; Default: 2</i><br />
        The number of CPU threads to be used by lima.
</p>
<p name="SubreadsProcessing.mergeBams.force">
        <b>SubreadsProcessing.mergeBams.force</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to samtools merge's `-f` flag.
</p>
<p name="SubreadsProcessing.mergeBams.memory">
        <b>SubreadsProcessing.mergeBams.memory</b><br />
        <i>String &mdash; Default: "4G"</i><br />
        The amount of memory this job will use.
</p>
<p name="SubreadsProcessing.mergeBams.timeMinutes">
        <b>SubreadsProcessing.mergeBams.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(bamFiles,"G") * 2))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="SubreadsProcessing.multiqcTask.clConfig">
        <b>SubreadsProcessing.multiqcTask.clConfig</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--cl-config` option.
</p>
<p name="SubreadsProcessing.multiqcTask.comment">
        <b>SubreadsProcessing.multiqcTask.comment</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--comment` option.
</p>
<p name="SubreadsProcessing.multiqcTask.config">
        <b>SubreadsProcessing.multiqcTask.config</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--config` option.
</p>
<p name="SubreadsProcessing.multiqcTask.dataFormat">
        <b>SubreadsProcessing.multiqcTask.dataFormat</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--data-format` option.
</p>
<p name="SubreadsProcessing.multiqcTask.dirs">
        <b>SubreadsProcessing.multiqcTask.dirs</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--dirs` flag.
</p>
<p name="SubreadsProcessing.multiqcTask.dirsDepth">
        <b>SubreadsProcessing.multiqcTask.dirsDepth</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--dirs-depth` option.
</p>
<p name="SubreadsProcessing.multiqcTask.exclude">
        <b>SubreadsProcessing.multiqcTask.exclude</b><br />
        <i>Array[String]+? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--exclude` option.
</p>
<p name="SubreadsProcessing.multiqcTask.export">
        <b>SubreadsProcessing.multiqcTask.export</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--export` flag.
</p>
<p name="SubreadsProcessing.multiqcTask.fileList">
        <b>SubreadsProcessing.multiqcTask.fileList</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--file-list` option.
</p>
<p name="SubreadsProcessing.multiqcTask.fileName">
        <b>SubreadsProcessing.multiqcTask.fileName</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--filename` option.
</p>
<p name="SubreadsProcessing.multiqcTask.flat">
        <b>SubreadsProcessing.multiqcTask.flat</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--flat` flag.
</p>
<p name="SubreadsProcessing.multiqcTask.force">
        <b>SubreadsProcessing.multiqcTask.force</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--force` flag.
</p>
<p name="SubreadsProcessing.multiqcTask.fullNames">
        <b>SubreadsProcessing.multiqcTask.fullNames</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--fullnames` flag.
</p>
<p name="SubreadsProcessing.multiqcTask.ignore">
        <b>SubreadsProcessing.multiqcTask.ignore</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--ignore` option.
</p>
<p name="SubreadsProcessing.multiqcTask.ignoreSamples">
        <b>SubreadsProcessing.multiqcTask.ignoreSamples</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--ignore-samples` option.
</p>
<p name="SubreadsProcessing.multiqcTask.interactive">
        <b>SubreadsProcessing.multiqcTask.interactive</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to MultiQC's `--interactive` flag.
</p>
<p name="SubreadsProcessing.multiqcTask.lint">
        <b>SubreadsProcessing.multiqcTask.lint</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--lint` flag.
</p>
<p name="SubreadsProcessing.multiqcTask.megaQCUpload">
        <b>SubreadsProcessing.multiqcTask.megaQCUpload</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Opposite to MultiQC's `--no-megaqc-upload` flag.
</p>
<p name="SubreadsProcessing.multiqcTask.memory">
        <b>SubreadsProcessing.multiqcTask.memory</b><br />
        <i>String? &mdash; Default: None</i><br />
        The amount of memory this job will use.
</p>
<p name="SubreadsProcessing.multiqcTask.module">
        <b>SubreadsProcessing.multiqcTask.module</b><br />
        <i>Array[String]+? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--module` option.
</p>
<p name="SubreadsProcessing.multiqcTask.pdf">
        <b>SubreadsProcessing.multiqcTask.pdf</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--pdf` flag.
</p>
<p name="SubreadsProcessing.multiqcTask.sampleNames">
        <b>SubreadsProcessing.multiqcTask.sampleNames</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--sample-names` option.
</p>
<p name="SubreadsProcessing.multiqcTask.tag">
        <b>SubreadsProcessing.multiqcTask.tag</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--tag` option.
</p>
<p name="SubreadsProcessing.multiqcTask.template">
        <b>SubreadsProcessing.multiqcTask.template</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--template` option.
</p>
<p name="SubreadsProcessing.multiqcTask.timeMinutes">
        <b>SubreadsProcessing.multiqcTask.timeMinutes</b><br />
        <i>Int &mdash; Default: 10 + ceil((size(reports,"G") * 8))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="SubreadsProcessing.multiqcTask.title">
        <b>SubreadsProcessing.multiqcTask.title</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--title` option.
</p>
<p name="SubreadsProcessing.multiqcTask.zipDataDir">
        <b>SubreadsProcessing.multiqcTask.zipDataDir</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to MultiQC's `--zip-data-dir` flag.
</p>
<p name="SubreadsProcessing.pbIndex.memory">
        <b>SubreadsProcessing.pbIndex.memory</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The amount of memory needed for the job.
</p>
<p name="SubreadsProcessing.pbIndex.timeMinutes">
        <b>SubreadsProcessing.pbIndex.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(bamFile,"G") * 4))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="SubreadsProcessing.refine.logLevel">
        <b>SubreadsProcessing.refine.logLevel</b><br />
        <i>String &mdash; Default: "WARN"</i><br />
        Set log level. Valid choices: (TRACE, DEBUG, INFO, WARN, FATAL).
</p>
<p name="SubreadsProcessing.refine.memory">
        <b>SubreadsProcessing.refine.memory</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The amount of memory available to the job.
</p>
<p name="SubreadsProcessing.refine.minPolyALength">
        <b>SubreadsProcessing.refine.minPolyALength</b><br />
        <i>Int &mdash; Default: 20</i><br />
        Minimum poly(A) tail length.
</p>
<p name="SubreadsProcessing.refine.threads">
        <b>SubreadsProcessing.refine.threads</b><br />
        <i>Int &mdash; Default: 2</i><br />
        The number of threads to be used.
</p>
<p name="SubreadsProcessing.refine.timeMinutes">
        <b>SubreadsProcessing.refine.timeMinutes</b><br />
        <i>Int &mdash; Default: 30</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="SubreadsProcessing.runIsoseq3Refine">
        <b>SubreadsProcessing.runIsoseq3Refine</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Run isoseq3 refine for de-novo transcript reconstruction. Do not set this to true when analysing dna reads.
</p>
<p name="SubreadsProcessing.splitBamNamed">
        <b>SubreadsProcessing.splitBamNamed</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Split bam file(s) by resolved barcode pair name.
</p>
<p name="SubreadsProcessing.subreadsIndexFile">
        <b>SubreadsProcessing.subreadsIndexFile</b><br />
        <i>File? &mdash; Default: None</i><br />
        .pbi file for the subreadsFile. If not specified, the subreadsFile will be indexed automatically.
</p>
</details>








<hr />

> Generated using WDL AID (0.1.1)
