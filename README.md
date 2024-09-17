## Goal

We want to build a Linux system from Scratch as described in the Linux From Scratch (LFS) book using Bazel as the build system.

## Why Bazel?

Bazel is a highly scalable build system that is typically used for large, complex builds. Using Bazel to manage the steps in LFS can make things reproducible and more efficient by using caching, parallelism, and dependency management.


## Observations

### Bazel default sandboxing uses strange absolute paths

When running the build with the default sandboxing, Bazel uses absolute paths that are not present in the host system and are not present in the target system. This works fine for applications that are built with Bazel, but it does not work for the LFS build.
Composing the system from scratch requires to operate on absolute paths in the target system, relative paths on the host system are a bad fit.

Currently, the workaround is to exit the bazel sandbox and work on /tmp.
The proper solution would be to explore the `--sandbox_tmpfs_path` option.
Alternatively, other sandbox implementations e.g. chroot or containerization could be explored.

### gcc compiler is especially picky about sysroot

gcc compiler is not relocateable, and requires the sysroot to be set correctly during configuration time.
That might be one of the reasons why crosstoool-ng and buildroot seem to exist.
That also might be the reason why build systems abstract the compiler with toolchain files / wrappers that override sysroots.

### Mixing autotools with bazel is tricky

Bazel assumes to be the main scheduler and to have full control over the build environment.
Bazel calls autotools, which in turn call other tools, which in turn call other tools.
Autotools also assume to be the main scheduler and to have full control over the build environment.
Proper solution would be to use make jobserver protocol to coordinate the build.
Alternatively, autotools could be replaced with bazel rules.

### Non reproducible builds

The LFS book is not designed to be reproducible, and the build steps are not idempotent. This means that if you run the build twice, you will get different results. This is a problem for Bazel, which expects the build to be reproducible.

Specific observations:
