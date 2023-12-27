# Developing in a VM

A full virtual machine (VM) can be very helpful for developing and testing these applications.
Oftentimes, developers don't want to have all of the container runners they wish to test on
their bare metal system, so it is helpful to learn how to test these options within a VM.

These notes are developed for the 
[Virtual Machine Manager](https://virt-manager.org/) that I use on Linux Mint.
From casual browsing, it appears that other VM managers can do similar processes.

## Mount Source Code
I don't want to install all of my code editing toolkits into a simple test VM,
so I instead mount the directory my source code is in into the VM so that the
VM can just see the current code I'm writing on the host.

Credit where credit is due, these notes are just parroting the tutorial given
by [Arindam on Debugpoint](https://www.debugpoint.com/share-folder-virt-manager/).

#### On the Host in the VM Manager
1. Make sure the "Enable shared memory" box is checked in the "Memory" section of the VM settings
2. Add a filesystem to the VM
    1. Select "Add Hardware" and choose "Filesystem"
    2. Driver: virtiofs (was the default for me)
    3. Source path: /full/path/to/denv/on/host (can use GUI file manager)
    4. Target path: denvsource (more of a name rather than a path as you'll see below)

#### Inside the VM
1. Make sure the mount point for the source code exists
```
mkdir -p denv
```
2. Mount the virtual filesystem to our mount point
```
sudo mount -t virtiofs denvsource denv/
```
3. Do a developer's install so that we can run denv like normal
```
cd denv/
./install -d
```
