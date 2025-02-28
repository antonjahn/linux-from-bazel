# Linux From Bazel - Build Commands

## Build Commands
- Build all: `bazel build //...`
- Run version check: `bazel run scripts/version-check.sh`
- Run specific build rule: `bazel build build_<package_name>`
- Run temporary rootfs: `bazel run run_temporary_rootfs`
- Run initial rootfs: `bazel run run_initial_rootfs`
- Build final system: `bazel build build_final_system`

## Package Categories
1. Toolchain: `binutils`, `gcc`, `glibc`, `linux-headers`
2. Basic utilities: `coreutils`, `bash`, `grep`, `sed`, `gawk`
3. Build tools: `m4`, `make`, `autoconf`, `automake`, `libtool`
4. System components: `systemd`, `kmod`, `e2fsprogs`, `iproute2`
5. Security: `shadow`, `libcap`, `openssl`
6. File utilities: `file`, `find`, `xz`, `zlib`, `bzip2`, `gzip`
7. User interface: `ncurses`, `vim`, `less`
8. Boot: `grub`, `kernel`

## Coding Guidelines
- Use Bazel BUILD files for all build definitions
- Follow the Linux From Scratch book structure for dependencies
- Use genrule() for package builds with shell scripts
- Shell scripts should use bash and follow POSIX-compatible patterns
- Separate package builds into extract → configure → make → install steps
- For dependency management, use the versions defined in versions.bzl
- Run packages tests when possible using `make check`
- Sanitize dependencies with cleanup_extracted_dependencies()
- Use ENTER_LFS_SCRIPT for chroot builds