# WORKSPACE

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load(
    "//:versions.bzl",
    "BASH_SHA256",
    "BASH_VERSION",
    "BINUTILS_SHA256",
    "BINUTILS_VERSION",
    "BISON_SHA256",
    "BISON_VERSION",
    "COREUTILS_SHA256",
    "COREUTILS_VERSION",
    "DIFFUTILS_SHA256",
    "DIFFUTILS_VERSION",
    "FILE_SHA256",
    "FILE_VERSION",
    "FINDUTILS_SHA256",
    "FINDUTILS_VERSION",
    "GAWK_SHA256",
    "GAWK_VERSION",
    "GCC_SHA256",
    "GCC_VERSION",
    "GETTEXT_SHA256",
    "GETTEXT_VERSION",
    "GLIBC_SHA256",
    "GLIBC_VERSION",
    "GREP_SHA256",
    "GREP_VERSION",
    "GZIP_SHA256",
    "GZIP_VERSION",
    "LINUX_KERNEL_SHA256",
    "LINUX_KERNEL_VERSION",
    "M4_SHA256",
    "M4_VERSION",
    "MAKE_SHA256",
    "MAKE_VERSION",
    "MAN_PAGES_SHA256",
    "MAN_PAGES_VERSION",
    "NCURSES_SHA256",
    "NCURSES_VERSION",
    "PATCH_SHA256",
    "PATCH_VERSION",
    "PERL_SHA256",
    "PERL_VERSION",
    "PYTHON_SHA256",
    "PYTHON_VERSION",
    "SED_SHA256",
    "SED_VERSION",
    "TAR_SHA256",
    "TAR_VERSION",
    "TEXINFO_SHA256",
    "TEXINFO_VERSION",
    "UTIL_LINUX_SHA256",
    "UTIL_LINUX_VERSION",
    "XZ_SHA256",
    "XZ_VERSION",
)

http_file(
    name = "binutils_src.tar",
    sha256 = BINUTILS_SHA256,
    urls = ["https://sourceware.org/pub/binutils/releases/binutils-{}.tar.xz".format(BINUTILS_VERSION)],
)

http_file(
    name = "gcc_src.tar",
    sha256 = GCC_SHA256,
    urls = ["https://ftp.gnu.org/gnu/gcc/gcc-{0}/gcc-{0}.tar.xz".format(GCC_VERSION)],
)

http_file(
    name = "linux_kernel_src.tar",
    sha256 = LINUX_KERNEL_SHA256,
    urls = ["https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-{0}.tar.xz".format(LINUX_KERNEL_VERSION)],
)

http_file(
    name = "glibc_src.tar",
    sha256 = GLIBC_SHA256,
    urls = ["https://ftp.gnu.org/gnu/glibc/glibc-{}.tar.xz".format(GLIBC_VERSION)],
)

http_file(
    name = "glibc_fsh_patch",
    sha256 = "643552db030e2f2d7ffde4f558e0f5f83d3fabf34a2e0e56ebdb49750ac27b0d",
    urls = ["https://www.linuxfromscratch.org/patches/lfs/12.2/glibc-2.40-fhs-1.patch"],
)

http_file(
    name = "m4_src.tar",
    sha256 = M4_SHA256,
    urls = ["https://ftp.gnu.org/gnu/m4/m4-{}.tar.xz".format(M4_VERSION)],
)

http_file(
    name = "ncurses_src.tar",
    sha256 = NCURSES_SHA256,
    urls = ["https://ftp.gnu.org/gnu/ncurses/ncurses-{}.tar.gz".format(NCURSES_VERSION)],
)

http_file(
    name = "bash_src.tar",
    sha256 = BASH_SHA256,
    urls = ["https://ftp.gnu.org/gnu/bash/bash-{}.tar.gz".format(BASH_VERSION)],
)

http_file(
    name = "coreutils_src.tar",
    sha256 = COREUTILS_SHA256,
    urls = ["https://ftp.gnu.org/gnu/coreutils/coreutils-{}.tar.xz".format(COREUTILS_VERSION)],
)

http_file(
    name = "diffutils_src.tar",
    sha256 = DIFFUTILS_SHA256,
    urls = ["https://ftp.gnu.org/gnu/diffutils/diffutils-{}.tar.xz".format(DIFFUTILS_VERSION)],
)

http_file(
    name = "file_src.tar",
    sha256 = FILE_SHA256,
    urls = ["https://astron.com/pub/file/file-{}.tar.gz".format(FILE_VERSION)],
)

http_file(
    name = "findutils_src.tar",
    sha256 = FINDUTILS_SHA256,
    urls = ["https://ftp.gnu.org/gnu/findutils/findutils-{}.tar.xz".format(FINDUTILS_VERSION)],
)

http_file(
    name = "gawk_src.tar",
    sha256 = GAWK_SHA256,
    urls = ["https://ftp.gnu.org/gnu/gawk/gawk-{}.tar.xz".format(GAWK_VERSION)],
)

http_file(
    name = "grep_src.tar",
    sha256 = GREP_SHA256,
    urls = ["https://ftp.gnu.org/gnu/grep/grep-{}.tar.xz".format(GREP_VERSION)],
)

http_file(
    name = "gzip_src.tar",
    sha256 = GZIP_SHA256,
    urls = ["https://ftp.gnu.org/gnu/gzip/gzip-{}.tar.xz".format(GZIP_VERSION)],
)

http_file(
    name = "make_src.tar",
    sha256 = MAKE_SHA256,
    urls = ["https://ftp.gnu.org/gnu/make/make-{}.tar.gz".format(MAKE_VERSION)],
)

http_file(
    name = "patch_src.tar",
    sha256 = PATCH_SHA256,
    urls = ["https://ftp.gnu.org/gnu/patch/patch-{}.tar.xz".format(PATCH_VERSION)],
)

http_file(
    name = "sed_src.tar",
    sha256 = SED_SHA256,
    urls = ["https://ftp.gnu.org/gnu/sed/sed-{}.tar.xz".format(SED_VERSION)],
)

http_file(
    name = "tar_src.tar",
    sha256 = TAR_SHA256,
    urls = ["https://ftp.gnu.org/gnu/tar/tar-{}.tar.xz".format(TAR_VERSION)],
)

http_file(
    name = "xz_src.tar",
    sha256 = XZ_SHA256,
    urls = ["https://github.com//tukaani-project/xz/releases/download/v{0}/xz-{0}.tar.xz".format(XZ_VERSION)],
)

http_file(
    name = "gettext_src.tar",
    sha256 = GETTEXT_SHA256,
    urls = ["https://ftp.gnu.org/gnu/gettext/gettext-{}.tar.xz".format(GETTEXT_VERSION)],
)

http_file(
    name = "bison_src.tar",
    sha256 = BISON_SHA256,
    urls = ["https://ftp.gnu.org/gnu/bison/bison-{}.tar.xz".format(BISON_VERSION)],
)

http_file(
    name = "perl_src.tar",
    sha256 = PERL_SHA256,
    urls = ["https://www.cpan.org/src/5.0/perl-{}.tar.xz".format(PERL_VERSION)],
)

http_file(
    name = "python_src.tar",
    sha256 = PYTHON_SHA256,
    urls = ["https://www.python.org/ftp/python/{0}/Python-{0}.tar.xz".format(PYTHON_VERSION)],
)

http_file(
    name = "texinfo_src.tar",
    sha256 = TEXINFO_SHA256,
    urls = ["https://ftp.gnu.org/gnu/texinfo/texinfo-{}.tar.xz".format(TEXINFO_VERSION)],
)

http_file(
    name = "util_linux_src.tar",
    sha256 = UTIL_LINUX_SHA256,
    # Example url: https://www.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.2.tar.xz
    urls = [
        "https://www.kernel.org/pub/linux/utils/util-linux/v{0}/util-linux-{1}.tar.xz".format(
            UTIL_LINUX_VERSION.rsplit(".", 1)[0],
            UTIL_LINUX_VERSION,
        ),
    ],
)

http_file(
    name = "man_pages_src.tar",
    sha256 = MAN_PAGES_SHA256,
    urls = ["https://www.kernel.org/pub/linux/docs/man-pages/man-pages-{}.tar.xz".format(MAN_PAGES_VERSION)],
)
