# Getting Started

I am going to assume that you already have a container image in mind for running as the denv for
this page; however, you can look at [Developing the Environment](./env_dev.md) for general notes
on how to create an image that is useful as a denv. A good image to use if you wish to test run
`denv` is one of the [python images](https://hub.docker.com/_/python).
This can give you access to the latest release of python
without having to spend time compiling it or even installing it on your system. In addition, python
has good support for "user" installation of packages within the home directory, so you can install
your favorite packages pretty quickly within the denv without having to go through the rigamarole
of actually building an image yourself.

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
  - `denv` requires the use of the `--env` flag for singularity "flavors".
    This was implemented in version 3.6 for singularity and so any new install of either apptainer or singularityCE
    should work. Legacy installations of singularity (i.e. versions older than 3.8.7) _should_ function with `denv`
    (down to version 3.6); however, `denv` only tests version 3.8.7.

[^1]: These groups actually go beyond mere user base. podman grew out of a desire for a under-the-hood redesign
of docker that is focused on being a drop-in replacement for docker. Even more special, apptainer and singularityCE
used to be the same project singularity before apptainer joined the Linux Foundation and Sylabs continued work on its
fork of singularity now labeled singularityCE. So these two groupings also share tight similarities in 
their command line interface making them natural groupings for denv.

### Operating Systems
⚠️ This section is laced with sarcasm. ⚠️

Containers are a technology created from combining a few Linux kernel features.
This makes them incredibly versatile _and_ just confusing enough to be wrapped in thick layers of software and high-tech jargon.
Many others have written about the technology underpinning containers[^2], so I won't go into more detail here.
I merely point this out to emphasize that non-Linux operating systems only access containers via Virtual Machines (VM) hosting Linux.[^3]
Specifically, this means the other two big operating systems (Mircrosoft Windoze and Mac OS X) must be accomodated with VMs.

#### Windoze
(Misspelling Windows as Windoze since I think its funny.)

Microsoft released Windoze Subsystem for Linux (WSL) in 2016 after finally realizing that work can only really get done
within a functional operating system (like Linux-based ones).
While largely expected to be apart of their [Embrace Extend Extinguish](https://en.wikipedia.org/wiki/Embrace,_extend,_and_extinguish)
methodology, it still benefits us in that we can use containers in an almost equivalent way they would be used on a Linux system with
the added step of having to wait for Windoze to boot and open WSL.
One of the most popular container runners docker [just plainly tells people to use WSL](https://docs.docker.com/desktop/install/windows-install/)
when installing it.

With this context in mind, **`denv` supports Windoze indirectly through WSL** in the same manner as docker.
If you are on Windoze, first enable WSL and then interact with docker
(or whatever runner you want[^4]) and `denv` within the WSL terminal.

#### Mac OS X
Both docker and podman support Mac OS X by spawning light weight VMs that can be kept idle while awaiting
container instruction.[^5] Since Mac OS X has a more similar filesystem (and presumably kernel) to Linux,
its VM is able to have a tighter integration with the host system. This has both benefits and difficulties.
The benefit is that we presumably get performance improvements (I'm assuming this, I have not tested it.)
The downside is that the user is not exposed directly to a terminal within the Linux kernel system like they
are for Windoze (via WSL) or bare-metal Linux. This is an issue for `denv`
(and [for other container wrappers](https://github.com/89luca89/distrobox/issues/36)) since, as a wrapper,
we are trying to connect the container and host which is difficult to do when given only limited access
to the intermediary VM layer.

With this context in mind, **`denv` has limited support for Mac OS X**. Namely, `denv` is able to support
_non-ID-necessary processes_ within the constructed denv. For example, compiling and running a program
within `denv` works fine but making a commit with `git` within it does not.
The discovery of this limitation and any ongoing work
is tracked in [denv Issue #102](https://github.com/tomeichlersmith/denv/issues/102).

**Note**: If you wish to use graphical applications from within the denv,
you will need to install XQuartz[^6] and disable access controll with `xhost +`.

[^2]: [The container is a lie](https://platform.sh/blog/the-container-is-a-lie/) is a nice article going into detail
about the underpinnings of containers with a bit a click-baity title.Charliecloud's
[containers are not special](https://hpc.github.io/charliecloud/tutorial.html#containers-are-not-special) 
is only a moderate improvement in the title department and another approach to the material. Finally, I've liked
[containers from scratch](https://ericchiang.github.io/post/containers-from-scratch/) which takes a more educational
approach to help readers see why wrapping container creation and running in managers has been done (while also
showing that it is an easy enough procedure for there to be many managers floating around).

[^3]: _Technically_, I might be wrong here since a specific kernel might offer the same features that Linux
offers that enables containers (or a specific subset of configurations of containers), but I digress.

[^4]: While I haven't tested this myself or found any evidence online, I expect that since docker
functions within WSL other runners will function within WSL as well although they won't have a
graphical interface running outside of WSL (Docker Desktop).

[^5]: I am not as familiar with the technical underpinnings of how docker or podman on Mac works since
I have not had a computer to test and learn with it myself. If you have a technical correction to this
section, please feel free to open an Issue or PR.

[^6]: You can install XQuartz [using brew](https://formulae.brew.sh/cask/xquartz)
or [using the `.dmg` file](https://www.xquartz.org/).

#### Graphical Applications
`denv` ensures that the X11 apps spawned from within the container can connect with the host
by passing the `DISPLAY` environment variable and mounting the `/tmp/.X11-unix` directory.
For Linux-hosts and WSL, this is enough[^6]; however, on MacOS additional setup is required.

If you don't plan to use a graphical application from within the a denv (or if you are just
using a network-based application like Jupyter Lab), then there is no need to do this
additional setup on MacOS. [These instructions](https://gist.github.com/roaldnefs/fe9f36b0e8cf2890af14572c083b516c)
I've found on GitHub are rather short but have worked for many folks.

[^6]: I haven't tested this thoroughly on WSL, but [WSL's Containers page](https://github.com/microsoft/wslg/blob/main/samples/container/Containers.md)
appears to support this conclusion as well. This page also implies that `denv` could support Wayland
applications with a few more mounts and environment variables.

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

Use `denv check` to verify that an installation was successful and to list the runners supported
by the installed `denv` and which ones are accessible in the current environment. An example output
would be
```shell
$ denv check
Entrypoint found alongside denv
Looking for docker... found 'Docker version 24.0.7, build afdd53b' <- would use without DENV_RUNNER defined
Looking for podman... not found
Looking for apptainer... not found
Looking for singularity... not found
```
Here, I can see which programs `denv` looked for and I am informed that it only found `docker` which
is the one it will use by default. The extra comment about `DENV_RUNNER` is helpful if there are multiple
runners installed - you can override `denv`'s choice by setting `DENV_RUNNER` to the command you wish
to use.

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
