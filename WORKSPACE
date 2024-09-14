# WORKSPACE

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load(
    "//:versions.bzl",
    "BINUTILS_SHA256",
    "BINUTILS_VERSION",
    "GCC_SHA256",
    "GCC_VERSION",
    "LINUX_KERNEL_SHA256",
    "LINUX_KERNEL_VERSION",
)

http_file(
    name = "binutils_tarball",
    sha256 = BINUTILS_SHA256,
    urls = ["https://sourceware.org/pub/binutils/releases/binutils-{}.tar.xz".format(BINUTILS_VERSION)],
)

http_file(
    name = "gcc_tarball",
    sha256 = GCC_SHA256,
    urls = ["https://ftp.gnu.org/gnu/gcc/gcc-{v}/gcc-{v}.tar.xz".format(v = GCC_VERSION)],
)

# Linux Kernel
http_file(
    name = "linux_kernel_tarball",
    sha256 = LINUX_KERNEL_SHA256,
    urls = ["https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-{0}.tar.xz".format(LINUX_KERNEL_VERSION)],
)
