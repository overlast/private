#!/usr/bin/env bash

set -x # 実行されたコマンドを表示する
set -e # エラーがあったら諦めろ

BASEDIR=`cd $(dirname $0); pwd`
USER_ID=`/usr/bin/id -u`

sudo yum install ruby ruby-devel rubygems make gcc
gem install chef # 1回で入りきらない
gem install chef # 2回目でsuccess
