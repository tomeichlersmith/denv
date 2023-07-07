# Developing the Environment
By "developing the environment" I mean changing the image `denv` runs
in some way. Usually, this means adding a new dependency so that the
code can continue to progress; however, it could also mean patching
how a certain dependency is configured, where something is installed,
or making quality-of-life updates to the environment.

It is important to emphasize once again that `denv`
**is not** a tool for actually building the images that
are used to create development environments. The reasons
for this are (in rough order):

1. Most HPCs do not have `apptainer`/`singularity` installations
   that support building from a recipe file. I wanted a tool whose
   interface and uesr experince can be uniform including these runners
   and their common limitations.
2. Avoid build repetition. Many projects I work on have dependencies
   that take hours to build even on fast multi-core machines. This means
   it can save many people time if the container image is built once for
   everyone and then distributed via a registry (like DockerHub).
3. The separation of developing the environment from developing the code
   that requires the environment is helpful for isolating complicated
   dependency issues from the normal developer. The image build context
   could even be kept in a separate repository in order to enforce this
   isolation.

Now that is out of the way, I have a few suggestions to make about
how to develop these environments. Since my ability to build images
from a recipe file with `singularity` or `apptainer` is restricted
and I usually already have `docker` or `podman` installed, the images
are built using `docker` (or `podman`) and then pushed to the registry
from which `denv` can pull them.

## Install Locations
Since the image being run by `denv` has its own root filesystem,
it is usually helpful to install dependencies into system locations
(like `/usr/local`) so that downstream projects (either more dependencies
or the code that is being developed) can easily find these dependencies.

## Environment Variables
Instead of expecting users to correctly write configurations into
the `.bashrc` in their workspace, one can make heavy use of environment
variables in the image definition.

## distrobox
This is probably the biggest tip. Remember when I said that distrobox
inspired denv and denv has a smaller feature set? Well, I think distrobox
is a good companion for denv - especially for denv users who wish to
develop the environment a bit.

I often open a distrobox with a specific image in order to try adding
new dependencies and once that installation process if deduced, I can
build the dependency into the image and use it later with denv.

## Version Control
Similar to the code being developed, it is generally important to
strictly version control the image used to create the denv. This helps
keep track of the complicated process of aligning dependencies as well
as help users know which dependencies (and the versions of them) they
have access to.
