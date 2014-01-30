#!/usr/bin/env bash

set -x # 実行されたコマンドを表示する
set -e # エラーがあったら諦めろ

BASEDIR=`cd $(dirname $0); pwd`

PDF_PATH=$1

if [ -a ${PDF_PATH} ]; then
    k2pdfopt ${PDF_PATH} -dev kpw -bp -f2p -1
fi