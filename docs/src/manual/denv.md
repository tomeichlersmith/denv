# NAME

denv v0.4.1

# SYNOPSIS

**denv** [help|-h|--help]

**denv** version

**denv** init [args]

**denv** config [args]

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

**`COMMAND`** any other command not matching one of the options above is provided to the
              configured denv to run within the containerized environment. The rest of the
              command line is passed along with COMMAND so its args are seen as if they
              were run manually within the shell of the container.

# SEE ALSO

**denv-init(1)**, **denv-config(1)**

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

## Sharing Environment Variables

The syntax for sharing environment variables with the denv is a bit terse, so it is helpful
to display some examples.

By default (without **`--no-copy-all`** or **`--clean-env`** when running **`denv init`**), **`denv`** will copy all
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

  **denv_env_var_copy_all** a boolean flag signalling if **`denv`** should copy all possible host environment
    variables into the denv (`"true"`) or not (`"false"`).

  **denv_env_var_copy** a space-separated list of host environment variables to copy into the denv.
    This is ignored if **denv_env_var_copy_all** is `"true"`. There are some restrictions on the names
    of variables that can be used and so editing this value directly is not recomended. Use **`denv config env copy`**
    which does this validation.

  **denv_env_var_set** a space-separate list of key=value pairs that will be set as environment variables
    within the denv. These values override any values that could be copied from the host. There are restrictions
    on the names and values that can be kept here so editing this value directly is not recommended.
    Use **`denv config env copy`** to edit this value while validating that the rules are followed.

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
