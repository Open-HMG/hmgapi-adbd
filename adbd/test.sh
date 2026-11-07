#!/bin/sh
# Off-car test of adbd/build.sh (HMG-API's mod workflow runs it, with the NDK in NDK): the binary
# must be the one HMG-API built (ADBD_MD5), so a change to the sources changes ADBD_MD5 too.
# Built with LC_ALL=C: build.sh's *.c globs sort by the locale, which sets the link order
# (en_US.UTF-8 gives f61ff1fd0b98e1f4289639be7a8a0c68).
cd "$(dirname "$0")/.."
ADBD_MD5=e480b55bd0ffded055a0cf362623e975
NDK=${NDK:-$HOME/Android/ndk/21.4.7075529}
[ -x "$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi19-clang" ] || { echo "skip  adbd build: no NDK r21 at $NDK"; exit 0; }
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
LC_ALL=C NDK=$NDK sh adbd/build.sh "$T" > "$T/log" 2>&1 || { cat "$T/log"; echo "FAIL  adbd/build.sh"; exit 1; }
m=$(md5sum < "$T/files/hmgapi-adbd" | cut -c1-32)
if [ "$m" = "$ADBD_MD5" ]; then
    echo "ok    hmgapi-adbd is HMG-API's build ($m)"
else
    echo "FAIL  hmgapi-adbd is $m, not $ADBD_MD5 (HMG-API's build): change ADBD_MD5 only with a source change"; exit 1
fi
