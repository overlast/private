#!/usr/bin/env bash

BASEDIR=$(cd $(dirname $0);pwd)

${BASEDIR}/../bin/crawled2titleid.pl ${BASEDIR}/../data/clawled_data_sample.tsv > ${BASEDIR}/../data/titleid.sample.tsv
LC_ALL=C sort -t $'\t' -k 1,1 < ${BASEDIR}/../data/titleid.sample.tsv > ${BASEDIR}/../data/titleid.sample.tsv.so
LC_ALL=C uniq ${BASEDIR}/../data/titleid.sample.tsv.so > ${BASEDIR}/../data/titleid.sample.tsv

${BASEDIR}/../bin/crawled2mat_lex.pl ${BASEDIR}/../data/clawled_data_sample.tsv > ${BASEDIR}/../data/mat_lex.sample.dat

LC_ALL=C sort -t $'\t' -k 1,1 < ${BASEDIR}/../data/mat_lex.sample.dat > ${BASEDIR}/../data/mat_lex.sample.dat.so
LC_ALL=C uniq ${BASEDIR}/../data/mat_lex.sample.dat.so > ${BASEDIR}/../data/mat_lex.sample.dat
rm ${BASEDIR}/../data/mat_lex.sample.dat.so

${BASEDIR}/../bin/add_yomi_roman_by_mecab.pl ${BASEDIR}/../data/titleid.sample.tsv > ${BASEDIR}/../data/titleid.sample.syr.tsv
${BASEDIR}/../bin/add_yomi_roman_by_mecab.pl ${BASEDIR}/../data/mat_lex.sample.dat > ${BASEDIR}/../data/mat_lex.sample.syr.tsv

cut -d $'\t' -f 1 < ${BASEDIR}/../data/titleid.sample.syr.tsv > ${BASEDIR}/../data/titleid.sample.yomi.dat
paste ${BASEDIR}/../data/titleid.sample.yomi.dat ${BASEDIR}/../data/titleid.sample.tsv > ${BASEDIR}/../data/titleid.sample.yomi.tsv
rm ${BASEDIR}/../data/titleid.sample.yomi.dat
LC_ALL=C sort -t $'\t' -k 1,1 < ${BASEDIR}/../data/titleid.sample.yomi.tsv > ${BASEDIR}/../data/titleid.sample.yomi.so
mv ${BASEDIR}/../data/titleid.sample.yomi.tsv.so ${BASEDIR}/../data/titleid.sample.yomi.tsv

cut -d $'\t' -f 2 < ${BASEDIR}/../data/titleid.sample.syr.tsv > ${BASEDIR}/../data/titleid.sample.roman.dat
paste ${BASEDIR}/../data/titleid.sample.roman.dat ${BASEDIR}/../data/titleid.sample.tsv > ${BASEDIR}/../data/titleid.sample.roman.tsv
rm ${BASEDIR}/../data/titleid.sample.roman.dat
LC_ALL=C sort -t $'\t' -k 1,1 < ${BASEDIR}/../data/titleid.sample.roman.tsv > ${BASEDIR}/../data/titleid.sample.roman.so
mv ${BASEDIR}/../data/titleid.sample.roman.tsv.so ${BASEDIR}/../data/titleid.sample.roman.tsv

cut -d $'\t' -f 1 < ${BASEDIR}/../data/mat_lex.sample.syr.tsv > ${BASEDIR}/../data/mat_lex.sample.yomi.dat
paste ${BASEDIR}/../data/mat_lex.sample.yomi.dat ${BASEDIR}/../data/mat_lex.sample.dat > ${BASEDIR}/../data/mat_lex.sample.yomi.tsv
rm ${BASEDIR}/../data/mat_lex.sample.yomi.dat
LC_ALL=C sort -t $'\t' -k 1,1 < ${BASEDIR}/../data/mat_lex.sample.yomi.tsv > ${BASEDIR}/../data/mat_lex.sample.yomi.so
mv ${BASEDIR}/../data/mat_lex.sample.yomi.tsv.so ${BASEDIR}/../data/mat_lex.sample.yomi.tsv

cut -d $'\t' -f 2 < ${BASEDIR}/../data/mat_lex.sample.syr.tsv > ${BASEDIR}/../data/mat_lex.sample.roman.dat
paste ${BASEDIR}/../data/mat_lex.sample.roman.dat ${BASEDIR}/../data/mat_lex.sample.dat > ${BASEDIR}/../data/mat_lex.sample.roman.tsv
rm ${BASEDIR}/../data/mat_lex.sample.roman.dat
LC_ALL=C sort -t $'\t' -k 1,1 < ${BASEDIR}/../data/mat_lex.sample.roman.tsv > ${BASEDIR}/../data/mat_lex.sample.roman.so
mv ${BASEDIR}/../data/mat_lex.sample.roman.tsv.so ${BASEDIR}/../data/mat_lex.sample.roman.tsv

apporo_indexer -i ${BASEDIR}/../data/titleid.sample.tsv -bt -u
apporo_indexer -i ${BASEDIR}/../data/titleid.sample.tsv -d

apporo_indexer -i ${BASEDIR}/../data/titleid.sample.yomi.tsv -bt -u
apporo_indexer -i ${BASEDIR}/../data/titleid.sample.yomi.tsv -d

apporo_indexer -i ${BASEDIR}/../data/titleid.sample.roman.tsv -bt -u
apporo_indexer -i ${BASEDIR}/../data/titleid.sample.roman.tsv -d

apporo_indexer -i ${BASEDIR}/../data/mat_lex.sample.dat -bt -u
apporo_indexer -i ${BASEDIR}/../data/mat_lex.sample.dat -d

apporo_indexer -i ${BASEDIR}/../data/mat_lex.sample.yomi.tsv -bt -u
apporo_indexer -i ${BASEDIR}/../data/mat_lex.sample.yomi.tsv -d

apporo_indexer -i ${BASEDIR}/../data/mat_lex.sample.roman.tsv -bt -u
apporo_indexer -i ${BASEDIR}/../data/mat_lex.sample.roman.tsv -d




