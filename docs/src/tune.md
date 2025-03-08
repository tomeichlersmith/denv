# Tuning the denv
While `denv` is not built to construct a mutable environment,
it does support a few different methods for tuning its behavior
to suit your specific development workflow.

## Version control
The configuration of the denv is a very light file and, by default,
`denv init` produces a `.gitignore` file in its config/cache directory
which helps you ignore the files that may change from computer-to-computer
(or user-to-user if your team is using denv).

If you are already in a git repository, you can start tracking your denv
configuration along with the rest of your code by simply adding the hidden
denv directory.
```
git add .denv
git commit -m "initialize a denv configuration"
```

## RC Files
One of the key features of `denv` is mapping the workspace you
are developing in to the home directory of the denv container.
This allows a lot of natural specialization since many programs
look into the home directory (or some subdirectory of it) for 
their configuration files.

Moreover, many of these RC files are light text files and can
be committed into your version control like denv's own config
files; thus, carrying the denv with the code that requires it.

`denv` copies over some "skeleton" files into the workspace to
help get it started and make sure any interactive shell that is
opened is configured in a reasonable way. This is one of the main
locations to do workspace specialization. I've mainly worked with
bash, so that is the example I show below.

### Example bash\_aliases
The skeleton `.bashrc` copied into the workspace directory sources the
`.bash_aliases` file if it exists. This makes this file a perfect 
candidate for storing workspace-specific shell functions that will
be available to you once you enter the denv.

For example, I can help my C++ projects follow a more ergonomic
build system by wrapping CMake calls.
```bash
# in <workspace>/.bash_aliases
build() {
  cmake -B build -S . $@ && cmake --build build
}

test() {
  build && cmake --build build --target test
}

run() {
  build && ./build/program $@
}
```

### `sh` and `.profile`
Inside the denv, we use `sh -lc` to run the command provided to `denv`.
The `c` flag is used to specify the command being run, but of more importance
to us is the `l` flag which forces `sh` to be a _login_ shell.

For our purposes, this means that various initialization files will be sourced
while launching `sh` and before the command is run, specifically, one of the files
that can be used is at `~/.profile` (or `<workspace>/.profile` outside the denv).
Updating this file with changes to `*PATH` variables (like `PATH`, `LD_LIBRARY_PATH`,
and `PYTHONPATH`) can be helpful so that executables can be run interactively
(i.e. `denv` then `my-executable`) and non-interactively (i.e. `denv my-executable`).

## Extra Mounts
By default, `denv` only allows the container to view the files within
the workspace[^1]. This works for many projects; however,
sometimes software being developed requires input data from outside
of its workspace, this could be input data files that need to be read
when running the software or perhaps another source of software to run
alongwith the code being developed. `denv` supports both of these workflows
by allowing users to specify extra mounts to be connected to the denv
when it is being run.
```
denv config mounts /path/to/extra/data/outside/workspace
```
`denv` requires any additional mounts to be specified by their full path
and to already exist. This prevents user typos as well as ensures the user
knows what path will be available within the denv (i.e. symlinks _outside_
the denv may not map properly _inside_ the denv).

## Environment Variables
The default behavior of `denv` is to copy all of the host environment
variables into the denv so that the environment within the denv is "familiar"
to the user. Sometimes, this behavior is not desirable and so users can choose
to disable it and seletively copy environment variables. In addition, users can
choose to set specific values of environment variables within the denv that will
stay that value regardless on what the value of that variable is on the host.

Some examples of using this behavior are provided
in the EXAMPLES section of the [denv config manual](manual/denv-config.1.md).

## Cluster Computing

_Note:_ In this section, to avoid typing, I'm going to refer to the
Apptainer/SyLabs SingularityCE/Singularity group of runners as `appatainer`
and the Docker/Podman group of runners as `docker`.

On many computing clusters, `apptainer` is the default container runner
installed and used by `denv` and, in order to make the usage of `apptainer`
(via `denv`) the same as `docker`, we reference images using the OCI
image name (`[registry/]owner/repo:tag`).
For example
```
denv init python:3.12
```
is the same on personal computers with `docker` and remote clusters
with `apptainer`.
We achieve this mimicry by piggy-backing on the `apptainer` cache directory
where `apptainer` stores an intermediate SIF image it builds from the OCI image
we provide it.
This has two large effects for users of `denv` on computing clusters.
1. If the default cache location within users' home directories is too small to
   hold the images you want them to be using, they should update their shell configuration
   to define `APPTAINER_CACHEDIR` (or `SINGULARITY_CACHEDIR` for the `singularity` runners)
   to a different location with more space, preferably a place that supports atomic rename.
2. If you plan to run many parallel jobs using the same image, you should pre-build
   a SIF image using `apptainer pull` and provide this image to `denv` (in `denv init`
   or `denv config image`) so that `denv` uses a frozen image during parallel processing
   rather than referencing the cache which the user could change while the parallel
   jobs are running leading to potential differences.

These comments may apply to the `docker` family of runners especially if more
clusters adopt a configuration where both Podman and Apptainer are installed.
(For example, [Containers on HPC](https://github.com/dirkpetersen/hpc-containers)
proposes a configuration.)
Personally, I have yet to gain access to a cluster where Podman is installed and
configured in a way usable by `denv`. I have accessed a cluster where both Podman
and Apptainer are installed but Podman is not given access to user namespaces and
thus we are unable to pretend to be the correct user in a Podman-launched container.

[^1]: This isn't exactly true. denv also mounts a few helper files as well
(e.g. the entrypoint program `_denv_entrypoint`); however, those are single-file
mounts that can be ignored by normal users.
