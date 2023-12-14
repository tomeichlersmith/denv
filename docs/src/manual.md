# NAME

denv v0.4.0

# SYNOPSIS

**denv** version

**denv** init [help|-h|--help] IMAGE [WORKSPACE] [--no-gitignore] [--clean-env|--no-copy-all] [--force] [--name NAME]

**denv** config [help|-h|--help]

**denv** config print [env]

**denv** config image <pull | IMAGE>

**denv** config mounts DIR0 [DIR1 DIR2 ...]

**denv** config shell SHELL

**denv** config env [help|-h|--help]

**denv** config env print

**denv** config env all [yes|no]

**denv** config env copy VAR0[=VAL0] [VAR1[=VAL1] ...]

**denv** [COMMAND] [args...]

# DESCRIPTION

**denv** is a light, POSIX-compliant wrapper around a few common container managers,
allowing the user to efficiently interact with container-ized envorinments uniformly
across systems with different installed managers.

## OPTIONS
**denv** is light on options since most configuration of the actual development
environment is left to the construction of the image. Generally, the `help` option
(with aliases `-h` and `--help`) print out a short help message for **denv** or one
of its sub commands.

**`--help`**, **`-h`**, or **help** print a short help message for **denv** or one of its sub commands

**`--no-gitignore`** do not generate a gitignore file when setting up a new denv configuration

**`--clean-env`** or **`--no-copy-all`** do not enable copying of all host environment variables within the new denv.
  Later activation (or deactivation) of copying all host environment variables can be done with **denv config env all**

**`--force`** forces re-initialization of a denv even if the current workspace has one

**`--name`** sets the name for the denv workspace that is being initialized

## ARGUMENTS

**IMAGE**   the name of a container image to use when starting a container to host the developer environment

**WORKSPACE** the directory where the environment should be stored and configured, used by default
              as the home directory within the developer environment so that the environment can also
              have its own shell configuration files and **~/.local** paths.

**DIR** directory to add to the list of mounts to be mirrored into the denv. These directories
        are required to be full paths so that the user is cognizant of what paths will be available
        in the container and what arent. One can use *realpath* to deduce a fullpath from a relative
        path in a POSIX-compliant way if desired.

**SHELL** the program to use as the interactive shell within the containerized environment.

**COMMAND** a program to run inside of the containerized environment (can have its own arguments).
            If no COMMAND is given, then SHELL will be executed.

**VAR** environment variable name either in the host environment that should be copied into the denv
        (if not value is specified with an '=' sign) or defined to a specific value (when a value
        is specified with an '=' sign). These names cannot match special shell environment
        names (e.g. 'HOME') or special denv names (e.g. 'DENV_RUNNER').

**VAL** environment variable value used with **denv config env copy**. These values cannot have the
        special characters: space \' \', tick \'`\', quote \'"\', or dollar-sign \'$\'.


# EXAMPLES

**denv** is meant to be used after building a containerized developer environment. Look at the
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

## Sharing Environment Variables

The syntax for sharing environment variables with the denv is a bit terse, so it is helpful
to display some examples.

By default (without **`--no-copy-all`** or **`--clean-env`** when running **denv init**), **denv** will copy all
possible environment variables from the host into the denv. This means one can

    export foo=bar
    printenv foo      # prints out "bar"
    denv printenv foo # also prints "bar"

In some situations, this is over-sharing and you can disable this so that host environment
variables are not copied into the denv anymore.

    denv config env all no
    export foo=bar
    printenv foo      # prints out "bar"
    denv printenv foo # does not print anything and returns the error code 1

Even with copying all environment variables disabled, one can still copy specific values
from the host or set specific variables to have specific values for the denv.

    denv config env copy baz myfoo=mybaz
    denv printenv myfoo # prints "mybaz"
    printenv myfoo      # does not print anything and returns error code 1
    denv printenv baz   # not set in host yet so does not print anything
    export baz="hooray"
    denv printenv baz   # prints "hooray"

# INSTALLATION

## curl

If you trust me (or have proofread the install script), you can install denv with a one-liner.

    curl -s https://raw.githubusercontent.com/tomeichlersmith/denv/main/install | sh 

By default, this installs denv to ~/.local if you are a non-root user.
You can define the install prefix (--prefix dir),
choose to use the HEAD of the main branch rather
than the last release (--next), and disable the singe-character alias for denv
(--simple), all of which are optional.

    curl -s https://raw.githubusercontent.com/tomeichlersmith/denv/main/install | \
      sh -s -- --prefix dir --next --simple

## git

You can install or update denv by obtaining the source code from the repository https://github.com/tomeichlersmith/denv either by cloning it or by downloading one of the releases and then running the installation command.

    cd denv
    ./install

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

  - **denv init** errors out if there is already a denv in the deduced workspace
  - **denv init** and **denv config image** will not pull an image if it already exists

# FILES

This part of the manual is an attempt to list and explain the files within a `.denv` directory.

## config

The file storing the configuration of the denv related to this workspace.
While it is plain-text and you can edit it directly. Editing it with the denv config set of commands
is helpful for doing basic typo- and existence- checking. The config file is a basic key=value shell
file that will be sourced by denv. This is a security risk and could be updated to a different type
of config file if desired.

  **denv_name** the name for this denv

  **denv_image** the image to use when running the denv

  **denv_shell** the program to run as a interactive shell if running denv without any arguments

  **denv_mounts** a space separated list of extra mounts to mount into denv when running

## skel-init

This is an empty file that, if it exists, signals to the entrypoint executable that the files from /etc/skel have
been copied into the denv home directory. This prevents accidental overwriting of files that the user may edit as
well as saving time when starting up the container.

## images

This is a directory that holds any image files that may be generated by the runner denv is using to run the container.
For some runners, it is helpful to explicitly build an image outside of the cache directory and then run that image
file. This directory holds those images. It can be deleted if the user wishes to reclaim some disk space; however, that
means any image that are configured to be used by denv will then be re-downloaded and re-built.

# CONTRIBUTING

Feel free to create a fork of https://github.com/tomeichlersmith/denv and open a Pull Request with any bug patches or feature improvements. We aim to keep denv as a single file with optional completion and manual files in parallel.

Install shellcheck from https://github.com/koalaman/shellcheck and use it to make sure denv avoids common shell scripting errors.

    ./ci/check

Make sure that denv still passes the non-interactive tests.

    DENV_RUNNER=<your-runner> ./ci/test
