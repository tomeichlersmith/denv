# Vocabulary

Before delving deeper into the complicated world of containers and their runners,
I want to make sure you and I are on the same page about the meaning of some words.

Each of the items below is a word which I define for the purposes of this manual.
They may have different definitions outside of this manual.

- **denv**: a shortening of "*d*evelopment *env*ironment" and is used to refer to
  both the command that is being documented here `denv` *and* the environment that
  the command spawns when run successfully. Generally, you should read it
  as the environment when it is an improper noun (i.e. preceded by an article like "the" 
  or "a") and the command otherwise. An overly convoluted example is "The denv is 
  created by running denv.". The first use refers to the spawned environment and 
  the second refers to the command. In this manual, I try to represent "denv" as
  code when it refers to the command.
  - Pronunciation: Personally, I have always pronounced "denv" as "d/ea/nv"
    but many folks I collaborate with read it as "dee-/ea/nv".
- **container**: while not technically correct, I usually think of containers as
  light-weight virtual machines (VMs). This gets the point across that they have
  a different environment and can contain software that couldn't run on the host.
- **image**: the data that can be used to launch a container with specific
  software in it. Usually, images consist of _layers_ which are created by
  running different commands within the image during the build process.
  - Look into [Developing the Environment](../env_dev.md) to learn more
    about building images for use with `denv` in mind.
- **workspace**: the special directory containing all of the files that are being
  worked on. This is simply a shorthand for this special directory and can, for
  most use cases, map pretty cleanly to the "repository root directory" or (if
  you are using `git`), the directory that contains the hidden directory `.git`.
- **runner**: a program that uses a _image_ to start up a _container_ with which
  the user can interact. In this project, I use "container runner" and "container
  manager" interchangeably even though they aren't technically the same. The
  requirements on a "runner" to be a backend for denv are defined in
  [Adding a new Runner](../new_runner.md).
