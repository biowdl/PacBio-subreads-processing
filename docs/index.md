---
layout: default
title: Home
---

This workflow can be used to process a Pacific Biosciences subreads BAM file.
It generates ccs reads (using pbccs), demultiplexes the ccs reads into samples
(using lima) and polishes the reads (using isoseq3 refine for RNA).

This workflow is part of [BioWDL](https://biowdl.github.io/)
developed by the SASC team
at [Leiden University Medical Center](https://www.lumc.nl/).

## Usage
This workflow can be run using
[Cromwell](http://cromwell.readthedocs.io/en/stable/):

First download the latest version of the workflow wdl file(s)
from the
[github page](https://github.com/biowdl/PacBio-subreads-processing).

The workflow can then be started with the following command:
```bash
java \
    -jar cromwell-<version>.jar \
    run \
    -o options.json \
    -i inputs.json \
    pacbio-subreads-processing.wdl
```

Where `options.json` contains the following json:
```json
{
    "final_workflow_outputs_dir": "/path/to/outputs",
    "use_relative_output_paths": true,
    "final_workflow_log_dir": "/path/to/logs/folder"
}
```

### Inputs
Inputs are provided through a JSON file. The minimally required inputs are
described below, but additional inputs are available.
A template containing all possible inputs can be generated using
Womtool as described in the
[WOMtool documentation](http://cromwell.readthedocs.io/en/stable/WOMtool/).
For an overview of all available inputs, see [this page](./inputs.html).

```json
{
    "SubreadsProcessing.subreadsFile": "The PacBio subreads file that contains the raw PacBio reads.",
    "SubreadsProcessing.barcodesFasta": "Fasta file with the barcodes used in the PacBio experiment.",
    "SubreadsProcessing.runIsoseq3Refine":"Option to run isoseq3 refine for de-novo transcript reconstruction.",
    "SubreadsProcessing.generateFastq": "Option to generate fastq files from demultiplexed bam files.",
    "SubreadsProcessing.outputDirectory": "The path to the output directory."
}
```

Optional settings:
```json
{
    "SubreadsProcessing.ccsChunks": "The number of chunks to be used by ccs."
}
```

#### Example
The following is an example of what an inputs JSON might look like:
```json
{
    "SubreadsProcessing.subreadsFile": "tests/data/batch.1.march.subreads.bam",
    "SubreadsProcessing.barcodesFasta": "tests/data/batch.1.march.barcodes.fasta",
    "SubreadsProcessing.runIsoseq3Refine": false,
    "SubreadsProcessing.generateFastq": false,
    "SubreadsProcessing.limaThreads": "3",
    "SubreadsProcessing.ccsThreads": "4",
    "SubreadsProcessing.ccsChunks": "5",
    "SubreadsProcessing.fastqcThreads": "4",
    "SubreadsProcessing.outputDirectory": "tests/test-output"
}
```

## Dependency requirements and tool versions
Biowdl workflows use docker images to ensure reproducibility. This
means that biowdl workflows will run on any system that has docker
installed. Alternatively they can be run with singularity.

For more advanced configuration of docker or singularity please check
the [cromwell documentation on containers](
https://cromwell.readthedocs.io/en/stable/tutorials/Containers/).

Images from [biocontainers](https://biocontainers.pro) are preferred for
biowdl workflows. The list of default images for this workflow can be
found in the default for the `dockerImages` input.

## Output
The workflow will output polished ccs reads split into their respective sample.
Along with these (split on sample) BAM files, the workflow will also output all
intermediate files. Depending on the options set, the workflow can also output
fastq files.

## Contact
<p>
  <!-- Obscure e-mail address for spammers -->
For any questions about running this workflow and feature requests (such as
adding additional tools and options), please use the
<a href="https://github.com/biowdl/PacBio-subreads-processing/issues">github issue tracker</a>
or contact the SASC team directly at: 
<a href="&#109;&#97;&#105;&#108;&#116;&#111;&#58;&#115;&#97;&#115;&#99;&#64;&#108;&#117;&#109;&#99;&#46;&#110;&#108;">
&#115;&#97;&#115;&#99;&#64;&#108;&#117;&#109;&#99;&#46;&#110;&#108;</a>.
</p>
