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

**`--name`** sets the name for the denv workspace that is being initialized

# ARGUMENTS

**`IMAGE`**   the name of a container image to use when starting a container to host the developer environment

**`WORKSPACE`** the directory where the environment should be stored and configured, used by default
              as the home directory within the developer environment so that the environment can also
              have its own shell configuration files and **~/.local** paths.

# SEE ALSO

**denv(1)**, **denv-config(1)**
