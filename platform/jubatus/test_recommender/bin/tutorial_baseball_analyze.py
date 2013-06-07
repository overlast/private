#!/usr/bin/env python
 # -*- coding: utf-8 -*-

from jubatus.recommender import client

NAME = "recommender_baseball"

if __name__ == '__main__':
    # 1. Jubatus Serverへの接続設定
    recommender = client.recommender("127.0.0.1", 9199)
     # 2. 推薦用データの準備
    for line in open('data/tutorial_baseball.csv'):
        pname, team, bave, games, pa, atbat, hit, homerun, runsbat, stolen, bob, hbp, strikeout, sacrifice, dp, slg, obp, ops, rc27, xr27 = line[:-1].split(',')
       # 3. 学習モデルに基づく推薦
        sr = recommender.similar_row_from_id(NAME, pname, 4)
       # 4. 結果の出力
        print "player ", pname, " is similar to :", sr[1][0], sr[2][0], sr[3][0]
