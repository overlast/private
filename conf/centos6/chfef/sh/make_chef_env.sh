#!/usr/bin/env bash

set -x # 実行されたコマンドを表示する
set -e # エラーがあったら諦めろ

BASEDIR=`cd $(dirname $0); pwd`
USER_ID=`/usr/bin/id -u`

sudo yum install ruby ruby-devel rubygems make gcc

if hash chef-solo 2>/dev/null; then
    echo "chef is already installed"
else
    gem install chef # 1回で入りきらない
    gem install chef # 2回目でsuccess
fi

if hash rbenb 2>/dev/null; then
    rbenv rehash
fi

if [ -e $HOME/.chef ]; then
    echo "knife is already configured"
else
    knife configure
fi

gem install knife-solo

if hash rbenb 2>/dev/null; then
    rbenv rehash
fi
