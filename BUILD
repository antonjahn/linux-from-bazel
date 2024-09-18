# BUILD
load("//:versions.bzl", "GLIBC_VERSION")

COMMON_SCRIPT = """
set -euo pipefail
set -x
START_DIR="$$PWD"
WORK_DIR="/tmp/sandbox"
export LFS="/tmp/lfs"
export LFS_TGT="$$(uname -m)-lfs-linux-gnu"
export PATH="$$LFS/tools/bin:$$PATH"
mkdir -p "$$LFS"
mkdir -p "$$WORK_DIR"

EXTRACTED_FILES="$$START_DIR/extracted_files.txt"

extract_dependency() {
    set +x
    tar -xvf "$$1" -C "$$LFS" | while read -r file; do
        # Handle absolute paths and remove leading '/'
        sanitized_file="$${file#*/}"
        echo "$$LFS/$$sanitized_file" >> "$$EXTRACTED_FILES"
    done
    set -x
}

cleanup_extracted_dependencies() {
    set +x
    while read -r file; do
        if [ -f "$$file" ]; then
            rm -f "$$file"
        elif [ -h "$$file" ]; then
            rm -f "$$file"
        fi
    done < "$$EXTRACTED_FILES"

    # Remove empty directories within LFS
    find "$$LFS" -type d -empty -delete
    set -x
}
"""

genrule(
    name = "build_binutils_pass1",
    srcs = ["@binutils_tarball//file"],
    outs = ["binutils_pass1_installed.tar"],
    cmd = """
        {common_script}

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
        tar --mtime='2023-01-01 00:00:00' -cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "build_gcc_pass1",
    srcs = [
        "@gcc_tarball//file",
        "binutils_pass1_installed.tar",
    ],
    outs = ["gcc_pass1_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)

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

        make -j"$$(nproc)"
        make install

        cd ..
        cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
            `dirname $$($$LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
        glibc_version = GLIBC_VERSION,
    ),
)

genrule(
    name = "install_linux_headers",
    srcs = [
        "@linux_kernel_tarball//file",
    ],
    outs = ["linux_headers_installed.tar"],
    cmd = """
        set -euo pipefail
        set -x
        START_DIR="$$PWD"
        export LFS="/tmp/lfs"
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
        tar cf "$@" -C "$$LFS" .
    """,
)

genrule(
    name = "build_glibc",
    srcs = [
        "@glibc_tarball//file",
        "@glibc_fsh_patch//file",
        "linux_headers_installed.tar",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
    ],
    outs = ["glibc_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location linux_headers_installed.tar)
        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)

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

        # Sanity check
        echo 'int main() {{ }}' | $$LFS_TGT-gcc -xc -
        readelf -l a.out | grep ld-linux

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "sanity_check_gcc",
    srcs = [
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["sanity_check_gcc.txt"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        echo 'int main() {{ }}' | $$LFS_TGT-gcc -xc -
        readelf -l a.out | grep ld-linux > "$@"
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "build_libstdcxx",
    srcs = [
        "@gcc_tarball//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["libstdcxx_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract GCC source
        mkdir -p gcc-build
        tar xf $(location @gcc_tarball//file) -C gcc-build --strip-components=1
        cd gcc-build

        mkdir -v build
        cd build
        ../libstdc++-v3/configure            \
            --host="$$LFS_TGT"               \
            --build=$$(../config.guess)      \
            --prefix="/usr"                  \
            --disable-multilib               \
            --disable-nls                    \
            --disable-libstdcxx-pch          \
            --with-gxx-include-dir=/tools/$$LFS_TGT/include/c++/14.2.0

        make -j"$$(nproc)"
        make DESTDIR="$$LFS" install

        # Remove the libtool archive files
        rm -v $$LFS/usr/lib/lib{{stdc++{{,exp,fs}},supc++}}.la

        # Sanity check
        echo '#include <iostream>\nint main(){{std::cout<<"Hello, World!";return 0;}}' | $$LFS_TGT-g++ -xc++ -
        readelf -l a.out | grep ld-linux

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "build_m4",
    srcs = [
        "@m4_tarball//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["m4_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract M4 source
        mkdir -p m4-build
        tar xf $(location @m4_tarball//file) -C m4-build --strip-components=1
        cd m4-build

        ./configure --prefix=/usr --host=$$LFS_TGT --build=$$(build-aux/config.guess)
        make -j"$$(nproc)"
        make DESTDIR="$$LFS" install

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "build_ncurses",
    srcs = [
        "@ncurses_tarball//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "libstdcxx_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["ncurses_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location libstdcxx_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract Ncurses source
        mkdir -p ncurses-build
        tar xf $(location @ncurses_tarball//file) -C ncurses-build --strip-components=1
        cd ncurses-build

        sed -i s/mawk// configure

        # Build the tic program
        mkdir build
        pushd build
            ../configure
            make -C include
            make -C progs tic
        popd

        ./configure --prefix=/usr        \
            --host=$$LFS_TGT             \
            --build=$$(./config.guess)   \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping
        make -j"$$(nproc)"
        make DESTDIR=$$LFS TIC_PATH=$$(pwd)/build/progs/tic install
        ln -sv libncursesw.so $$LFS/usr/lib/libncurses.so
        sed -e 's/^#if.*XOPEN.*$$/#if 1/' -i $$LFS/usr/include/curses.h
        
        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "sanity_check_gxx",
    srcs = [
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
        "libstdcxx_installed.tar",
    ],
    outs = ["sanity_check_gxx.txt"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)
        extract_dependency $(location libstdcxx_installed.tar)

        echo '#include <iostream>\nint main(){{std::cout<<"Hello, World!";return 0;}}' | $$LFS_TGT-g++ -xc++ -
        readelf -l a.out | grep ld-linux > "$@"
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "build_bash",
    srcs = [
        "@bash_tarball//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
        "libstdcxx_installed.tar",
        "ncurses_installed.tar",
    ],
    outs = ["bash_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)
        extract_dependency $(location libstdcxx_installed.tar)
        extract_dependency $(location ncurses_installed.tar)

        # Extract Bash source
        mkdir -p bash-build
        tar xf $(location @bash_tarball//file) -C bash-build --strip-components=1
        cd bash-build

        ./configure --prefix=/usr               \
            --build=$$(sh support/config.guess) \
            --host=$$LFS_TGT                    \
            --without-bash-malloc               \
            bash_cv_strtold_broken=no

        make -j"$$(nproc)"
        make DESTDIR=$$LFS install
        mkdir -pv $$LFS/bin
        ln -sv bash $$LFS/bin/sh

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "build_coreutils",
    srcs = [
        "@coreutils_tarball//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["coreutils_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract Coreutils source
        mkdir -p coreutils-build
        tar xf $(location @coreutils_tarball//file) -C coreutils-build --strip-components=1
        cd coreutils-build

        ./configure                             \
            --prefix=/usr                       \
            --host=$$LFS_TGT                    \
            --build=$$(build-aux/config.guess)  \
            --enable-install-program=hostname   \
            --enable-no-install-program=kill,uptime

        make -j"$$(nproc)"
        make DESTDIR=$$LFS install

        # Move programs to the final expected locations
        mv -v $$LFS/usr/bin/chroot              $$LFS/usr/sbin
        mkdir -pv $$LFS/usr/share/man/man8
        mv -v $$LFS/usr/share/man/man1/chroot.1 $$LFS/usr/share/man/man8/chroot.8
        sed -i 's/"1"/"8"/'                     $$LFS/usr/share/man/man8/chroot.8

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "build_diffutils",
    srcs = [
        "@diffutils_tarball//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["diffutils_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract Diffutils source
        mkdir -p diffutils-build
        tar xf $(location @diffutils_tarball//file) -C diffutils-build --strip-components=1
        cd diffutils-build

        ./configure --prefix=/usr --host=$$LFS_TGT --build=$$(build-aux/config.guess)
        make -j"$$(nproc)"
        make DESTDIR=$$LFS install

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "build_file",
    srcs = [
        "@file_tarball//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["file_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract File source
        mkdir -p file-build
        tar xf $(location @file_tarball//file) -C file-build --strip-components=1
        cd file-build

        mkdir build
        pushd build
            ../configure \
                --disable-bzlib      \
                --disable-libseccomp \
                --disable-xzlib      \
                --disable-zlib
        make
        popd

        ./configure --prefix=/usr --host=$$LFS_TGT --build=$$(./config.guess)
        make -j"$$(nproc)" FILE_COMPILE=$$(pwd)/build/src/file
        make DESTDIR=$$LFS install

        # Remove the libtool archive files
        rm -v $$LFS/usr/lib/libmagic.la

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "build_findutils",
    srcs = [
        "@findutils_tarball//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["findutils_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract Findutils source
        mkdir -p findutils-build
        tar xf $(location @findutils_tarball//file) -C findutils-build --strip-components=1
        cd findutils-build

        ./configure --prefix=/usr --host=$$LFS_TGT --build=$$(build-aux/config.guess) --localstatedir=/var/lib/locate
        make -j"$$(nproc)"
        make DESTDIR=$$LFS install

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "build_gawk",
    srcs = [
        "@gawk_tarball//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["gawk_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract Gawk source
        mkdir -p gawk-build
        tar xf $(location @gawk_tarball//file) -C gawk-build --strip-components=1
        cd gawk-build

        # Make sure unneeded files are not installed
        sed -i 's/extras//' Makefile.in

        ./configure --prefix=/usr --host=$$LFS_TGT --build=$$(build-aux/config.guess)
        make -j"$$(nproc)"
        make DESTDIR=$$LFS install

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)
