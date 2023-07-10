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
