# Metagenomic Standard Operating Procedure

> :construction: The SOP is not fully implemented here. See the Langille Lab's
> [wiki][langille_sop] for the most up-to-date version.

The [Langille Lab's metagenomic SOP][langille_sop], implemented as a [WDL][wdl]
workflow.

## Prerequisites

This workflow is designed to be run on a Unix-based system.

### Install dependencies

To ease the installation of dependencies, we use [`conda`][miniconda] to manage
the execution environment:

```
$ conda env create
$ source activate mgs_sop
```

If you'd like to install the tools manually, see the `environment.yml` file for
the project dependencies.

### Set input variables

The workflow relies on several user supplied inputs to complete its tasks.
Before running the workflow, you'll want to copy the input template and
populate it with the details for your project and environment. For example:

```
$ cp inputs.template.json inputs.json
```

Then open the file with your preferred text editor and fill in the values. Some
values describe the location of required databases (see following section).

### Download required databases

A mapping database for screening reads can be downloaded from the Langille Lab
(Note: the file is ~3.5GB):

```
$ curl \
    http://kronos.pharmacology.dal.ca/public_files/GRCh38_PhiX_bowtie2_index.tar.gz \
    > /tmp/GRCh38_PhiX_bowtie2_index.tar.gz
$ tar xvzf GRCh38_PhiX_bowtie2_index.tar.gz -C databases
$ rm /tmp/GRCh38_PhiX_bowtie2_index.tar.gz

# Copy and paste the absolute path of the database directory in your
# inputs.json. If on Linux, you can get the full path by:
$ readlink -f databases/GRCh38_PhiX_bowtie2_index/
```

## Running the workflow

Run the workflow with Cromwell (assumes the populated inputs template was
named `inputs.json`):

```
$ cromwell run workflow.wdl --inputs inputs.json
```


## Testing the workflow

Test data can be obtained from NCBI using the SRA Toolkit. The following
commands will download a small sample set of FASTQs (from an HMP project,
accessible via NCBI with project accession [PRJNA46333][PRJNA46333]:

```
$ fastq-dump \
    --readids \
    --split-files \
    --maxSpotId 10 \
    --outdir tests/fastq/ \
    SRR3644404
```

Once the test data has been downloaded, run the workflow with the test input
file:

```
$ cromwell run workflow.wdl --inputs tests/inputs.test.json
```


<!-- Links -->
[langille_sop]: https://github.com/LangilleLab/microbiome_helper/wiki/Metagenomic-standard-operating-procedure
[wdl]: https://software.broadinstitute.org/wdl/
[miniconda]: https://conda.io/miniconda.html
[PRJNA46333]: https://www.ncbi.nlm.nih.gov/bioproject/PRJNA46333
