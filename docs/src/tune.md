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
while launched `sh` and before the command is run, specifically, one of the files
that can be used is at `~/.profile` (or `<workspace>/.profile` outside the denv).
Updating this file with changes to `*PATH` variables (like `PATH`, `LD_LIBRARY_PATH`,
and `PYTHONPATH`) can be helpful so that executables can be run interactively
(i.e. `denv` then `my-executable`) and non-interactively (i.e. `denv my-executable`).

## extra mounts
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
and to already exist. This prevents user typos as well as insures the user
knows what path will be available within the denv (i.e. symlinks _outside_
the denv may not map properly _inside_ the denv).

[^1]: This isn't exactly true. denv also mounts a few helper files as well
(e.g. the entrypoint program `_denv_entrypoint`); however, those are single-file
mounts that can be ignored by normal users.
