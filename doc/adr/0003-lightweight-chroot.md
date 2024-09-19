# 3. lightweight-chroot

Date: 2024-09-19

## Status

Accepted

## Context

The build needs a solution to enter a chroot environment.
The LFS book asks for chroot to be used to enter the new system.
This requires root privileges and is not compatible with bazel design choices.

Alternative solutions considered:
* disable bazel sandboxing, use chroot and sudo. However this requires root priviledges, and errors in builds may impact the host (e.g. mount real sys/proc files, then delete them, been there, done that)
* explore alternative sandboxing solutions, e.g. use docker, podman, or other container solutions. However, these are heavyweight and may not be available on all systems. Also this may not work when already in a container (e.g. CI/CD or devcontainer)
* explore fakechroot with fakeroot and chroot. This would stay close to the original LFS book intention, but kept segfaulting on me.
* explore bubblewrap, which is a lightweight sandboxing solution. This is the most promising solution, but requires a bit of setup and is not available on all systems.

## Decision

Use bubblewrap to enter a chroot environment. Use tars for the rootfs, not container images.

## Consequences

* The build can now proceed beyound chapter 7, and enter the chroot environment.
* Bubblewrap is now a build dependency and added to version check.
