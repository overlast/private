#!/bin/sh

ABSDIR=$(cd $(dirname $0) && pwd)

echo "[sample] delete files which were made by sample.sh"
mv ${ABSDIR}/../sample/13tokyo.csv ${ABSDIR}/../
mv ${ABSDIR}/../sample/sample.txt ${ABSDIR}/../
rm ${ABSDIR}/../sample/*
mv ${ABSDIR}/../13tokyo.csv ${ABSDIR}/../sample/
mv ${ABSDIR}/../sample.txt ${ABSDIR}/../sample/
