# 2. use-tmp-as-lfs-prefix

Date: 2024-09-17

## Status

Accepted

## Context

The build scripts of gcc expect that the sysroot is defined as an absolute path at configure time.
This path is hard-coded into the gcc binary and cannot be changed after the build.
Absolute paths do not work well with the bazel sandbox, as the hashes and ids in the paths are different for each build.
Writing to absolute system paths is also not allowed within the bazel sandbox.

Options:

1. Use a relative path as the sysroot.
   * This would produce a relocatable sysroot, but the gcc build scripts do not support this.
   * This would require either patching the gcc build scripts or writing a custom gcc wrapper.
   * Alternatively, we the build system downstream would need to be modified to specify the sysroot at build time.
2. Use a temporary directory as the sysroot.
   * This would allow the gcc build scripts to work as expected.
   * The /tmp directory is writeable and is setup in a clean state at the start of each action in bazel.
   * No modifications to the gcc build scripts are required.
   * No modifications to the build system downstream are required.

## Decision

Use a temporary directory as the sysroot.

## Consequences

Set the lfs root to /tmp/lfs for the build process.
