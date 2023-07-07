# Vocabulary

Before delving deeper into the complicated world of containers and their runners,
I want to make sure you and I are on the same page about the meaning of some words.

Each of the items below is a word which I define for the purposes of this manual.
They may have different definitions outside of this manual.

- **denv**: a shortening of "*d*evenlopment *env*ironment" and is used to refer to
  both the command that is being documented here `denv` *and* the environment that
  the command spawns when run successfully. Generally, you should read its means
  as the environment when preceded by "the" and the command otherwise. An overly
  convoluted example is "The denv is created by running denv.". The first use refers
  to the spawned environment and the second refers to the command.
  - The default installation of `denv` comes with an alias for the command which is
    the special backslash character, so one can run `denv` also by running `\\` at
    the command line. This means I often read `\\` as `denv` in my head.
- **container**: while not technically correct, I usually think of containers as
  light-weight virtual machines (VMs). This gets the point across that they have
  a different environment and can contain software that couldn't run on the host.
- **image**: the data that can be used to launch a container with specific
  software in it. Usually, images consist of _layers_ which are created by
  running different commands within the image during the build process.
  - Look into [Developing the Environment](./env_dev.md) to learn more
    about building images for use with `denv` in mind.
