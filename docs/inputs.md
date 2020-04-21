# SubreadsProcessing


## Inputs


### Required inputs
<p name="SubreadsProcessing.dockerImagesFile">
        <b>SubreadsProcessing.dockerImagesFile</b><br />
        <i>File &mdash; Default: None</i><br />
        The docker image used for this workflow. Changing this may result in errors which the developers may choose not to address.
</p>
<p name="SubreadsProcessing.subreadsConfigFile">
        <b>SubreadsProcessing.subreadsConfigFile</b><br />
        <i>File &mdash; Default: None</i><br />
        Configuration file describing input subread BAMs and barcode files.
</p>

### Other common inputs
<p name="SubreadsProcessing.executeCCS.minReadQuality">
        <b>SubreadsProcessing.executeCCS.minReadQuality</b><br />
        <i>Float &mdash; Default: 0.99</i><br />
        Minimum predicted accuracy in [0, 1].
</p>
<p name="SubreadsProcessing.executeLima.minLength">
        <b>SubreadsProcessing.executeLima.minLength</b><br />
        <i>Int &mdash; Default: 50</i><br />
        Minimum sequence length after clipping.
</p>
<p name="SubreadsProcessing.executeLima.minPasses">
        <b>SubreadsProcessing.executeLima.minPasses</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Minimal number of full passes.
</p>
<p name="SubreadsProcessing.executeLima.minScore">
        <b>SubreadsProcessing.executeLima.minScore</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Reads below the minimum barcode score are removed from downstream analysis.
</p>
<p name="SubreadsProcessing.executeLima.minScoreLead">
        <b>SubreadsProcessing.executeLima.minScoreLead</b><br />
        <i>Int &mdash; Default: 10</i><br />
        The minimal score lead required to call a barcode pair significant.
</p>
<p name="SubreadsProcessing.executeRefine.requirePolyA">
        <b>SubreadsProcessing.executeRefine.requirePolyA</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Require FL reads to have a poly(A) tail and remove it.
</p>

### Advanced inputs
<details>
<summary> Show/Hide </summary>
<p name="SubreadsProcessing.ccsMode">
        <b>SubreadsProcessing.ccsMode</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        CCS mode, use optimal alignment options.
</p>
<p name="SubreadsProcessing.convertDockerImagesFile.dockerImage">
        <b>SubreadsProcessing.convertDockerImagesFile.dockerImage</b><br />
        <i>String &mdash; Default: "quay.io/biocontainers/biowdl-input-converter:0.2.1--py_0"</i><br />
        The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</p>
<p name="SubreadsProcessing.executeCCS.byStrand">
        <b>SubreadsProcessing.executeCCS.byStrand</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Generate a consensus for each strand.
</p>
<p name="SubreadsProcessing.executeCCS.cores">
        <b>SubreadsProcessing.executeCCS.cores</b><br />
        <i>Int &mdash; Default: 2</i><br />
        The number of cores to be used.
</p>
<p name="SubreadsProcessing.executeCCS.logLevel">
        <b>SubreadsProcessing.executeCCS.logLevel</b><br />
        <i>String &mdash; Default: "WARN"</i><br />
        Set log level. Valid choices: (TRACE, DEBUG, INFO, WARN, FATAL).
</p>
<p name="SubreadsProcessing.executeCCS.maxLength">
        <b>SubreadsProcessing.executeCCS.maxLength</b><br />
        <i>Int &mdash; Default: 50000</i><br />
        Maximum draft length before polishing.
</p>
<p name="SubreadsProcessing.executeCCS.memory">
        <b>SubreadsProcessing.executeCCS.memory</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The amount of memory available to the job.
</p>
<p name="SubreadsProcessing.executeCCS.minLength">
        <b>SubreadsProcessing.executeCCS.minLength</b><br />
        <i>Int &mdash; Default: 10</i><br />
        Minimum draft length before polishing.
</p>
<p name="SubreadsProcessing.executeCCS.minPasses">
        <b>SubreadsProcessing.executeCCS.minPasses</b><br />
        <i>Int &mdash; Default: 3</i><br />
        Minimum number of full-length subreads required to generate CCS for a ZMW.
</p>
<p name="SubreadsProcessing.executeLima.cores">
        <b>SubreadsProcessing.executeLima.cores</b><br />
        <i>Int &mdash; Default: 2</i><br />
        The number of cores to be used.
</p>
<p name="SubreadsProcessing.executeLima.guess">
        <b>SubreadsProcessing.executeLima.guess</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Try to guess the used barcodes, using the provided mean score threshold, 0 means guessing deactivated.
</p>
<p name="SubreadsProcessing.executeLima.guessMinCount">
        <b>SubreadsProcessing.executeLima.guessMinCount</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Minimum number of ZMWs observed to whitelist barcodes.
</p>
<p name="SubreadsProcessing.executeLima.logLevel">
        <b>SubreadsProcessing.executeLima.logLevel</b><br />
        <i>String &mdash; Default: "WARN"</i><br />
        Set log level. Valid choices: (TRACE, DEBUG, INFO, WARN, FATAL).
</p>
<p name="SubreadsProcessing.executeLima.maxInputLength">
        <b>SubreadsProcessing.executeLima.maxInputLength</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Maximum input sequence length, 0 means deactivated.
</p>
<p name="SubreadsProcessing.executeLima.maxScoredAdapters">
        <b>SubreadsProcessing.executeLima.maxScoredAdapters</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Analyze at maximum the provided number of adapters per ZMW, 0 means deactivated.
</p>
<p name="SubreadsProcessing.executeLima.maxScoredBarcodePairs">
        <b>SubreadsProcessing.executeLima.maxScoredBarcodePairs</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Only use up to N barcode pair regions to find the barcode, 0 means use all.
</p>
<p name="SubreadsProcessing.executeLima.maxScoredBarcodes">
        <b>SubreadsProcessing.executeLima.maxScoredBarcodes</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Analyze at maximum the provided number of barcodes per ZMW, 0 means deactivated.
</p>
<p name="SubreadsProcessing.executeLima.memory">
        <b>SubreadsProcessing.executeLima.memory</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The amount of memory available to the job.
</p>
<p name="SubreadsProcessing.executeLima.minEndScore">
        <b>SubreadsProcessing.executeLima.minEndScore</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Minimum end barcode score threshold is applied to the individual leading and trailing ends.
</p>
<p name="SubreadsProcessing.executeLima.minRefSpan">
        <b>SubreadsProcessing.executeLima.minRefSpan</b><br />
        <i>Float &mdash; Default: 0.5</i><br />
        Minimum reference span relative to the barcode length.
</p>
<p name="SubreadsProcessing.executeLima.minScoringRegion">
        <b>SubreadsProcessing.executeLima.minScoringRegion</b><br />
        <i>Int &mdash; Default: 1</i><br />
        Minimum number of barcode regions with sufficient relative span to the barcode length.
</p>
<p name="SubreadsProcessing.executeLima.minSignalIncrease">
        <b>SubreadsProcessing.executeLima.minSignalIncrease</b><br />
        <i>Int &mdash; Default: 10</i><br />
        The minimal score difference, between first and combined, required to call a barcode pair different.
</p>
<p name="SubreadsProcessing.executeLima.peek">
        <b>SubreadsProcessing.executeLima.peek</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Demux the first N ZMWs and return the mean score, 0 means peeking deactivated.
</p>
<p name="SubreadsProcessing.executeLima.peekGuess">
        <b>SubreadsProcessing.executeLima.peekGuess</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Try to infer the used barcodes subset, by peeking at the first 50,000 ZMWs.
</p>
<p name="SubreadsProcessing.executeLima.scoredAdapterRatio">
        <b>SubreadsProcessing.executeLima.scoredAdapterRatio</b><br />
        <i>Float &mdash; Default: 0.25</i><br />
        Minimum ratio of scored vs sequenced adapters.
</p>
<p name="SubreadsProcessing.executeLima.scoreFullPass">
        <b>SubreadsProcessing.executeLima.scoreFullPass</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Only use subreads flanked by adapters for barcode identification.
</p>
<p name="SubreadsProcessing.executeRefine.cores">
        <b>SubreadsProcessing.executeRefine.cores</b><br />
        <i>Int &mdash; Default: 2</i><br />
        The number of cores to be used.
</p>
<p name="SubreadsProcessing.executeRefine.logLevel">
        <b>SubreadsProcessing.executeRefine.logLevel</b><br />
        <i>String &mdash; Default: "WARN"</i><br />
        Set log level. Valid choices: (TRACE, DEBUG, INFO, WARN, FATAL).
</p>
<p name="SubreadsProcessing.executeRefine.memory">
        <b>SubreadsProcessing.executeRefine.memory</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The amount of memory available to the job.
</p>
<p name="SubreadsProcessing.executeRefine.minPolyAlength">
        <b>SubreadsProcessing.executeRefine.minPolyAlength</b><br />
        <i>Int &mdash; Default: 20</i><br />
        Minimum poly(A) tail length.
</p>
<p name="SubreadsProcessing.libraryDesign">
        <b>SubreadsProcessing.libraryDesign</b><br />
        <i>String &mdash; Default: "same"</i><br />
        Barcode structure of the library design.
</p>
<p name="SubreadsProcessing.outputDirectory">
        <b>SubreadsProcessing.outputDirectory</b><br />
        <i>String &mdash; Default: "."</i><br />
        The directory to which the outputs will be written.
</p>
<p name="SubreadsProcessing.splitBamNamed">
        <b>SubreadsProcessing.splitBamNamed</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Split BAM output by resolved barcode pair name.
</p>
</details>








<hr />

> Generated using WDL AID (0.1.1)
