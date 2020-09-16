---
layout: default
title: Home
---

This pipeline can be used to process Pacific Biosciences subread BAM files.
It generates ccs reads (using pbccs), demultiplexes the ccs reads into samples
(using lima) and polishes the reads (using isoseq3 refine for RNA).

This pipeline is part of [BioWDL](https://biowdl.github.io/)
developed by the SASC team
at [Leiden University Medical Center](https://www.lumc.nl/).

## Usage
You can run this pipeline using
[Cromwell](http://cromwell.readthedocs.io/en/stable/):

First download the latest version of the pipeline wdl file(s) and 
from the
[releases page](https://github.com/biowdl/PacBio-subreads-processing/releases).

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
    "SubreadsProcessing.subreadsConfigFile": "Configuration file describing input subread BAMs and barcode files.",
    "SubreadsProcessing.runIsoseq3Refine": "Option to run isoseq3 refine for de-novo transcript reconstruction.",
    "SubreadsProcessing.outputDirectory": "The path to the output directory.",
    "SubreadsProcessing.generateFastq": "Option to generate fastq files from demultiplexed bam files."
}
```

#### Subread configuration
##### JSON format
The subread configuration can be given as a json file with the following items.

```
subreads_id
subreads_file
subreads_md5
barcodes_file
```

These items need to be filled per subreads BAM.
Below is a example of such a json configuration.

```json
{
    "subreads": [
        {
            "subreads_id": "id",
            "subreads_file": "path/to/subreads.bam",
            "subreads_md5": "94127ced6d8428301376ee4ac18df58a",
            "barcodes_file": "path/to/barcodes.fasta"
        },
        {
            "subreads_id": "id2",
            "subreads_file": "path/to/subreads2.bam",
            "subreads_md5": "94127ced6d8428301376ee4ac18df58b",
            "barcodes_file": "path/to/barcodes2.fasta"
        }
    ]
}
```

#### Example
The following is an example of what an inputs JSON might look like:

```json
{
    "SubreadsProcessing.subreadsConfigFile": "tests/samplesheets/batches.json",
    "SubreadsProcessing.runIsoseq3Refine": "true",
    "SubreadsProcessing.outputDirectory": "tests/test-output",
    "SubreadsProcessing.generateFastq": "true"
}
```

### Dependency requirements and tool versions
Biowdl pipelines use docker images to ensure  reproducibility. This
means that biowdl pipelines will run on any system that has docker
installed. Alternatively they can be run with singularity.

For more advanced configuration of docker or singularity please check
the [cromwell documentation on containers](
https://cromwell.readthedocs.io/en/stable/tutorials/Containers/).

Images from [biocontainers](https://biocontainers.pro) are preferred for
biowdl pipelines. The list of default images for this pipeline can be
found in the default for the `dockerImages` input.

### Output
The workflow will output polished ccs reads split into their respective sample.
Along with these BAM files, the workflow will also output all
intermediate files. Depending on the options set, the pipeline can also output
fastq files.

## Contact
<p>
  <!-- Obscure e-mail address for spammers -->
For any questions about running this pipeline and feature request (such as
adding additional tools and options), please use the
<a href='https://github.com/biowdl/PacBio-subreads-processing/issues'>github issue tracker</a>
or contact the SASC team directly at: 
<a href='&#109;&#97;&#105;&#108;&#116;&#111;&#58;&#115;&#97;&#115;&#99;&#64;&#108;&#117;&#109;&#99;&#46;&#110;&#108;'>
&#115;&#97;&#115;&#99;&#64;&#108;&#117;&#109;&#99;&#46;&#110;&#108;</a>.
</p>
