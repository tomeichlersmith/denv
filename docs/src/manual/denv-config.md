# NAME

denv config

# SYNOPSIS

**denv config** [help|-h|--help]

**denv config** print \[env\]

**denv config** image <pull | IMAGE>

**denv config** mounts DIR0 [DIR1 DIR2 ...]

**denv config** shell SHELL

**denv config** env [help|-h|--help]

**denv config** env print

**denv config** env all [yes|no]

**denv config** env copy VAR0[=VAL0] [VAR1[=VAL1] ...]

# DESCRIPTION

Manipulate the configuration of a denv that already exists.
The commands here will all fail if a denv hasn't been created,
see **denv-init(1)** to create a new denv.

**`denv config`** is separated into a set of sub-commands that
are focused on manipulating the different aspects of the denv
configuration. These correspond to the different keywords specified
after 'config'.

## COMMANDS

**help** print a help message for **`denv config`**. This is the command that is issued
         if no keywords are given. It also has the aliases **`-h`** and **`--help`**.

**print** print the loaded denv configuration. This is helpful for debugging purposes and
          inspecting the denv that you currently have configured.

**image** set (and potentially pull) the container image that should be used with the denv
          that you currently reside in.

**mounts** provide additional directories to mount into the denv during running.

**shell** set the shell that should be executed by denv if no other command is given by the user.

**env** manipulate and view the environment variables that will be provided to the denv at run time.

# ARGUMENTS

Below are different arguments that can be provided separated by which command they correspond to.

## print

**env** If any argument is provided to print, then all of the environment variables that will be passed into
        the denv are printed after the deduced configuration. Without an argument, print will just show the
        deduced configuration and only print the environment variables if copy-all is false.

## image

**IMAGE** The provided argument is the image tag that should be used for running with the denv. If this argument
          is the special key-word 'pull', then it won't change the actual image tag and instead re-download the
          currently configured image from the registry.

For apptainer and singularity runners, this IMAGE can also be a filesystem path to a unpacked image that is
already downloaded (and unpacked) somewhere else on the computer. In this case, we simply symlink the image
to our image cache so denv can operate like normal. Work is on-going to investigate supporting this workflow
for other container runners <https://github.com/tomeichlersmith/denv/issues/37>.

## mounts

**DIR** Each of the space-separate arguments are interpreted as a directory that should be included in the list
        of mounts for the container that denv spawns. These are in addition to the mount of the denv workspace
        to the container home directory. They are mounted into the container at the same filesystem location that
        they have on the host. These directories are required to be full paths so that the user is cognizant 
        of what paths will be available in the container and what arent.
        One can use **realpath(1)** to deduce a fullpath from a relative path in a POSIX-compliant way if desired.

## shell

**`SHELL`** the program to use as the interactive shell within the containerized environment.
            No checks on what this program is or if it is even available within the container are done.
            As the name implies, **`denv`** expects it to be some shell that the user can interact with
            but technically it is just the default program that is run when the user does not provide
            any arguments to **`denv`**.

## env

The **`env`** subcommand has its own sub-commands due to the variability of defining which environment
variables should be copied into the containerized environment.

**help** print a help message for this subcommand. This has aliases **`-h`** and **`--help`** as well.

**print** print out the environment variables and their values that will be passed into the container.

**all** toggle the decision on if all possible environment variables from the host environment should be copied.
        **`yes`**, **`true`**, **`on`** all mean to copy all possible variables from the host environment, while
        their inverses **`no`**, **`false`**, **`off`** mean to disable this feature and only copy variables that
        are explicitly defined via the **`copy`** command below. Variables defined with a specific value overwrite
        any values that would be copied from the environment.

**copy** configure which environment variables to copy into the denv at runtime. Each of the space-separated
        arguments to this command are treated separated and are interpreted as a **VAR* with an optional **VAL**
        distinguished by a '=' character.

- **`VAR`** environment variable name either in the host environment that should be copied into the denv
        (if no value is specified with an '=' sign) or defined to a specific value (when a value
        is specified with an '=' sign). These names cannot match special shell environment
        names (e.g. 'HOME') or special denv names (e.g. 'DENV_RUNNER').

- **`VAL`** environment variable value to use instead of the value from the host environment.
        These values cannot have the special characters:
        space \' \', tick \'`\', quote \'"\', or dollar-sign \'$\'.
        Providing a value for a specific environment variable means that variable does not need
        to exist in the host environment. Moreover, providing a values takes precedence: if a value
        is provided, the denv will receive that value, ignoring any value that may exist in the environment
        (even if **all** is toggled to on and all environment variables are being copied).

# SEE ALSO

**denv(1)**, **denv-init(1)**
