# Adding a new Runner

I use "runner" and "manager" pretty much inter-changeably on this site
because, for the purposes of `denv`, the difference between the two is
not of great importance.

## Requirements
There are two main features that a program needs to satisfy in order
to be usable by `denv` as a container-interaction backend.

1. Download Images from a Registry
2. Check if an Image is already Downloaded
3. Run the Image as a Container

Usually container "runners" are specifically focused on doing the
last task (and only that one) while "managers" can do all of
these tasks and more (like building images, pushing images to a registry,
tagging images, etc...).

The main reason I use manager and runner interchangeably here is because
we do not use a lot of the features managers provide and so I could easily
forsee `denv` supporting a runner whose download/check mechanism is some
`curl` or `wget` shell scripting nonsense rather than a call to the runner
program itself.

## Running the Image
This section expands a bit on the requirements on the runner when running
an image. For specifics, one will need to look at the denv source itself
to see how the currently-supported runners run images as containers.

`denv` wishes to integrate the containerized environment with the host
environment in several ways so that the user, while developing within a
denv, can easily use programs within the denv as if they are installed
within the host system. This leads to a few requirements on the program
that runs the images.

- **User Ownership**: any files written when in the denv should be owned
  by the user once they exit the denv
- **Launching GUI Programs**: the user should be able to launch an GUI
  program from within the denv
- **Network and Port Connection**: the user should be able to use the host
  network and connect to ports on `localhost` within the denv
- **Home Directory**: the in-denv home directory should be set to the
  workspace outside of the denv
- **Environment Variables**: besides hidden (beginning with `_`) and 
  special (e.g. `HOME` and `HOSTNAME`) varaibles, all environment variables
  should be passed into the denv along with a few denv-specific variables

## What to Test
If you are developing a new runner to be wrapped by `denv`, the natural next
question to ask is how should I test that it is functional. 

First and foremost, make sure your additions to `denv` still pass the
non-interactive tests.
```
./ci/check
DENV_RUNNER=<your-runner> ./ci/test
```
These can be enabled in your fork of denv so that they run automatically on GitHub
when you push to a branch on your fork. In order for GitHub to be able to test
your runner, you will need to install it into the runner during the testing workflow
(`.github/workflows/test.yml`).

Besides the non-interactive tests, there are some additional, manual tests that
I haven't figured out how to automate since they check interactions between
the host and denv environments.

### Make sure GUI Programs can be launched
There is a small image that can be used to test whether GUI programs can be
run from within a denv. Both launching from a in-denv shell and launching
it directly from outside the denv should work properly.
```
mkdir gui-test
denv init fr3nd/xeyes
# from a in-denv shell
denv
xeyes
exit
# from a non-interactive shell
denv xeyes
```

### Make sure Network and Ports are Connected
My main reason for supporting this is to allow me to interact with a
[Jupyter Lab](https://jupyterlab.readthedocs.io/en/latest/) instance 
running from within the denv. The Jupyter Project has built some
images with their software installed which can be used for testing.
```
mkdir net-test
cd net-test
denv init jupyter/datascience-notebook
denv jupyter lab --no-browser
```
The user should be able to access the localhost link displayed by
jupyter. **Note**: Developers should know that these images have
a very special user and entrypoint configuration specialized for
jupyter lab which may cause extra complications.