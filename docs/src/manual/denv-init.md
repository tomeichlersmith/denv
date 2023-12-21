# NAME

denv init

# SYNOPSIS

**denv init** [help|-h|--help] IMAGE [WORKSPACE] [--no-gitignore] [--clean-env|--no-copy-all] [--force] [--name NAME]

# OPTIONS

**`--help`**, **`-h`**, or **`help`** print a short help message for **`denv`** or one of its sub commands

**`--no-gitignore`** do not generate a gitignore file when setting up a new denv configuration

**`--clean-env`** or **`--no-copy-all`** do not enable copying of all host environment variables within the new denv.
  Later activation (or deactivation) of copying all host environment variables can be done with **`denv config env all`**
  See **denv-config(1)** for details on **`denv config`**.

**`--force`** forces re-initialization of a denv even if the current workspace has one

**`--name`** sets the name for the denv workspace that is being initialized to NAME

# ARGUMENTS

**`IMAGE`**   the name of a container image to use when starting a container to host the developer environment

**`WORKSPACE`** the directory where the environment should be stored and configured, used by default
              as the home directory within the developer environment so that the environment can also
              have its own shell configuration files and `~/.local` paths. If not provided, we just use
              the current working directory. If provided, we make sure it exists, enter it and then
              continue.

# EXAMPLES

Print the command line help for **`denv init`** without making any edits to the filesystem or beginning
the process of configuring a new denv.

    denv init help

Create a new denv based off the python:3.11 container image within the current directory,
allowing all host environment variables to be copied into the denv when running.

    denv init python:3.11

Same as above, but do _not_ allow the host environment variables to be copied into the denv.

    denv init --clean-env python:3.11

Create a new denv based off the python:3.11 container image and set its name to "py311" rather
than the workspace directory's name.

    denv init python:3.11 --name py311

Create a new denv in some other location besides the current directory. Since the directory has
the same name as above, the denvs will appear similar even though their workspace directory
(on the host) may be different names.

    denv init python:3.11 py311

# SEE ALSO

**denv(1)**, **denv-config(1)**
