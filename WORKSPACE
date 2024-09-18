# WORKSPACE

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load(
    "//:versions.bzl",
    "BASH_SHA256",
    "BASH_VERSION",
    "BINUTILS_SHA256",
    "BINUTILS_VERSION",
    "COREUTILS_SHA256",
    "COREUTILS_VERSION",
    "DIFFUTILS_SHA256",
    "DIFFUTILS_VERSION",
    "FILE_SHA256",
    "FILE_VERSION",
    "FINDUTILS_SHA256",
    "FINDUTILS_VERSION",
    "GCC_SHA256",
    "GCC_VERSION",
    "GLIBC_SHA256",
    "GLIBC_VERSION",
    "LINUX_KERNEL_SHA256",
    "LINUX_KERNEL_VERSION",
    "M4_SHA256",
    "M4_VERSION",
    "NCURSES_SHA256",
    "NCURSES_VERSION",
)

http_file(
    name = "binutils_tarball",
    sha256 = BINUTILS_SHA256,
    urls = ["https://sourceware.org/pub/binutils/releases/binutils-{}.tar.xz".format(BINUTILS_VERSION)],
)

http_file(
    name = "gcc_tarball",
    sha256 = GCC_SHA256,
    urls = ["https://ftp.gnu.org/gnu/gcc/gcc-{0}/gcc-{0}.tar.xz".format(GCC_VERSION)],
)

http_file(
    name = "linux_kernel_tarball",
    sha256 = LINUX_KERNEL_SHA256,
    urls = ["https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-{0}.tar.xz".format(LINUX_KERNEL_VERSION)],
)

http_file(
    name = "glibc_tarball",
    sha256 = GLIBC_SHA256,
    urls = ["https://ftp.gnu.org/gnu/glibc/glibc-{}.tar.xz".format(GLIBC_VERSION)],
)

http_file(
    name = "glibc_fsh_patch",
    sha256 = "643552db030e2f2d7ffde4f558e0f5f83d3fabf34a2e0e56ebdb49750ac27b0d",
    urls = ["https://www.linuxfromscratch.org/patches/lfs/12.2/glibc-2.40-fhs-1.patch"],
)

http_file(
    name = "m4_tarball",
    sha256 = M4_SHA256,
    urls = ["https://ftp.gnu.org/gnu/m4/m4-{}.tar.xz".format(M4_VERSION)],
)

http_file(
    name = "ncurses_tarball",
    sha256 = NCURSES_SHA256,
    urls = ["https://ftp.gnu.org/gnu/ncurses/ncurses-{}.tar.gz".format(NCURSES_VERSION)],
)

http_file(
    name = "bash_tarball",
    sha256 = BASH_SHA256,
    urls = ["https://ftp.gnu.org/gnu/bash/bash-{}.tar.gz".format(BASH_VERSION)],
)

http_file(
    name = "coreutils_tarball",
    sha256 = COREUTILS_SHA256,
    urls = ["https://ftp.gnu.org/gnu/coreutils/coreutils-{}.tar.xz".format(COREUTILS_VERSION)],
)

http_file(
    name = "diffutils_tarball",
    sha256 = DIFFUTILS_SHA256,
    urls = ["https://ftp.gnu.org/gnu/diffutils/diffutils-{}.tar.xz".format(DIFFUTILS_VERSION)],
)

http_file(
    name = "file_tarball",
    sha256 = FILE_SHA256,
    urls = ["https://astron.com/pub/file/file-{}.tar.gz".format(FILE_VERSION)],
)

http_file(
    name = "findutils_tarball",
    sha256 = FINDUTILS_SHA256,
    urls = ["https://ftp.gnu.org/gnu/findutils/findutils-{}.tar.xz".format(FINDUTILS_VERSION)],
)
