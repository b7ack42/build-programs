#!/bin/bash

export CC=/home/jinghan/vivifuzz/fastgen/bin/ko-clang
export CXX=/home/jinghan/vivifuzz/fastgen/bin/ko-clang++
export KO_CC=clang-6.0
export KO_CXX=clang++-6.0

export CFLAGS=
export CXXFLAGS=
export KO_DONT_OPTIMIZE=1

export OUT=$PWD/programs
export FUZZER_LIB=$OUT/driver_symsan.a
export LIB_FUZZING_ENGINE=$OUT/driver_symsan.a

export WORKDIR=$PWD
export ARCHITECTURE=
export SANITIZER=

export USE_TRACK=1
export EXT="track"

# export USE_FAST=1
# export EXT="fast"


$CC -c standaloneengine.c -o $OUT/driver_symsan.o
ar r $OUT/driver_symsan.a $OUT/driver_symsan.o

sudo cp $OUT/driver_symsan.a /usr/lib/libFuzzingEngine.a

echo "binutils"

cd binutils
wget https://ftp.gnu.org/gnu/binutils/binutils-2.33.1.tar.gz
tar xvf binutils-2.33.1.tar.gz
cd binutils-2.33.1
./configure --disable-shared
make -j
cp binutils/nm-new $OUT/nm.$EXT
cp binutils/size $OUT/size.$EXT
cp binutils/objdump $OUT/objdump.$EXT
cp binutils/readelf $OUT/readelf.$EXT
cd $WORKDIR


echo "libjpeg"

cd libjpeg
git clone https://github.com/libjpeg-turbo/libjpeg-turbo.git
./build.sh
cp libjpeg.$EXT $OUT/
cd $WORKDIR

echo "libpng"
cd libpng
tar xvf libpng-1.2.56.tar.gz
./build.sh
cp libpng.$EXT $OUT/
cd $WORKDIR

echo "freetype"
cd freetype
tar xvf freetype2.tar.gz 
tar xvf libarchive-3.4.3.tar.xz
./build.sh
cp freetype.$EXT $OUT/
cd $WORKDIR

echo "harfbuzz"
cd harfbuzz
git clone https://github.com/behdad/harfbuzz.git
./build.sh
cp harfbuzz.$EXT $OUT/
cd $WORKDIR

echo "jsoncpp"
cd json
git clone https://github.com/open-source-parsers/jsoncpp
./build.sh
cp jsoncpp/jsoncpp.$EXT $OUT/json.$EXT
cd $WORKDIR


echo "lcms"
cd lcms
git clone https://github.com/mm2/Little-CMS.git
./build.sh
cp lcms.$EXT $OUT/
cd $WORKDIR

echo "xml"
cd xml
git clone https://gitlab.gnome.org/GNOME/libxml2.git
./build.sh
cp xml.$EXT $OUT/
cd $WORKDIR

echo "openssl"
cd openssl
git clone https://github.com/openssl/openssl.git
./build.sh
cp x509.$EXT $OUT/openssl.$EXT
cd $WORKDIR

echo "vorbis"
cd vorbis
git clone  https://github.com/xiph/ogg.git
git clone https://github.com/xiph/vorbis.git
./build.sh
cp vorbis.$EXT $OUT/
cd $WORKDIR

echo "woff2"
cd woff2
git clone https://github.com/google/woff2.git
git clone https://github.com/google/oss-fuzz.git
git clone https://github.com/google/brotli.git
./build.sh
cp woff2.$EXT $OUT/
cd $WORKDIR

echo "re2"
cd re2
git clone https://github.com/google/re2.git
./build.sh
cp re2.$EXT $OUT/
cd $WORKDIR


echo "proj"
cd proj
git clone https://github.com/OSGeo/PROJ
./build.sh
cp proj.$EXT $OUT/
cd $WORKDIR


echo "openthread"
cd openthread
git clone https://github.com/openthread/openthread.git
./build.sh
cp openthread.$EXT $OUT/
cd $WORKDIR


echo  "sqlite"
cd sqlite
tar xvf sqlite3.tar.gz
./build.sh
cp sqlite/sqlite.$EXT $OUT/
cd $WORKDIR

echo "mbedtls"
cd mbedtls
git clone https://github.com/openssl/openssl.git
git clone https://github.com/google/boringssl.git
git clone https://github.com/ARMmbed/mbedtls.git
git clone https://github.com/ARMmbed/mbed-crypto mbedtls/crypto
./build.sh
cp mbedtls/programs/fuzz/fuzz_dtlsclient $OUT/mbedtls.$EXT
cd $WORKDIR

echo "curl"
cd curl
git clone https://github.com/curl/curl.git
git clone https://github.com/curl/curl-fuzzer.git curl_fuzzer
cp ossfuzz.sh curl_fuzzer
cp install_openssl.sh curl_fuzzer/scripts/
./build.sh
cp curl_fuzzer/curl_fuzzer_http $OUT/curl.$EXT
cd $WORKDIR

