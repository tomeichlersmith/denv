# Getting Started

I am going to assume that you already have a container image in mind for running as the denv for
this page; however, you can look at [Developing the Environment](./env_dev.md) for general notes
on how to create an image that is useful as a denv.

## Requirements
`denv` is a simple wrapper around a container runner. You must have a container runner installed
on the system you wish to use `denv` on. Generally, the runners can be separated into two groups.[^1]
- Personal Laptops and Desktops: [docker](https://docs.docker.com/engine/install/) or [podman](https://podman.io/)
  - Both of these are more widely used in software industry and so they are generally easier to install and use;
    however, they require certain elevated privileges that make them undesirable for academic clusters.
- Computing Clusters: [apptainer](https://apptainer.org/) or [singularityCE](https://sylabs.io/singularity/)
  - These are commonly chosen by computing clusters do to their ability to be very strictly configured
    so users can run them without elevated priveleges thus avoiding some security vulnerabilities.

[^1]: These groups actually go beyond mere user base. podman grew out of a desire for a under-the-hood redesign
of docker that is focused on being a drop-in replacement for docker. Even more special, apptainer and singularityCE
used to be the same project singularity before apptainer joined the Linux Foundation. So these two groupings
also share tight similarities in their command line interface making them natural groupings for denv.

## Installation
The most recent installation can be obtained by running the install script in the GitHub repository.
```shell
curl -s https://raw.githubusercontent.com/tomeichlersmith/denv/main/install | sh 
```
One can pass parameters to the install script by providing extra options to `sh`
```shell
curl -s https://raw.githubusercontent.com/tomeichlersmith/denv/main/install | \
  sh -s -- --prefix dir --next --simple
```
Here, I hightly the three main options that are available.
- `--prefix dir` allows you to decide on the location where denv should be installed
- `--next` says to use the HEAD of the main branch instead of the most recent release (may or may not differ)
- `--simple` prevents the install script from adding the backslash alias for denv

The installation script is merely a helpful and simple script for getting the program, its helper
program `_denv_entrypoint`, the manual, and tab completion files all in their correct locations.
The manual and tab completion files are not necessary for the functionality of `denv`, so one can
simply download `denv` and `_denv_entrypoint` from the GitHub repository (whichever release, branch,
tag, or commit you wish) and put them _side-by-side_ in some location you wish to keep them. If they
do not exist in a directory pointed to by your `PATH` variable then you will need to specify their
full path to run.

## Usage
`denv` is a relatively simple program with very few commands and even fewer options.

**NEED TO GO THROUGH AN EXAMPLE**
