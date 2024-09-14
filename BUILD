# BUILD
load("//:versions.bzl", "GLIBC_VERSION")

genrule(
    name = "build_binutils_pass1",
    srcs = ["@binutils_tarball//file"],
    outs = ["binutils_pass1_installed.tar.gz"],
    cmd = """
      set -euo pipefail
      set -x
      START_DIR="$$PWD"
      export LFS="$$PWD/lfs"
      export LFS_TGT="$$(uname -m)-lfs-linux-gnu"
      export PATH="$$LFS/tools/bin:$$PATH"
      mkdir -p "$$LFS/tools"
      mkdir -p binutils-build
      tar xf $(location @binutils_tarball//file) -C binutils-build --strip-components=1
      cd binutils-build
      mkdir -v build
      cd build
      ../configure                   \
          --prefix="$$LFS/tools"     \
          --with-sysroot="$$LFS"     \
          --target="$$LFS_TGT"       \
          --disable-nls              \
          --disable-werror           \
          --enable-gprofng=no        \
          --enable-new-dtags         \
          --enable-default-hash-style=gnu
      make -j"$$(nproc)"
      make install
      cd "$$START_DIR"
      tar czf "$@" -C "$$LFS/tools" .
    """,
)

genrule(
    name = "build_gcc_pass1",
    srcs = [
        "@gcc_tarball//file",
        "binutils_pass1_installed.tar.gz",
    ],
    outs = ["gcc_pass1_installed.tar.gz"],
    cmd = """
        set -euo pipefail
        set -x
        START_DIR="$$PWD"
        export LFS="$$PWD/lfs"
        export LFS_TGT="$$(uname -m)-lfs-linux-gnu"
        export PATH="$$LFS/tools/bin:$$PATH"
        mkdir -p "$$LFS/tools"

        # Extract Binutils into $$LFS/tools
        tar xf $(location binutils_pass1_installed.tar.gz) -C "$$LFS/tools"

        mkdir -p gcc-build
        tar xf $(location @gcc_tarball//file) -C gcc-build --strip-components=1
        cd gcc-build

        case $$(uname -m) in
            x86_64)
                sed -e '/m64=/s/lib64/lib/' \
                    -i.orig gcc/config/i386/t-linux64
            ;;
        esac

        # Download prerequisites
        ./contrib/download_prerequisites

        mkdir -v build
        cd build
        ../configure                                       \
            --target="$$LFS_TGT"                           \
            --prefix="$$LFS/tools"                         \
            --with-glibc-version={glibc_version}           \
            --with-sysroot="$$LFS"                         \
            --with-newlib                                  \
            --without-headers                              \
            --enable-default-pie                           \
            --enable-default-ssp                           \
            --disable-nls                                  \
            --disable-shared                               \
            --disable-multilib                             \
            --disable-threads                              \
            --disable-libatomic                            \
            --disable-libgomp                              \
            --disable-libquadmath                          \
            --disable-libssp                               \
            --disable-libvtv                               \
            --disable-libstdcxx                            \
            --enable-languages=c,c++

        make -j"$$(nproc)" all-gcc
        make -j"$$(nproc)" all-target-libgcc
        make install-gcc
        make install-target-libgcc

        cd "$$START_DIR"
        tar czf "$@" -C "$$LFS/tools" .
    """.format(
        glibc_version = GLIBC_VERSION,
    ),
)

genrule(
    name = "install_linux_headers",
    srcs = [
        "@linux_kernel_tarball//file",
    ],
    outs = ["linux_headers_installed.tar.gz"],
    cmd = """
        set -euo pipefail
        set -x
        START_DIR="$$PWD"
        export LFS="$$PWD/lfs"
        export LFS_TGT="$$(uname -m)-lfs-linux-gnu"
        export PATH="$$LFS/tools/bin:$$PATH"
        mkdir -p "$$LFS"

        # Extract Linux kernel source
        mkdir -p linux-headers-build
        tar xf $(location @linux_kernel_tarball//file) -C linux-headers-build --strip-components=1
        cd linux-headers-build

        make mrproper
        make headers
        find usr/include -name '.*' -delete
        rm usr/include/Makefile
        mkdir -p "$$LFS/usr"
        cp -rv usr/include "$$LFS/usr"

        cd "$$START_DIR"
        tar czf "$@" -C "$$LFS" .
    """,
)
