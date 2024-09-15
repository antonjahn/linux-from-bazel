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

genrule(
    name = "build_glibc",
    srcs = [
        "@glibc_tarball//file",
        "@glibc_fsh_patch//file",
        "linux_headers_installed.tar.gz",
        "binutils_pass1_installed.tar.gz",
        "gcc_pass1_installed.tar.gz",
    ],
    outs = ["glibc_installed.tar.gz"],
    cmd = """
        set -euo pipefail
        set -x
        START_DIR="$$PWD"
        export LFS="$$PWD/lfs"
        export LFS_TGT="$$(uname -m)-lfs-linux-gnu"
        export PATH="$$LFS/tools/bin:$$PATH"
        mkdir -p "$$LFS/tools"

        # Extract dependencies
        tar xf $(location linux_headers_installed.tar.gz) -C "$$LFS"
        tar xf $(location binutils_pass1_installed.tar.gz) -C "$$LFS/tools"
        tar xf $(location gcc_pass1_installed.tar.gz) -C "$$LFS/tools"

        case $$(uname -m) in
            i?86)   ln -sfv ld-linux.so.2 $$LFS/lib/ld-lsb.so.3
            ;;
            x86_64) mkdir -p $$LFS/lib64
                    ln -sfv ../lib/ld-linux-x86-64.so.2 $$LFS/lib64
                    ln -sfv ../lib/ld-linux-x86-64.so.2 $$LFS/lib64/ld-lsb-x86-64.so.3
            ;;
        esac

        # Extract Glibc source
        mkdir -p glibc-build
        tar xf $(location @glibc_tarball//file) -C glibc-build --strip-components=1
        cd glibc-build

        # Apply patch
        patch -Np1 -i ../$(location @glibc_fsh_patch//file)

        mkdir -v build
        cd build
        echo "rootsbindir=/usr/sbin" > configparms
        ../configure                             \
            --prefix="/usr"                      \
            --host="$$LFS_TGT"                   \
            --build="$$(../scripts/config.guess)"\
            --enable-kernel=4.19                 \
            --with-headers="$$LFS/usr/include"   \
            --disable-nscd                       \
            libc_cv_slibdir=/usr/lib

        make -j"$$(nproc)"
        make DESTDIR="$$LFS" install

        # Fix hard coded path to executable loader in the ldd script
        sed '/RTLDLIST=/s@/usr@@g' -i $$LFS/usr/bin/ldd

        cd "$$START_DIR"
        tar czf "$@" -C "$$LFS" .
    """,
)
