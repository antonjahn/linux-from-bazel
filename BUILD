load("//:versions.bzl", "BISON_VERSION", "GLIBC_VERSION", "PERL_VERSION", "UTIL_LINUX_VERSION")

# Setup environment and provide "package-manager" functions
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
    srcs = ["@binutils_src.tar//file"],
    outs = ["binutils_pass1_installed.tar"],
    cmd = """
        {common_script}

        mkdir -p binutils-build
        tar xf $(location @binutils_src.tar//file) -C binutils-build --strip-components=1
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
        "@gcc_src.tar//file",
        "binutils_pass1_installed.tar",
    ],
    outs = ["gcc_pass1_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)

        mkdir -p gcc-build
        tar xf $(location @gcc_src.tar//file) -C gcc-build --strip-components=1
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
    name = "build_linux_headers",
    srcs = [
        "@linux_kernel_src.tar//file",
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
        tar xf $(location @linux_kernel_src.tar//file) -C linux-headers-build --strip-components=1
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
        "@glibc_src.tar//file",
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
            x86_64) mkdir -p $$LFS/lib64 $$LFS/lib
                    ln -sfv ../lib/ld-linux-x86-64.so.2 $$LFS/lib64
                    ln -sfv ../lib/ld-linux-x86-64.so.2 $$LFS/lib64/ld-lsb-x86-64.so.3
                    ln -sfv ../usr/lib/ld-linux-x86-64.so.2 $$LFS/lib
            ;;
        esac

        # Extract Glibc source
        mkdir -p glibc-build
        tar xf $(location @glibc_src.tar//file) -C glibc-build --strip-components=1
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

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "build_sanity_check_gcc_pass1",
    srcs = [
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["sanity_check_gcc_pass1.txt"],
    cmd = COMMON_SCRIPT + """
        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        echo 'int main() { }' | $$LFS_TGT-gcc -xc -
        readelf -l a.out | grep ld-linux > "$@"
    """,
)

genrule(
    name = "build_libstdcxx",
    srcs = [
        "@gcc_src.tar//file",
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
        tar xf $(location @gcc_src.tar//file) -C gcc-build --strip-components=1
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
        "@m4_src.tar//file",
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
        tar xf $(location @m4_src.tar//file) -C m4-build --strip-components=1
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
        "@ncurses_src.tar//file",
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
        tar xf $(location @ncurses_src.tar//file) -C ncurses-build --strip-components=1
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
    name = "build_sanity_check_gxx_pass1",
    srcs = [
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
        "libstdcxx_installed.tar",
    ],
    outs = ["sanity_check_gxx_pass1.txt"],
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
        "@bash_src.tar//file",
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
        tar xf $(location @bash_src.tar//file) -C bash-build --strip-components=1
        cd bash-build

        ./configure --prefix=/usr               \
            --build=$$(sh support/config.guess) \
            --host=$$LFS_TGT                    \
            --without-bash-malloc               \
            bash_cv_strtold_broken=no

        make -j"$$(nproc)"
        make DESTDIR=$$LFS install
        mkdir -pv $$LFS/bin
        ln -sv /usr/bin/bash $$LFS/bin/sh
        ln -sv /usr/bin/bash $$LFS/bin/bash

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
        "@coreutils_src.tar//file",
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
        tar xf $(location @coreutils_src.tar//file) -C coreutils-build --strip-components=1
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
        "@diffutils_src.tar//file",
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
        tar xf $(location @diffutils_src.tar//file) -C diffutils-build --strip-components=1
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
        "@file_src.tar//file",
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
        tar xf $(location @file_src.tar//file) -C file-build --strip-components=1
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
        "@findutils_src.tar//file",
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
        tar xf $(location @findutils_src.tar//file) -C findutils-build --strip-components=1
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
        "@gawk_src.tar//file",
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
        tar xf $(location @gawk_src.tar//file) -C gawk-build --strip-components=1
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

genrule(
    name = "build_grep",
    srcs = [
        "@grep_src.tar//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["grep_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract Grep source
        mkdir -p grep-build
        tar xf $(location @grep_src.tar//file) -C grep-build --strip-components=1
        cd grep-build

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
    name = "build_gzip",
    srcs = [
        "@gzip_src.tar//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["gzip_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract Gzip source
        mkdir -p gzip-build
        tar xf $(location @gzip_src.tar//file) -C gzip-build --strip-components=1
        cd gzip-build

        ./configure --prefix=/usr --host=$$LFS_TGT
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
    name = "build_make",
    srcs = [
        "@make_src.tar//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["make_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract Make source
        mkdir -p make-build
        tar xf $(location @make_src.tar//file) -C make-build --strip-components=1
        cd make-build

        ./configure --prefix=/usr --host=$$LFS_TGT --build=$$(build-aux/config.guess) \
            --without-guile
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
    name = "build_patch",
    srcs = [
        "@patch_src.tar//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["patch_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract Patch source
        mkdir -p patch-build
        tar xf $(location @patch_src.tar//file) -C patch-build --strip-components=1
        cd patch-build

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
    name = "build_sed",
    srcs = [
        "@sed_src.tar//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["sed_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract Sed source
        mkdir -p sed-build
        tar xf $(location @sed_src.tar//file) -C sed-build --strip-components=1
        cd sed-build

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
    name = "build_tar",
    srcs = [
        "@tar_src.tar//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["tar_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract Tar source
        mkdir -p tar-build
        tar xf $(location @tar_src.tar//file) -C tar-build --strip-components=1
        cd tar-build

        ./configure --prefix=/usr \
                    --host=$$LFS_TGT \
                    --build=$$(build-aux/config.guess)
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
    name = "build_xz",
    srcs = [
        "@xz_src.tar//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["xz_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract Xz source
        mkdir -p xz-build
        tar xf $(location @xz_src.tar//file) -C xz-build --strip-components=1
        cd xz-build

        ./configure --prefix=/usr --host=$$LFS_TGT --build=$$(build-aux/config.guess) --disable-static --docdir=/usr/share/doc/xz-5.6.2
        make -j"$$(nproc)"
        make DESTDIR=$$LFS install

        # Remove the libtool archive files
        rm -v $$LFS/usr/lib/liblzma.la

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "build_binutils_pass2",
    srcs = [
        "@binutils_src.tar//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
    ],
    outs = ["binutils_pass2_installed.tar"],
    cmd = """
        {common_script}

        extract_dependency $(location binutils_pass1_installed.tar)
        extract_dependency $(location gcc_pass1_installed.tar)
        extract_dependency $(location glibc_installed.tar)
        extract_dependency $(location linux_headers_installed.tar)

        # Extract Binutils source
        mkdir -p binutils-build
        tar xf $(location @binutils_src.tar//file) -C binutils-build --strip-components=1
        cd binutils-build

        mkdir -v build
        cd build
        ../configure                   \
            --prefix=/usr              \
            --build=$$(../config.guess)\
            --host=$$LFS_TGT           \
            --disable-nls              \
            --enable-shared            \
            --enable-gprofng=no        \
            --disable-werror           \
            --enable-64-bit-bfd        \
            --enable-new-dtags         \
            --enable-default-hash-style=gnu

        make -j"$$(nproc)"
        make DESTDIR=$$LFS install

        # Remove the libtool archive files
        rm -v $$LFS/usr/lib/lib{{bfd,ctf,ctf-nobfd,opcodes,sframe}}.{{a,la}}

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        common_script = COMMON_SCRIPT,
    ),
)

genrule(
    name = "build_gcc_pass2",
    srcs = [
        "@gcc_src.tar//file",
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "glibc_installed.tar",
        "linux_headers_installed.tar",
        "libstdcxx_installed.tar",
    ],
    outs = ["gcc_pass2_installed.tar"],
    cmd = COMMON_SCRIPT + """
        for dep in $(SRCS); do
            if [[ "$$dep" == *_installed.tar ]]; then
                extract_dependency "$$dep"
            fi
        done

        # Extract GCC source
        mkdir -p gcc-build
        tar xf $(location @gcc_src.tar//file) -C gcc-build --strip-components=1
        cd gcc-build

        case $$(uname -m) in
            x86_64)
                sed -e '/m64=/s/lib64/lib/' \
                    -i.orig gcc/config/i386/t-linux64
            ;;
        esac

        # Download prerequisites
        ./contrib/download_prerequisites

        # Override libgcc and libstdc++ build to support POSIX threads
        sed '/thread_header =/s/@.*@/gthr-posix.h/' \
            -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

        mkdir -v build
        cd build
        ../configure                                       \
            --build=$$(../config.guess)                    \
            --host=$$LFS_TGT                               \
            --target=$$LFS_TGT                             \
            LDFLAGS_FOR_TARGET=-L$$PWD/$$LFS_TGT/libgcc    \
            --prefix=/usr                                  \
            --with-build-sysroot=$$LFS                     \
            --enable-default-pie                           \
            --enable-default-ssp                           \
            --disable-nls                                  \
            --disable-multilib                             \
            --disable-libatomic                            \
            --disable-libgomp                              \
            --disable-libquadmath                          \
            --disable-libsanitizer                         \
            --disable-libssp                               \
            --disable-libvtv                               \
            --enable-languages=c,c++

        make -j"$$(nproc)"
        make DESTDIR=$$LFS install

        ln -sv gcc $$LFS/usr/bin/cc

        cleanup_extracted_dependencies

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """,
)

ENTER_LFS_SCRIPT = """

run_bash_script_in_lfs() {
    bwrap --bind $$LFS / --dev /dev --proc /proc --tmpfs /run --unshare-all /usr/bin/env -i \
            HOME=/root \
            MAKEFLAGS="-j$$(nproc)" \
            TESTSUITEFLAGS="-j$$(nproc)" \
            PATH=/bin:/usr/bin:/usr/sbin \
            bash -c "$$1"
}

extract_source() {
    mkdir -p $$LFS/src
    tar xf "$$1" -C $$LFS/src --strip-components=1
}

cleanup_source() {
    rm -rf $$LFS/src
}

"""

genrule(
    name = "image_temporary_rootfs",
    srcs = [
        "binutils_pass1_installed.tar",
        "gcc_pass1_installed.tar",
        "linux_headers_installed.tar",
        "glibc_installed.tar",
        "libstdcxx_installed.tar",
        "m4_installed.tar",
        "ncurses_installed.tar",
        "bash_installed.tar",
        "coreutils_installed.tar",
        "diffutils_installed.tar",
        "file_installed.tar",
        "findutils_installed.tar",
        "gawk_installed.tar",
        "grep_installed.tar",
        "gzip_installed.tar",
        "make_installed.tar",
        "patch_installed.tar",
        "sed_installed.tar",
        "tar_installed.tar",
        "xz_installed.tar",
        "binutils_pass2_installed.tar",
        "gcc_pass2_installed.tar",
    ],
    outs = ["image_temporary_rootfs.tar"],
    cmd = COMMON_SCRIPT + ENTER_LFS_SCRIPT + """
        for dep in $(SRCS); do
            extract_dependency $$dep
        done

        # Create addtional directories
        mkdir -pv $$LFS/{bin,etc,sbin,usr,var}
        case $$(uname -m) in
            x86_64) mkdir -pv $$LFS/lib64 ;;
        esac

        mkdir -pv $$LFS/{boot,home,mnt,opt,srv}
        mkdir -pv $$LFS/etc/{opt,sysconfig}
        mkdir -pv $$LFS/lib/firmware
        mkdir -pv $$LFS/media/{floppy,cdrom}
        mkdir -pv $$LFS/usr/{,local/}{include,src}
        mkdir -pv $$LFS/usr/lib/locale
        mkdir -pv $$LFS/usr/local/{bin,lib,sbin}
        mkdir -pv $$LFS/usr/{,local/}share/{color,dict,doc,info,locale,man}
        mkdir -pv $$LFS/usr/{,local/}share/{misc,terminfo,zoneinfo}
        mkdir -pv $$LFS/usr/{,local/}share/man/man{1..8}
        mkdir -pv $$LFS/var/{cache,local,log,mail,opt,spool}
        mkdir -pv $$LFS/var/lib/{color,misc,locate}

        ln -sfv /run $$LFS/var/run
        ln -sfv /run/lock $$LFS/var/lock

        install -dv -m 0750 $$LFS/root
        install -dv -m 1777 $$LFS/tmp $$LFS/var/tmp

        # Create locale definition for downstream packages
        run_bash_script_in_lfs "
            localedef -i C -f UTF-8 C.UTF-8
        "

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """,
)

sh_binary(
    name = "run_temporary_rootfs",
    srcs = ["scripts/run_bwrap.sh"],
    args = [
        "$(location image_temporary_rootfs.tar)",
    ],
    data = [
        "image_temporary_rootfs.tar",
    ],
)

genrule(
    name = "build_gettext",
    srcs = [
        "@gettext_src.tar//file",
        "image_temporary_rootfs.tar",
    ],
    outs = ["gettext_installed.tar"],
    cmd = COMMON_SCRIPT + ENTER_LFS_SCRIPT + """
        extract_dependency $(location image_temporary_rootfs.tar)

        extract_source $(location @gettext_src.tar//file)

        run_bash_script_in_lfs "
            cd /src
            ./configure --disable-shared
            make
            cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
        "

        cleanup_extracted_dependencies
        cleanup_source

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """,
)

genrule(
    name = "build_bison",
    srcs = [
        "@bison_src.tar//file",
        "image_temporary_rootfs.tar",
    ],
    outs = ["bison_installed.tar"],
    cmd = COMMON_SCRIPT + ENTER_LFS_SCRIPT + """
        extract_dependency $(location image_temporary_rootfs.tar)

        extract_source $(location @bison_src.tar//file)

        run_bash_script_in_lfs "
            cd /src
            ./configure --prefix=/usr --docdir=/usr/share/doc/bison-{bison_version}
            make
            make install
        "

        cleanup_extracted_dependencies
        cleanup_source

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        bison_version = BISON_VERSION,
    ),
)

genrule(
    name = "build_perl",
    srcs = [
        "@perl_src.tar//file",
        "image_temporary_rootfs.tar",
    ],
    outs = ["perl_installed.tar"],
    cmd = COMMON_SCRIPT + ENTER_LFS_SCRIPT + """
        extract_dependency $(location image_temporary_rootfs.tar)

        extract_source $(location @perl_src.tar//file)

        run_bash_script_in_lfs "
            cd /src
            /bin/sh Configure -des                                          \
                -D prefix=/usr                                         \
                -D vendorprefix=/usr                                   \
                -D useshrplib                                          \
                -D privlib=/usr/lib/perl5/{perl_version}/core_perl     \
                -D archlib=/usr/lib/perl5/{perl_version}/core_perl     \
                -D sitelib=/usr/lib/perl5/{perl_version}/site_perl     \
                -D sitearch=/usr/lib/perl5/{perl_version}/site_perl    \
                -D vendorlib=/usr/lib/perl5/{perl_version}/vendor_perl \
                -D vendorarch=/usr/lib/perl5/{perl_version}/vendor_perl
            make
            make install
        "

        cleanup_extracted_dependencies
        cleanup_source

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        perl_version = PERL_VERSION,
    ),
)

genrule(
    name = "build_python",
    srcs = [
        "@python_src.tar//file",
        "image_temporary_rootfs.tar",
    ],
    outs = ["python_installed.tar"],
    cmd = COMMON_SCRIPT + ENTER_LFS_SCRIPT + """
        extract_dependency $(location image_temporary_rootfs.tar)

        extract_source $(location @python_src.tar//file)

        run_bash_script_in_lfs "
            cd /src
            ./configure --prefix=/usr --enable-shared --without-ensurepip
            make
            make install
        "

        cleanup_extracted_dependencies
        cleanup_source

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """,
)

genrule(
    name = "build_texinfo",
    srcs = [
        "@texinfo_src.tar//file",
        "image_temporary_rootfs.tar",
        "perl_installed.tar",
    ],
    outs = ["texinfo_installed.tar"],
    cmd = COMMON_SCRIPT + ENTER_LFS_SCRIPT + """
        extract_dependency $(location image_temporary_rootfs.tar)
        extract_dependency $(location perl_installed.tar)

        extract_source $(location @texinfo_src.tar//file)

        run_bash_script_in_lfs "
            cd /src
            ./configure --prefix=/usr
            make
            make install
        "

        cleanup_extracted_dependencies
        cleanup_source

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """,
)

# Deviation: we disable the chgrp/chown steps, due to the limitations of the sandboxing approach
genrule(
    name = "build_util_linux",
    srcs = [
        "@util_linux_src.tar//file",
        "image_temporary_rootfs.tar",
    ],
    outs = ["util_linux_installed.tar"],
    cmd = COMMON_SCRIPT + ENTER_LFS_SCRIPT + """
        extract_dependency $(location image_temporary_rootfs.tar)

        extract_source $(location @util_linux_src.tar//file)

        run_bash_script_in_lfs "
            mkdir -pv /var/lib/hwclock
            cd /src
            ./configure --libdir=/usr/lib     \
                --runstatedir=/run    \
                --disable-chfn-chsh   \
                --disable-login       \
                --disable-nologin     \
                --disable-su          \
                --disable-setpriv     \
                --disable-runuser     \
                --disable-pylibmount  \
                --disable-static      \
                --disable-liblastlog2 \
                --without-python      \
                ADJTIME_PATH=/var/lib/hwclock/adjtime \
                --docdir=/usr/share/doc/util-linux-{util_linux_version}
            make
            # Disable the ownership changes
            rm /usr/bin/chgrp /usr/bin/chown
            ln -svf /usr/bin/true /usr/bin/chgrp
            ln -svf /usr/bin/true /usr/bin/chown
            make install
        "

        cleanup_extracted_dependencies
        cleanup_source

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """.format(
        util_linux_version = UTIL_LINUX_VERSION,
    ),
)

genrule(
    name = "build_man_pages",
    srcs = [
        "@man_pages_src.tar//file",
        "image_temporary_rootfs.tar",
    ],
    outs = ["man_pages_installed.tar"],
    cmd = COMMON_SCRIPT + ENTER_LFS_SCRIPT + """
        extract_dependency $(location image_temporary_rootfs.tar)

        extract_source $(location @man_pages_src.tar//file)

        run_bash_script_in_lfs "
            cd /src
            rm -v man3/crypt*
            make prefix=/usr install
        "

        cleanup_extracted_dependencies
        cleanup_source

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """,
)

genrule(
    name = "build_iana_etc",
    srcs = [
        "@iana_etc_src.tar//file",
        "image_temporary_rootfs.tar",
    ],
    outs = ["iana_etc_installed.tar"],
    cmd = COMMON_SCRIPT + ENTER_LFS_SCRIPT + """
        extract_dependency $(location image_temporary_rootfs.tar)

        extract_source $(location @iana_etc_src.tar//file)

        run_bash_script_in_lfs "
            cd /src
            cp services protocols /etc
        "

        cleanup_extracted_dependencies
        cleanup_source

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """,
)

# Note that the resulting tarball contains everything in the LFS directory, because of limitations in the packaging approach
# Deviation, not running the make check at this point
genrule(
    name = "build_glibc_pass2",
    srcs = [
        "@glibc_src.tar//file",
        "@glibc_fsh_patch//file",
        "image_temporary_rootfs.tar",
        "bison_installed.tar",
        "python_installed.tar",
        "texinfo_installed.tar",
        "perl_installed.tar",
        "gettext_installed.tar",
    ],
    outs = ["glibc_pass2_installed.tar"],
    cmd = COMMON_SCRIPT + ENTER_LFS_SCRIPT + """
        extract_dependency $(location image_temporary_rootfs.tar)
        for dep in $(SRCS); do
            if [[ "$$dep" == *_installed.tar ]]; then
                extract_dependency "$$dep"
            fi
        done

        extract_source $(location @glibc_src.tar//file)
        cp $(location @glibc_fsh_patch//file) $$LFS/src

        run_bash_script_in_lfs "
            cd /src
            patch -Np1 -i $$(basename $(location @glibc_fsh_patch//file))
            mkdir -v build
            cd build
            echo rootsbindir=/usr/sbin > configparms
            ../configure --prefix=/usr                   \
                --disable-werror                         \
                --enable-kernel=4.19                     \
                --enable-stack-protector=strong          \
                --disable-nscd                           \
                libc_cv_slibdir=/usr/lib
            make
            # make check

            touch /etc/ld.so.conf
            sed '/test-installation/s@\\$$(PERL)@echo not running@' -i ../Makefile
            make install
        "

        cleanup_source

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """,
)

genrule(
    name = "image_initial_rootfs",
    srcs = [
        "glibc_pass2_installed.tar",
        "man_pages_installed.tar",
        "iana_etc_installed.tar",
        "util_linux_installed.tar",
    ],
    outs = ["image_initial_rootfs.tar"],
    cmd = COMMON_SCRIPT + ENTER_LFS_SCRIPT + """
        extract_dependency $(location glibc_pass2_installed.tar)

        # Cleanup initial documentation
        rm -rf $$LFS/usr/share/{info,man,doc}/*

        extract_dependency $(location man_pages_installed.tar)
        extract_dependency $(location iana_etc_installed.tar)
        extract_dependency $(location util_linux_installed.tar)

        # Remove libtool archive files
        find $$LFS/usr/{lib,libexec} -name '*.la' -delete

        # Remove the tools directory
        rm -rf $$LFS/tools

        cd "$$START_DIR"
        tar cf "$@" -C "$$LFS" .
    """,
)

genrule(
    name = "build_sanity_check_gcc_pass2",
    srcs = [
        "image_initial_rootfs.tar",
    ],
    outs = ["sanity_check_gcc_pass2.txt"],
    cmd = COMMON_SCRIPT + """
        extract_dependency $(location image_initial_rootfs.tar)

        echo 'int main() { }' | gcc -xc -
        readelf -l a.out | grep ld-linux > "$@"
    """,
)

genrule(
    name = "build_sanity_check_gxx_pass2",
    srcs = [
        "image_initial_rootfs.tar",
    ],
    outs = ["sanity_check_gxx_pass2.txt"],
    cmd = COMMON_SCRIPT + """
        extract_dependency $(location image_initial_rootfs.tar)

        echo '#include <iostream>\nint main(){{std::cout<<"Hello, World!";return 0;}}' | g++ -xc++ -
        readelf -l a.out | grep ld-linux > "$@"
    """,
)

sh_binary(
    name = "run_initial_rootfs",
    srcs = ["scripts/run_bwrap.sh"],
    args = [
        "$(location image_initial_rootfs.tar)",
    ],
    data = [
        "image_initial_rootfs.tar",
    ],
)
