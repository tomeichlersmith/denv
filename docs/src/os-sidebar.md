# Sidebar on Operating Systems
⚠️ This section is laced with sarcasm. ⚠️

Containers are a technology created from combining a few Linux kernel features.
This makes them incredibly versatile _and_ just confusing enough to be wrapped in thick layers of software and high-tech jargon.
Many others have written about the technology underpinning containers[^2], so I won't go into more detail here.
I merely point this out to emphasize that non-Linux operating systems only access containers via Virtual Machines (VM) hosting Linux.[^3]
Specifically, this means the other two big operating systems (Mircrosoft Windoze and Mac OS X) must be accomodated with VMs.

#### Windoze
(Misspelling Windows as Windoze since I think its funny.)

Microsoft released Windoze Subsystem for Linux (WSL) in 2016 after finally realizing that work can only really get done
within a functional operating system (like Linux-based ones).
While largely expected to be apart of their [Embrace Extend Extinguish](https://en.wikipedia.org/wiki/Embrace,_extend,_and_extinguish)
methodology, it still benefits us in that we can use containers in an almost equivalent way they would be used on a Linux system with
the added step of having to wait for Windoze to boot and open WSL.
One of the most popular container runners docker [just plainly tells people to use WSL](https://docs.docker.com/desktop/install/windows-install/)
when installing it.

With this context in mind, **`denv` supports Windoze indirectly through WSL** in the same manner as docker.
If you are on Windoze, first enable WSL and then interact with docker
(or whatever runner you want[^4]) and `denv` within the WSL terminal.

#### Mac OS X
Both docker and podman support Mac OS X by spawning light weight VMs that can be kept idle while awaiting
container instruction.[^5] Since Mac OS X has a more similar filesystem (and presumably kernel) to Linux,
its VM is able to have a tighter integration with the host system. This has both benefits and difficulties.
The benefit is that we presumably get performance improvements (I'm assuming this, I have not tested it.)
The downside is that the user is not exposed directly to a terminal within the Linux kernel system like they
are for Windoze (via WSL) or bare-metal Linux. This is an issue for `denv`
(and [for other container wrappers](https://github.com/89luca89/distrobox/issues/36)) since, as a wrapper,
we are trying to connect the container and host which is difficult to do when given only limited access
to the intermediary VM layer.

With this context in mind, **`denv` has limited support for Mac OS X**. Namely, `denv` is able to support
_non-ID-necessary processes_ within the constructed denv. For example, compiling and running a program
within `denv` works fine but making a commit with `git` within it does not.
The discovery of this limitation and any ongoing work
is tracked in [denv Issue #102](https://github.com/tomeichlersmith/denv/issues/102).

#### Graphical Applications
`denv` ensures that the X11 apps spawned from within the container can connect with the host
by passing the `DISPLAY` environment variable and mounting the `/tmp/.X11-unix` directory.
For Linux-hosts and WSL, this is enough[^6]; however, on MacOS additional setup is required.

If you don't plan to use a graphical application from within the a denv (or if you are just
using a network-based application like Jupyter Lab), then there is no need to do this
additional setup on MacOS. [These instructions](https://gist.github.com/roaldnefs/fe9f36b0e8cf2890af14572c083b516c)[^7]
which basically amount to installing XQuartz[^8] and then disabling access control
with `xhost +` (check links for specific, permanent configuration of XQuartz after installation).

[^2]: [The container is a lie](https://platform.sh/blog/the-container-is-a-lie/) is a nice article going into detail
about the underpinnings of containers with a bit a click-baity title. Charliecloud's
[containers are not special](https://hpc.github.io/charliecloud/tutorial.html#containers-are-not-special) 
is only a moderate improvement in the title department and another approach to the material. Finally, I've liked
[containers from scratch](https://ericchiang.github.io/post/containers-from-scratch/) and
[Containers are chroot with a marketing budget](https://earthly.dev/blog/chroot/)
which take a more educational approach to help readers see why wrapping container creation and running in managers has been done (while also
showing that it is an easy enough procedure for there to be many managers floating around).

[^3]: _Technically_, I might be wrong here since a specific kernel might offer the same features that Linux
offers that enables containers (or a specific subset of configurations of containers), but I digress.

[^4]: While I haven't tested this myself or found any evidence online, I expect that since docker
functions within WSL other runners will function within WSL as well although they won't have a
graphical interface running outside of WSL (Docker Desktop).

[^5]: I am not as familiar with the technical underpinnings of how docker or podman on Mac works since
I have not had a computer to test and learn with it myself. If you have a technical correction to this
section, please feel free to open an Issue or PR.

[^6]: I haven't tested this thoroughly on WSL, but [WSL's Containers page](https://github.com/microsoft/wslg/blob/main/samples/container/Containers.md)
appears to support this conclusion as well. This page also implies that `denv` could support Wayland
applications with a few more mounts and environment variables.

[^7]: Or [these](https://gist.github.com/sorny/969fe55d85c9b0035b0109a31cbcb088). Honestly, there
are many tutorials after searching for "docker macos graphics" or similar.

[^8]: You can install XQuartz [using brew](https://formulae.brew.sh/cask/xquartz)
or [using the `.dmg` file](https://www.xquartz.org/).
