# NAME

denv v0.7.0

# SYNOPSIS

**denv** {help|-h|--help}

**denv** version

**denv** init [args]

**denv** config [args]

**denv** check [-h, --help] [-q, --quiet]

**denv** [COMMAND] [args...]

# DESCRIPTION

**`denv`** is a light, POSIX-compliant wrapper around a few common container managers,
allowing the user to efficiently interact with container-ized envorinments uniformly
across systems with different installed managers. It has few commands, prioritizing
simplicity so that users can easily and quickly pass their own commands to be run
within the specialized and isolated environment.

# COMMANDS

**`help`** prints a short help message and exits. The aliases **`-h`** and **`--help`**
           also exist for this command.

**`version`** prints the name and version of the currently installed `denv`

**`init`** initialize a new denv. See **denv-init(1)** for details.

**`config`** manipulate the configuration of the current denv. See **denv-config(1)** for details.

**`check`** check the installation of denv and look for supported container runners. See **denv-check(1)** for details.

**`COMMAND`** any other command not matching one of the options above is provided to the
              configured denv to run within the containerized environment. The rest of the
              command line is passed along with COMMAND so its args are seen as if they
              were run manually within the shell of the container.

# EXAMPLES

**`denv`** is meant to be used after building a containerized developer environment. Look at the
online manual for help getting started on developing the environment itself, but for these examples,
we will assume that you already have an image built in which you wish to develop.

## Basic Start-Up

First, we go into the directory that holds the code we wish to develop and tell denv that this
workspace should be running a specific image for its developer environment.

    denv init myuser/myrepo:mytag

Then we can open a shell in the denv.

    denv

Now you can build and run programs from within the denv with its solidified set of software
and tools while still editing the code files themselves with whatever text editor you wish
outside of the denv. The init command produces a configuration file `.denv/config` which you
can share between users and so it is excluded from the default `.gitignore` generated within
`.denv`. All other files within `.denv` are internal to denv and can only be modified at
your own risk.

## "Remote" Running

While most of users will interact with denv from within denv's workspace, sometimes users
wish to run a command from outside of the workspace. In this case, the default deduction
of the workspace can fail; nevertheless, users can still achieve this goal by providing
the path themselves. Below, we enter an interactive shell within the denv located at
*`/full/path/to/workspace`* without having to enter that directory.

    denv_workspace=/full/path/to/workspace denv

Astute shell users may notice that we are simply defining an environment variable for denv,
which is correct; however, users should avoid persisting this definition anywhere since it
would effectively prevent you from having more than one denv on the same host machine.
The other configuration variables do not have this problem since we find and source the
config file on each run of denv, therefore overwriting any environment variables that may
already be defined.

# SEE ALSO

**denv-init(1)**, **denv-config(1)**, **denv-check(1)**

# ENVIRONMENT

denv tests the definition and reads the value of a few different environment variables - allowing the user
to modify its behavior in an advanced way without having to provide many command line arguments.

  **DENV_DEBUG** if set, enable xtrace in denv so the user can see exactly what commands are being run.

  **DENV_INFO** if set, print progress information updates to terminal while denv is running

  **DENV_RUNNER** set to the container manager command you wish denv to use. This should only be used in
  the case where multiple managers are installed and you wish to override the default denv behavior of
  using the first runner that it finds available.

  **DENV_NOPROMPT** disable all user prompting. This makes the following decisions in the places
  where there would be prompts.

  - **denv init** errors out if there is already a denv in the deduced workspace or if a passed workspace
    does not exist
  - **denv init** and **denv config image** will not pull an image if it already exists

  **DENV_TAB_COMMANDS** a space-separated list of commands to include in tab-completions of denv.
  This is helpful if there are a set of common commands you use within the denv.


# SCRIPTING

denv has a shebang subcommand that can be used to construct a script to be run by a certain
program within a constructed denv. It begins with a normal Unix shebang. env is used to avoid
having to type the full path to denv and -S is used so the whitespace between denv and shebang
is respected (i.e. split).

    #!/usr/bin/env -S denv shebang

The following lines of the script file can then contain the configuration of the denv.
This can be done in two ways. If you already have a denv workspace that you want to run
inside of, you can just specify that

    #!denv_workspace=/full/path/to/workspace

If you don't have a workspace, then you will need to define the configuration of the denv.
At minimum, you must inform denv which image it should be running.

    #!denv_image=python:3

For singularity or apptainer runners, you need to pre-build this image since,
without a workspace, denv doesn't know where it should put the intermediary image file.

    #!denv_image=/full/path/to/image.sif

Other denv configuration options can be specified in this running mode as well.
The easiest way to see the options is to inspect the output of `denv config print`
which will contain the options not related to environment variables. A full listing
of available options is given by any `config` file written by denv into a `.denv` directory
for a workspace.

The last line of the shebang lines (lines starting with `#!`) is then the program that
will be run with the input file as its only argument. This program is run within the
denv so it does not need to reside on the host system. The path does not need to even
be a full path like with the normal unix shebang. The following examples hope to give
some more context for how to get started with denv's shebang.

### Workspace Example

    #!/usr/bin/env -S denv shebang
    #!denv_workspace=/full/path/to/workspace
    #!program
    script for program

### Workspace-Less Example (singularity or apptainer)

    #!/usr/bin/env -S denv shebang
    #!denv_image=/full/path/to/image.sif
    #!program
    script for program

### Workspace-Less Example (other runners)

    #!/usr/bin/env -S denv shebang
    #!denv_image=owner/repo:tag
    #!program
    script for program


# RUNNER DEDUCTION

denv does not persist what runner is being used inside of its configuration for a specific workspace.
This is done intentionally so that configurations could be shared across machines that may rely on
different runners; however, this could lead to confusion if denv is being used on a machine that has
multiple runners installed. In this case, it is highly suggested to use **`denv check`** and test-run
the different runners to see which are capable of being used by denv.

    # lists which runners it supports and which ones it has found
    denv check

A simple test would be to make sure denv can open a shell in some ubuntu image.
Check different runners by using the environment variable `DENV_RUNNER`.

    denv init ubuntu:22.04
    # run this for each of the runners "found" by denv check
    DENV_RUNNER=<runner> denv

If any of the runners do not work (i.e. open an interactive bash terminal),
please make a bug report by opening an issue for further investigation.
However, there are some configurations of popular container runners that denv
does not intend to support, so you may be forced to use a specific container runner
out of the ones installed. In this case, it is highly recommended to define the `DENV_RUNNER`
environment variable in your `~/.bashrc` (or equivalent) to avoid complication.

## Automatic Deduction

denv does make some attempts to avoid this complexity by having an automatic choosing behavior
that prefers runners that are more likely to be configured properly. For this reason, denv
chooses to prefer runners that act as emulators over the runners they are emulating
(for example, podman is checked before docker and apptainer is checked before singularity).
In addition, since the configuration of podman on some computing clusters is not supportive
of denv and apptainer is installed on these clusters, apptainer is checked before podman.
This leads to the following order of priority currently within denv when `DENV_RUNNER`
is not defined.

1. apptainer
2. singularity
3. podman
4. docker

# FILES

This part of the manual is an attempt to list and explain the files within a `.denv` directory.

## config

The file storing the configuration of the denv related to this workspace.
While it is plain-text and you can edit it directly. Editing it with the denv config set of commands
is helpful for doing basic typo- and existence- checking. The config file is a basic key=value shell
file that will be sourced by denv. See the FILES section of **denv-config(1)** for more detail.

## skel-init

This is an empty file that, if it exists, signals to the entrypoint executable that the files from /etc/skel have
been copied into the denv home directory. This prevents accidental overwriting of files that the user may edit as
well as saving time when starting up the container.

## images

This is a directory that holds any image files that may be generated by the runner denv is using to run the container.
For some runners, it is helpful to explicitly build an image outside of the cache directory and then run that image
file. This directory holds those images. It can be deleted if the user wishes to reclaim some disk space; however, that
means any image that are configured to be used by denv will then be re-downloaded and re-built.
