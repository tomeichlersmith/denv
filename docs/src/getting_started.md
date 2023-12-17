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
  - Version requirements on docker or podman have not been investigated.
- Computing Clusters: [apptainer](https://apptainer.org/) or [singularityCE](https://sylabs.io/singularity/)
  - These are commonly chosen by computing clusters due to their ability to be very strictly configured
    so users can run them without elevated priveleges thus avoiding some security vulnerabilities.
  - `denv` requires the use of the `--env` flag for singularityCE or apptainer which basically means
    version 3.6 or newer for singularity or any version of apptainer. apptainer currently installs a singularity
    alias alongside it so - if `singularity --version` returns a value below 3.6, make sure `apptainer` isn't
    a valid command before concluding that `denv` cannot operate properly.

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
`denv` is a relatively simple program with very few commands and even fewer options,
but to help you get started, lets start a denv with a dependency you would want to
be completely isolated from your computer: python2.7.

First, we will work in an example workspace that can easily be cleaned up.
```
mkdir denv-eg
cd denv-eg
```
Now we can initialize the environment.
```
denv init python:2.7.18
```
This step will download the image to your computer if you do not already have it.
It will also be the first step that checks if you have a supported container runner.
Now we can enter the denv itself.
```
denv
```
The prompt will likely change since `denv` changes the hostname for the container to
include the name given to the denv (in this case just "denv").
Here, we now have a terminal where the python available is Python 2.7.
```
python --version
# output: Python 2.7.18
```
This example is pretty trivial (especially given the plethora of other solutions for
isolated python environments), but it does show the basic workflow of `denv` - users
configure it to have a certain container image defining the environment in-which to
develop and then users enter this environment to do their work.
We can clean up the denv by exiting our workspace and deleting the directory.
```
cd ..
rm -r denv-eg
```
_Note:_ Container runners maintain image caches outside of the denv workspace so if
you wish to remove the `python:2.7.18` image from your system, you will need to look
at the documentation for your runner on how to do that. Generally, keeping extra images
in your cache is good because it saves time re-downloading image layers that have been
downloaded before, so you really should only worry about deleting the image if you are
running out of disk space.
