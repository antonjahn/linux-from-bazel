"""Loads external dependencies needed for the LFS build."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

BINUTILS_VERSION = "2.43.1"
BINUTILS_SHA256 = "13f74202a3c4c51118b797a39ea4200d3f6cfbe224da6d1d95bb938480132dfd"

GCC_VERSION = "14.2.0"
GCC_SHA256 = "a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9"

GLIBC_VERSION = "2.40"
GLIBC_SHA256 = "19a890175e9263d748f627993de6f4b1af9cd21e03f080e4bfb3a1fac10205a2"

LINUX_KERNEL_VERSION = "6.10.5"
LINUX_KERNEL_SHA256 = "30909eb2e0434dce97a93cd97ed0dfab7688a124bc3ebc3ecf6c776de09ccc0b"

M4_VERSION = "1.4.19"
M4_SHA256 = "63aede5c6d33b6d9b13511cd0be2cac046f2e70fd0a07aa9573a04a82783af96"

NCURSES_VERSION = "6.5"
NCURSES_SHA256 = "136d91bc269a9a5785e5f9e980bc76ab57428f604ce3e5a5a90cebc767971cc6"

BASH_VERSION = "5.2.32"
BASH_SHA256 = "d3ef80d2b67d8cbbe4d3265c63a72c46f9b278ead6e0e06d61801b58f23f50b5"

COREUTILS_VERSION = "9.5"
COREUTILS_SHA256 = "cd328edeac92f6a665de9f323c93b712af1858bc2e0d88f3f7100469470a1b8a"

DIFFUTILS_VERSION = "3.10"
DIFFUTILS_SHA256 = "90e5e93cc724e4ebe12ede80df1634063c7a855692685919bfe60b556c9bd09e"

FILE_VERSION = "5.45"
FILE_SHA256 = "fc97f51029bb0e2c9f4e3bffefdaf678f0e039ee872b9de5c002a6d09c784d82"

FINDUTILS_VERSION = "4.10.0"
FINDUTILS_SHA256 = "1387e0b67ff247d2abde998f90dfbf70c1491391a59ddfecb8ae698789f0a4f5"

GAWK_VERSION = "5.3.0"
GAWK_SHA256 = "ca9c16d3d11d0ff8c69d79dc0b47267e1329a69b39b799895604ed447d3ca90b"

GREP_VERSION = "3.11"
GREP_SHA256 = "1db2aedde89d0dea42b16d9528f894c8d15dae4e190b59aecc78f5a951276eab"

GZIP_VERSION = "1.13"
GZIP_SHA256 = "7454eb6935db17c6655576c2e1b0fabefd38b4d0936e0f87f48cd062ce91a057"

MAKE_VERSION = "4.4.1"
MAKE_SHA256 = "dd16fb1d67bfab79a72f5e8390735c49e3e8e70b4945a15ab1f81ddb78658fb3"

PATCH_VERSION = "2.7.6"
PATCH_SHA256 = "ac610bda97abe0d9f6b7c963255a11dcb196c25e337c61f94e4778d632f1d8fd"

SED_VERSION = "4.9"
SED_SHA256 = "6e226b732e1cd739464ad6862bd1a1aba42d7982922da7a53519631d24975181"

TAR_VERSION = "1.35"
TAR_SHA256 = "4d62ff37342ec7aed748535323930c7cf94acf71c3591882b26a7ea50f3edc16"

XZ_VERSION = "5.6.2"
XZ_SHA256 = "a9db3bb3d64e248a0fae963f8fb6ba851a26ba1822e504dc0efd18a80c626caf"

GETTEXT_VERSION = "0.22.5"
GETTEXT_SHA256 = "fe10c37353213d78a5b83d48af231e005c4da84db5ce88037d88355938259640"

BISON_VERSION = "3.8.2"
BISON_SHA256 = "9bba0214ccf7f1079c5d59210045227bcf619519840ebfa80cd3849cff5a5bf2"

PERL_VERSION = "5.40.0"
PERL_SHA256 = "d5325300ad267624cb0b7d512cfdfcd74fa7fe00c455c5b51a6bd53e5e199ef9"

PYTHON_VERSION = "3.12.5"
PYTHON_SHA256 = "fa8a2e12c5e620b09f53e65bcd87550d2e5a1e2e04bf8ba991dcc55113876397"

TEXINFO_VERSION = "7.1"
TEXINFO_SHA256 = "deeec9f19f159e046fdf8ad22231981806dac332cc372f1c763504ad82b30953"

UTIL_LINUX_VERSION = "2.40.2"
UTIL_LINUX_SHA256 = "d78b37a66f5922d70edf3bdfb01a6b33d34ed3c3cafd6628203b2a2b67c8e8b3"

MAN_PAGES_VERSION = "6.9.1"
MAN_PAGES_SHA256 = "e23cbac29f110ba571f0da8523e79d373691466ed7f2a31301721817d34530bd"

IANA_ETC_VERSION = "20240806"
IANA_ETC_SHA256 = "672dbe1ba52b889a46dc07ee3876664ed601983239f82d729d02a002475a5b66"

ZLIB_VERSION = "1.3.1"
ZLIB_SHA256 = "9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23"

BZIP2_VERSION = "1.0.8"
BZIP2_SHA256 = "ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269"

LZ4_VERSION = "1.10.0"
LZ4_SHA256 = "537512904744b35e232912055ccf8ec66d768639ff3abe5788d90d792ec5f48b"

ZSTD_VERSION = "1.5.6"
ZSTD_SHA256 = "8c29e06cf42aacc1eafc4077ae2ec6c6fcb96a626157e0593d5e82a34fd403c1"

READLINE_VERSION = "8.2.13"
READLINE_SHA256 = "0e5be4d2937e8bd9b7cd60d46721ce79f88a33415dd68c2d738fb5924638f656"

BC_VERSION = "6.7.6"
BC_SHA256 = "828f390c2a552cadbc8c8ad5fde6eeaee398dc8d59d706559158330f3629ce35"

FLEX_VERSION = "2.6.4"
FLEX_SHA256 = "e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995"

TCL_VERSION = "8.6.14"
TCL_SHA256 = "5880225babf7954c58d4fb0f5cf6279104ce1cd6aa9b71e9a6322540e1c4de66"

EXPECT_VERSION = "5.45.4"
EXPECT_SHA256 = "49a7da83b0bdd9f46d04a04deec19c7767bb9a323e40c4781f89caf760b92c34"

DEJAGNU_VERSION = "1.6.3"
DEJAGNU_SHA256 = "87daefacd7958b4a69f88c6856dbd1634261963c414079d0c371f589cd66a2e3"

PKGCONF_VERSION = "2.3.0"
PKGCONF_SHA256 = "3a9080ac51d03615e7c1910a0a2a8df08424892b5f13b0628a204d3fcce0ea8b"

GMP_VERSION = "6.3.0"
GMP_SHA256 = "a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898"

MPFR_VERSION = "4.2.1"
MPFR_SHA256 = "277807353a6726978996945af13e52829e3abd7a9a5b7fb2793894e18f1fcbb2"

MPC_VERSION = "1.3.1"
MPC_SHA256 = "ab642492f5cf882b74aa0cb730cd410a81edcdbec895183ce930e706c1c759b8"

ATTR_VERSION = "2.5.2"
ATTR_SHA256 = "39bf67452fa41d0948c2197601053f48b3d78a029389734332a6309a680c6c87"

ACL_VERSION = "2.3.2"
ACL_SHA256 = "97203a72cae99ab89a067fe2210c1cbf052bc492b479eca7d226d9830883b0bd"

LIBCAP_VERSION = "2.70"
LIBCAP_SHA256 = "23a6ef8aadaf1e3e875f633bb2d116cfef8952dba7bc7c569b13458e1952b30f"

LIBXCRYPT_VERSION = "4.4.36"
LIBXCRYPT_SHA256 = "e5e1f4caee0a01de2aee26e3138807d6d3ca2b8e67287966d1fefd65e1fd8943"

SHADOW_VERSION = "4.16.0"
SHADOW_SHA256 = "b78e3921a95d53282a38e90628880624736bf6235e36eea50c50835f59a3530b"

PSMISC_VERSION = "23.7"
PSMISC_SHA256 = "58c55d9c1402474065adae669511c191de374b0871eec781239ab400b907c327"

LIBTOOL_VERSION = "2.4.7"
LIBTOOL_SHA256 = "4f7f217f057ce655ff22559ad221a0fd8ef84ad1fc5fcb6990cecc333aa1635d"

GDBM_VERSION = "1.24"
GDBM_SHA256 = "695e9827fdf763513f133910bc7e6cfdb9187943a4fec943e57449723d2b8dbf"

GPERF_VERSION = "3.1"
GPERF_SHA256 = "588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2"

EXPAT_VERSION = "2.6.2"
EXPAT_SHA256 = "ee14b4c5d8908b1bec37ad937607eab183d4d9806a08adee472c3c3121d27364"

INETUTILS_VERSION = "2.5"
INETUTILS_SHA256 = "87697d60a31e10b5cb86a9f0651e1ec7bee98320d048c0739431aac3d5764fb6"

LESS_VERSION = "661"
LESS_SHA256 = "2b5f0167216e3ef0ffcb0c31c374e287eb035e4e223d5dae315c2783b6e738ed"

XML_PARSER_VERSION = "2.47"
XML_PARSER_SHA256 = "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"

def _fetch_lfs_sources_impl(_ctx):
    """Implementation function for the fetch_lfs_sources module extension."""
    http_file(
        name = "binutils_src.tar",
        sha256 = BINUTILS_SHA256,
        urls = [
            "https://sourceware.org/pub/binutils/releases/binutils-{}.tar.xz".format(BINUTILS_VERSION),
            "https://ftp.gnu.org/gnu/binutils/binutils-{}.tar.xz".format(BINUTILS_VERSION),
        ],
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

    http_file(
        name = "iana_etc_src.tar",
        sha256 = IANA_ETC_SHA256,
        urls = ["https://github.com/Mic92/iana-etc/releases/download/{0}/iana-etc-{0}.tar.gz".format(IANA_ETC_VERSION)],
    )

    http_file(
        name = "zlib_src.tar",
        sha256 = ZLIB_SHA256,
        urls = ["https://zlib.net/fossils/zlib-{}.tar.gz".format(ZLIB_VERSION)],
    )

    http_file(
        name = "bzip2_src.tar",
        sha256 = BZIP2_SHA256,
        urls = ["https://sourceware.org/pub/bzip2/bzip2-{}.tar.gz".format(BZIP2_VERSION)],
    )

    http_file(
        name = "lz4_src.tar",
        sha256 = LZ4_SHA256,
        urls = ["https://github.com/lz4/lz4/releases/download/v{0}/lz4-{0}.tar.gz".format(LZ4_VERSION)],
    )

    http_file(
        name = "zstd_src.tar",
        sha256 = ZSTD_SHA256,
        urls = ["https://github.com/facebook/zstd/releases/download/v{0}/zstd-{0}.tar.gz".format(ZSTD_VERSION)],
    )

    http_file(
        name = "readline_src.tar",
        sha256 = READLINE_SHA256,
        urls = ["https://ftp.gnu.org/gnu/readline/readline-{}.tar.gz".format(READLINE_VERSION)],
    )

    http_file(
        name = "bc_src.tar",
        sha256 = BC_SHA256,
        urls = ["https://github.com/gavinhoward/bc/releases/download/{0}/bc-{0}.tar.xz".format(BC_VERSION)],
    )

    http_file(
        name = "flex_src.tar",
        sha256 = FLEX_SHA256,
        urls = ["https://github.com/westes/flex/releases/download/v{0}/flex-{0}.tar.gz".format(FLEX_VERSION)],
    )

    http_file(
        name = "tcl_src.tar",
        sha256 = TCL_SHA256,
        urls = ["https://prdownloads.sourceforge.net/tcl/tcl{0}-src.tar.gz".format(TCL_VERSION)],
    )

    http_file(
        name = "expect_src.tar",
        sha256 = EXPECT_SHA256,
        urls = ["https://prdownloads.sourceforge.net/expect/expect{0}.tar.gz".format(EXPECT_VERSION)],
    )

    http_file(
        name = "expect_gcc14_patch",
        sha256 = "517c0cdd5db949cdd99dfa38b7a6c3945e1524c50e3467028973298f2c76a92c",
        urls = ["https://www.linuxfromscratch.org/patches/lfs/12.2/expect-5.45.4-gcc14-1.patch"],
    )

    http_file(
        name = "dejagnu_src.tar",
        sha256 = DEJAGNU_SHA256,
        urls = ["https://ftp.gnu.org/gnu/dejagnu/dejagnu-{}.tar.gz".format(DEJAGNU_VERSION)],
    )

    http_file(
        name = "pkgconf_src.tar",
        sha256 = PKGCONF_SHA256,
        urls = ["https://distfiles.ariadne.space/pkgconf/pkgconf-{0}.tar.xz".format(PKGCONF_VERSION)],
    )

    http_file(
        name = "gmp_src.tar",
        sha256 = GMP_SHA256,
        urls = ["https://ftp.gnu.org/gnu/gmp/gmp-{0}.tar.xz".format(GMP_VERSION)],
    )

    http_file(
        name = "mpfr_src.tar",
        sha256 = MPFR_SHA256,
        urls = ["https://ftp.gnu.org/gnu/mpfr/mpfr-{0}.tar.xz".format(MPFR_VERSION)],
    )

    http_file(
        name = "mpc_src.tar",
        sha256 = MPC_SHA256,
        urls = ["https://ftp.gnu.org/gnu/mpc/mpc-{0}.tar.gz".format(MPC_VERSION)],
    )

    http_file(
        name = "attr_src.tar",
        sha256 = ATTR_SHA256,
        urls = ["https://download.savannah.gnu.org/releases/attr/attr-{0}.tar.gz".format(ATTR_VERSION)],
    )

    http_file(
        name = "acl_src.tar",
        sha256 = ACL_SHA256,
        urls = ["https://download.savannah.gnu.org/releases/acl/acl-{0}.tar.xz".format(ACL_VERSION)],
    )

    http_file(
        name = "libcap_src.tar",
        sha256 = LIBCAP_SHA256,
        urls = ["https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-{0}.tar.xz".format(LIBCAP_VERSION)],
    )

    http_file(
        name = "libxcrypt_src.tar",
        sha256 = LIBXCRYPT_SHA256,
        urls = ["https://github.com/besser82/libxcrypt/releases/download/v{0}/libxcrypt-{0}.tar.xz".format(LIBXCRYPT_VERSION)],
    )

    http_file(
        name = "shadow_src.tar",
        sha256 = SHADOW_SHA256,
        urls = ["https://github.com/shadow-maint/shadow/releases/download/{0}/shadow-{0}.tar.xz".format(SHADOW_VERSION)],
    )

    http_file(
        name = "psmisc_src.tar",
        sha256 = PSMISC_SHA256,
        urls = ["https://prdownloads.sourceforge.net/psmisc/psmisc-{0}.tar.xz".format(PSMISC_VERSION)],
    )

    http_file(
        name = "libtool_src.tar",
        sha256 = LIBTOOL_SHA256,
        urls = ["https://ftp.gnu.org/gnu/libtool/libtool-{0}.tar.xz".format(LIBTOOL_VERSION)],
    )

    http_file(
        name = "gdbm_src.tar",
        sha256 = GDBM_SHA256,
        urls = ["https://ftp.gnu.org/gnu/gdbm/gdbm-{0}.tar.gz".format(GDBM_VERSION)],
    )

    http_file(
        name = "gperf_src.tar",
        sha256 = GPERF_SHA256,
        urls = ["https://ftp.gnu.org/gnu/gperf/gperf-{0}.tar.gz".format(GPERF_VERSION)],
    )

    http_file(
        name = "expat_src.tar",
        sha256 = EXPAT_SHA256,
        urls = [
            "https://prdownloads.sourceforge.net/expat/expat-{0}.tar.xz".format(EXPAT_VERSION),
            "https://github.com/libexpat/libexpat/releases/download/R_{1}/expat-{0}.tar.xz".format(
                EXPAT_VERSION,
                EXPAT_VERSION.replace(".", "_"),
            ),
        ],
    )

    http_file(
        name = "inetutils_src.tar",
        sha256 = INETUTILS_SHA256,
        urls = ["https://ftp.gnu.org/gnu/inetutils/inetutils-{}.tar.xz".format(INETUTILS_VERSION)],
    )

    http_file(
        name = "less_src.tar",
        sha256 = LESS_SHA256,
        urls = ["https://www.greenwoodsoftware.com/less/less-{}.tar.gz".format(LESS_VERSION)],
    )

    http_file(
        name = "xml_parser_src.tar",
        sha256 = XML_PARSER_SHA256,
        urls = [
            "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-{}.tar.gz".format(XML_PARSER_VERSION),
        ],
    )

fetch_lfs_sources = module_extension(
    implementation = _fetch_lfs_sources_impl,
    doc = "Fetches all source archives required for the LFS build.",
)
