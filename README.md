# Metagenomic Standard Operating Procedure

The [Langille Lab's metagenomic SOP][langille_sop], implemented as a [WDL][wdl]
workflow.


## Install dependencies

To get started quickly, we use [`conda`][miniconda] to simplify the management
of the execution environment:

```
$ conda env create
$ source activate mgs_sop
```

If you'd like to install the tools manually, see the `environment.yml` file for
the project dependencies.


## Running the workflow

To run the workflow, first copy the inputs template (`inputs.template.json`)
and add the appropriate configuration for your data and processing needs.

Then, run the workflow with Cromwell (assumes the populated inputs template was
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
