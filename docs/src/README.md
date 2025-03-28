# denv
containerized development environments across many runners

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
In general, most of these alternatives are either more popular than denv or maintained 
by larger groups of people (or both), so I would suggest using one of these projects if
they work for your use case.

- [distrobox](https://github.com/89luca89/distrobox): main inspiration for denv, POSIX-sh program with a larger feature set than denv but currently restricted to docker or podman
  - I attempted to develop distrobox in such a way as to support apptainer and singularity; however, the added features mainly centered around editing the container while it is being run were not supported by the apptainer/singularity installations on the HPCs I have access to.
- [devcontainers](https://github.com/devcontainers): currently restricted to docker (or podman with some tweaking), has a CLI reference implementation and tight integration with the VS Code IDE
- [devpod](https://github.com/loft-sh/devpod): Codespaces but open-source, client-only and unopinionated: Works with any IDE and lets you use any cloud, kubernetes or just localhost docker. Similarly restricted to docker/podman as VS Code devcontainers - focused more on providing a [GitHub Codespaces](https://github.com/features/codespaces)-like service that isn't locked in to VS Code and GitHub.
- [devbox](https://github.com/jetpack-io/devbox): "similar to a package manager ... except the packages it manages are at the operating-system level", a helpful tool based on `nix`, written in `go`
  - This is the newest project and probably most closely aligned to my goals; however, it would require understanding how to write NixPkgs for all my dependencies (which is not an easy task given how specialized so many of the packages are) and I am not currently able to functionally install it on the HPCs which use apptainer/singularity.
- [toolbox](https://github.com/containers/toolbox): built on top of `podman`, similar in spirit to distrobox and devbox
- [repro-env](https://github.com/kpcyrd/repro-env): rust-wrapper for `podman`, focused on specifying a manifest file which is then evolved into a lock file specifying SHAs for container images and packages, allows env to only evolve when developer desires.
- [devenv](https://devenv.sh/): "develop in your shell. deploy containers." Again, goals aligned with this project, but relies on the NixPkgs registry or building dependencies locally with nix definitions. Requires installation of `nix` package manager (I think).

## Quick Start
Install the latest release on GitHub.
```
curl -s https://tomeichlersmith.github.io/denv/install | sh
```
Make sure the installation was successful (and you have a supported runner installed)
```
denv check
```
Initialize the current directory as a denv.
```
denv init <dev-image-to-use>
```
Open an interactive shell in the newly-created denv
```
denv
```

### Usage Cheatsheet
After initialization (above), the rest of the `denv`-specific subcommands are housed under `denv config`,
which allow you to
- Change the image the denv uses `denv config image <image-tag>`
- Pull down the image again `denv config image pull`
- Disable copying of all host environment variables `denv config env all off`
- Set environment variables to specific values `denv config env copy foo=bar`
- Copy environment variables from the host (if not copying all of them) `denv config env copy host_foo`
- Disable network connection `denv config network off`
- Have other directories mounted `denv config mounts /full/path/to/my/other/dir`
- Print the config for inspection/debugging `denv config print`
- Set the program denv should run if no arguments are provided `denv config shell /path/to/program`

See `denv help` or `man denv` for more details about `denv` and its subcommands.
