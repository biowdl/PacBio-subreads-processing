Changelog
==========

<!--
Newest changes should be on top.

This document is user facing. Please word the changes in such a way
that users understand how the changes affect the new version.
-->

version develop
---------------------------
+ Add option to run isoseq3 refine, this changes the default behaviour to not
  runing isoseq3.
+ Add FastQC to the pipeline.
+ Tasks were updated to contain the `time_minutes` runtime attribute and
  associated `timeMinutes` input, describing the maximum time the task will
  take to run.
+ Setup PacBio subreads processing pipeline.
