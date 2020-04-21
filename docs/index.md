---
layout: default
title: Home
---

This pipeline can be used to process Pacific Biosciences subread BAM files.
It generates CCS reads (using CCS), demultiplexes the CCS reads into samples
(using LIMA) and polishes the reads (using IsoSeq3-Refine).

This pipeline is part of [BioWDL](https://biowdl.github.io/)
developed by the SASC team
at [Leiden University Medical Center](https://www.lumc.nl/).

## Usage
You can run the pipeline using
[Cromwell](http://cromwell.readthedocs.io/en/stable/):

```bash
java -jar cromwell-<version>.jar run -i inputs.json PacBio-subreads-processing.wdl
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
    "SubreadsProcessing.dockerImagesFile": "A file listing the used docker images."
}
```

#### Sample configuration

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


## Contact
<p>
  <!-- Obscure e-mail address for spammers -->
For any questions about running this pipeline and feature request (such as
adding additional tools and options), please use the
<a href='https://github.com/biowdl/sequence-classification/issues'>github issue tracker</a>
or contact the SASC team directly at: 
<a href='&#109;&#97;&#105;&#108;&#116;&#111;&#58;&#115;&#97;&#115;&#99;&#64;&#108;&#117;&#109;&#99;&#46;&#110;&#108;'>
&#115;&#97;&#115;&#99;&#64;&#108;&#117;&#109;&#99;&#46;&#110;&#108;</a>.
</p>
