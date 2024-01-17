# NAME

denv check

# SYNOPSIS

**denv check** [-h|--help] [-q|--quiet]

# OPTIONS

**`--help`** or **`-h`** print a short help message

**`--quiet`** or **`-q`** suppress non-error output

# EXIT CODES

**`denv check`** follows the POSIX convention of returning a non-zero exit code when a
failure condition is encountered.

Code Description
---- --------------------------------------------------------------------------------------------------------------------
0    success, denv installation is complete and there is a supported runner to use (or the user printed the help message)
1    failure, denv cannot find the entrypoint script as an executable in the directory it is installed in
2    failure, denv cannot find a supported runner to use
127  denv check was supplied an argument it didn't recognize

# SEE ALSO

**denv(1)**, **denv-config(1)**, **denv-init(1)**
