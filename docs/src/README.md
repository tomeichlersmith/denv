# denv
containerized development environments across many runners

## Installation

### curl

If you trust me (or have proofread the install script), you can install denv with a one-liner.

    curl -s https://raw.githubusercontent.com/tomeichlersmith/denv/main/install | sh 

By default, this installs denv to ~/.local if you are a non-root user.
You can define the install prefix (--prefix dir) and 
choose to use the HEAD of the main branch rather
than the last release (--next) both of which are optional.

    curl -s https://raw.githubusercontent.com/tomeichlersmith/denv/main/install | \
      sh -s -- --prefix dir --next

### git

You can install or update denv by obtaining the source code from the repository https://github.com/tomeichlersmith/denv either by cloning it or by downloading one of the releases and then running the installation command.

    cd denv
    ./install

## Contributing

Feel free to create a fork of https://github.com/tomeichlersmith/denv and open a Pull Request with any bug patches or feature improvements. We aim to keep denv as a single file with optional completion and manual files in parallel. Check that denv is still POSIX with dash.

    dash -n denv

Install shellcheck from https://github.com/koalaman/shellcheck and use it to make sure denv avoids common shell scripting errors.

    shellcheck -s sh -a -o all -Sstyle -Calways -x denv
