Changelog
==========

<!--
Newest changes should be on top.

This document is user facing. Please word the changes in such a way
that users understand how the changes affect the new version.
-->

version develop
---------------------------
+ Add multiqc to the pipeline.
+ Add `meta {allowNestedInputs: true}` to the workflows, to allow for the use
  of nested inputs.
+ Remove `execute` from the naming structure for calls of tasks and workflows.
+ Add sample names to workflow output as `outputSamples`.
+ Rename fastqc tasks to correctly reflect what input they process.
+ Rename test files to show PacBio file structure more clearly.
+ Increase the number of fastqc threads. This prevents java heapspace memory
  errors.
+ Make running isoseq3 refine optional. This changes the default behaviour
  to not running isoseq3 refine.
+ Add FastQC to the pipeline.
+ Tasks were updated to contain the `time_minutes` runtime attribute and
  associated `timeMinutes` input, describing the maximum time the task will
  take to run.
+ Setup PacBio subreads processing pipeline.
