Changelog
==========

<!--
Newest changes should be on top.

This document is user facing. Please word the changes in such a way
that users understand how the changes affect the new version.
-->

version develop
---------------------------
+ Add multiqc to collect the fastqc results.
+ Rename fastqc tasks to correctly reflect what input they process.
+ Rename test files to show PacBio file structure more clearly.
+ Make running isoseq3 refine optional. This changes the default behaviour
  to not running isoseq3 refine.
+ Increase the number of fastqc threads. This prevents java heapspace memory
  errors.
+ Add FastQC to the pipeline.
+ Tasks were updated to contain the `time_minutes` runtime attribute and
  associated `timeMinutes` input, describing the maximum time the task will
  take to run.
+ Setup PacBio subreads processing pipeline.
