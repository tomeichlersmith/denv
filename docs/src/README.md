# denv
containerized development environments across many runners

[![Generate Manual](https://github.com/tomeichlersmith/denv/actions/workflows/manpages.yml/badge.svg)](https://github.com/tomeichlersmith/denv/actions/workflows/manpages.yml)
[![Tests](https://github.com/tomeichlersmith/denv/actions/workflows/test.yml/badge.svg)](https://github.com/tomeichlersmith/denv/actions/workflows/test.yml)
[![Documentation](https://github.com/tomeichlersmith/denv/actions/workflows/mdbook.yml/badge.svg)](https://tomeichlersmith.github.io/denv/)
[![License](https://img.shields.io/github/license/tomeichlersmith/denv)](https://github.com/tomeichlersmith/denv/blob/main/LICENSE)
[![GitHub release](https://img.shields.io/github/v/release/tomeichlersmith/denv)](https://github.com/tomeichlersmith/denv/releases)


Develop code in identical command line interface environments across different container managers and their runners.

Containerization of code has only grown in popularity since it (almost) completely removes issues of dependency incompatibility.
More recently, even developing code within a container has grown in popularity leading to several approaches.

The main problem I have with all of the alternatives is lack of support for my specific workflow.
I not only use my personal computer (with docker or podman) but I also commonly use academic
High Performance Computers or Clusters (HPCs) which tend to have apptainer or singularity installed
due to their better support for security-focused (lack of user access) installations.
This is the main origin for `denv` - provide a common interface for using images as
a development environment across these four container managers.

## Alternatives

- [distrobox](https://github.com/89luca89/distrobox): main inspiration for denv, POSIX-sh program with a larger feature set than denv but currently restricted to docker or podman
  - I attempted to develop distrobox in such a way as to support apptainer and singularity; however, the added features mainly centered around editing the container while it is being run were not supported by the apptainer/singularity installations on the HPCs I have access to.
- [VS Code devcontainers](https://github.com/microsoft/vscode-dev-containers): designed to be used in conjuction with the VS Code IDE, also currently restricted to docker (or podman with some tweaking)
- [devbox](https://github.com/jetpack-io/devbox): "similar to a package manager ... except the packages it manages are at the operating-system level", a helpful tool based on `nix`, written in `go`
  - This is the newest project and probably most closely aligned to my goals; however, it would require understanding how to write NixPkgs for all my dependencies (which is not an easy task given how specialized so many of the packages are) and I am not currently able to functionally install it on the HPCs which use apptainer/singularity.
- [toolbox](https://github.com/containers/toolbox): built on top of `podman`, similar in spirit to distrobox and devbox

## Quick Start
Install the latest release on GitHub.
```
curl -s https://raw.githubusercontent.com/tomeichlersmith/denv/main/install | sh 
```
Initialize the current directory as a denv.
```
denv init <dev-image-to-use>
```
Open an interactive shell in the newly-created denv
```
denv
```
