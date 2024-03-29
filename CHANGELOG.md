Changelog
==========

<!--
Newest changes should be on top.

This document is user facing. Please word the changes in such a way
that users understand how the changes affect the new version.
-->

version develop
---------------------------
+ Replace bam2fastx task with samtools fastq task.
+ Update samtools to version 1.12.
+ Change pacbio-merge from dockerhub to quay.
+ Update multiqc to version 1.10.
+ Update biowdl-input-converter to version 0.3.
+ Update lima to version 2.2.0.
+ Update ccs to version 6.0.0.
+ Update bam2fastx to version 1.3.1.
+ Add the dockerImages to the output section.
+ Replace travis with github CI.
+ Reinstate `outputDirectory` input.
+ Move tasks `ccsChunks` & `mergePacBio` to tasks repository.
+ Update IsoSeq3 to version 3.4.0, Lima to version 2.0.0.
+ The pipeline now only supports a single input subreads bamfile
  and barcodes fasta file.
+ Rename main pipeline file to `pacbio-subreads-processing.wdl`.
+ Remove YAML file with docker images and set defaults within
  `pacbio-subreads-processing.wdl` inputs.
+ Make CPU cores for ccs configurable.
+ Add bam to fastq tasks to the pipeline.
+ Make CPU cores for lima configurable.
+ Update tasks and the input/output names.
+ Rename workflow outputs to shorter names.
+ Add multiqc to the pipeline.
+ Add `meta {allowNestedInputs: true}` to the workflows, to allow for the use
  of nested inputs.
+ Remove `execute` from the naming structure for calls of tasks and workflows.
+ Add sample names to workflow output as `outputSamples`.
+ Rename fastqc tasks to correctly reflect what input they process.
+ Rename test files to show pacbio file structure more clearly.
+ Increase the number of fastqc threads. This prevents java heapspace memory
  errors.
+ Make running isoseq3 refine optional. This changes the default behaviour
  to not running isoseq3 refine.
+ Add fastqc to the pipeline.
+ Tasks were updated to contain the `time_minutes` runtime attribute and
  associated `timeMinutes` input, describing the maximum time the task will
  take to run.
+ Setup pacbio subreads processing pipeline.
