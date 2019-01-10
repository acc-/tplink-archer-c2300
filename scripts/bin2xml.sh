#!/bin/bash
[ $# -lt 1 ] && echo "Syntax: $0 backup-filename.bin [output-filename.xml]" && exit

IN=$1
[ $# -lt 2 ] && OUT=${IN%.*}.xml || OUT=$2

OPENSSL=/usr/local/bin/openssl

[ ! -f $IN ] && echo File $IN does not exist && exit

# MD5 used for Archer C2300
OUR_MD5=`echo -n "Archer C2300" | md5sum | cut -d' ' -f 1`

# AES key & iv params
AES="-K 2EB38F7EC41D4B8E1422805BCD5F740BC3B95BE163E39D67579EB344427F7836 -iv 360028C9064242F81074F4C127D299F6"

TMP=$IN-tmp-dir
mkdir -p $TMP

# decode binary file downloaded from TP-Link firmware - Backup
$OPENSSL aes-256-cbc -d $AES -in $IN | $OPENSSL zlib -d -out $TMP/mid.bin

# first 16 bytes are MD5 of product
FILE_MD5=`dd if=$TMP/mid.bin  bs=1 count=16 2>/dev/null |  hexdump -v -e '/1 "%02x"'`

echo "File MD5: ${FILE_MD5}, product MD5: ${OUR_MD5}"
[ "${OUR_MD5}" != "${FILE_MD5}" ] && echo "MD5 product name mismatch, beware when using xml2bin !!!" || echo "MD5 matches, this is the right binary file :-)"

# skip 16 bytes of md5 and extract orig.bin file
dd if=$TMP/mid.bin of=$TMP/orig.bin bs=1 skip=16 2>/dev/null

# decrypt again to get xml file
$OPENSSL aes-256-cbc -d $AES -in $TMP/orig.bin | $OPENSSL zlib -d -out $OUT

echo XML file saved in $OUT
rm -rf $TMP
