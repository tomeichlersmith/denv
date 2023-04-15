# NAME

dbx v0.0.0

# SYNOPSIS

**dbx** 

# DESCRIPTION

**dbx** is a light, POSIX-compliant wrapper around a few common container managers,
allowing the user to efficiently interact with container-ized envorinments uniformly
across systems with different installed managers.

## OPTIONS

## ARGUMENTS

# EXAMPLES

# INSTALLATION

## curl

If you trust me (or have proofread the install script), you can install dbx with a one-liner.

    curl -s https://raw.githubusercontent.com/tomeichlersmith/dbx/main/install | sh 

By default, this installs dbx to ~/.local if you are a non-root user.
You can define the install prefix (--prefix dir) and 
choose to use the HEAD of the main branch rather
than the last release (--next) both of which are optional.

    curl -s https://raw.githubusercontent.com/tomeichlersmith/dbx/main/install | \
      sh -s -- --prefix dir --next

## git

You can install or update dbx by obtaining the source code from the repository https://github.com/tomeichlersmith/dbx either by cloning it or by downloading one of the releases and then running the installation command.

    cd dbx
    ./install

# CONTRIBUTING

Feel free to create a fork of https://github.com/tomeichlersmith/dbx and open a Pull Request with any bug patches or feature improvements. We aim to keep dbx as a single file with optional completion and manual files in parallel. Check that dbx is still POSIX with dash.

    dash -n dbx

Install shellcheck from https://github.com/koalaman/shellcheck and use it to make sure dbx avoids common shell scripting errors.

    shellcheck -s sh -a -o all -Sstyle -Calways -x dbx
