#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Regexp::Assemble;
use Encode;

my $country_name = [
    "アフガニスタン",
    "アラブ首長国連邦",
    "イエメン",
    "イスラエル",
    "イラク",
    "イラン",
    "インド",
    "インドネシア",
    "ウズベキスタン",
    "オマーン",
    "カザフスタン",
    "カタール",
    "カンボジア",
    "キルギス",
    "クウェート",
    "サウジアラビア",
    "シリア",
    "シンガポール",
    "スリランカ",
    "タイ王国",
    "大韓民国",
    "タジキスタン",
    "中華人民共和国",
    "中華民国",
    "朝鮮民主主義人民共和国",
    "トルクメニスタン",
    "トルコ",
    "日本",
    "ネパール",
    "パキスタン",
    "バーレーン",
    "パレスチナ",
    "バングラデシュ",
    "東ティモール",
    "フィリピン",
    "ブータン",
    "ブルネイ",
    "ベトナム",
    "マレーシア",
    "ミャンマー",
    "モルディブ",
    "モンゴル国",
    "ヨルダン",
    "ラオス",
    "レバノン",
    "アフリカ",
    "アルジェリア",
    "アンゴラ",
    "ウガンダ",
    "エジプト",
    "エチオピア",
    "エリトリア",
    "ガーナ",
    "カーボベルデ",
    "ガボン",
    "カメルーン",
    "ガンビア",
    "ギニア",
    "ギニアビサウ",
    "ケニア",
    "コートジボワール",
    "コモロ",
    "コンゴ共和国",
    "コンゴ民主共和国",
    "サントメ・プリンシペ",
    "ザンビア",
    "シエラレオネ",
    "ジブチ",
    "ジンバブエ",
    "スーダン",
    "スワジランド",
    "セーシェル",
    "赤道ギニア",
    "セネガル",
    "ソマリア",
    "タンザニア",
    "チャド",
    "中央アフリカ共和国",
    "チュニジア",
    "トーゴ",
    "ナイジェリア",
    "ナミビア",
    "ニジェール",
    "ブルキナファソ",
    "ブルンジ",
    "ベナン",
    "ボツワナ",
    "マダガスカル",
    "マラウイ",
    "マリ共和国",
    "南アフリカ共和国",
    "南スーダン",
    "モザンビーク",
    "モーリシャス",
    "モーリタニア",
    "モロッコ",
    "リビア",
    "リベリア",
    "ルワンダ",
    "レソト",
    "アイスランド",
    "アイルランド",
    "アゼルバイジャン",
    "アルバニア",
    "アルメニア",
    "アンドラ",
    "イギリス",
    "イタリア",
    "ウクライナ",
    "エストニア",
    "オーストリア",
    "オランダ",
    "キプロス",
    "ギリシャ",
    "グルジア",
    "クロアチア",
    "コソボ",
    "サンマリノ",
    "スイス",
    "スウェーデン",
    "スペイン",
    "スロバキア",
    "スロベニア",
    "セルビア",
    "チェコ",
    "デンマーク",
    "ドイツ",
    "ノルウェー",
    "バチカン",
    "ハンガリー",
    "フィンランド",
    "フランス",
    "ブルガリア",
    "ベラルーシ",
    "ベルギー",
    "ボスニア・ヘルツェゴビナ",
    "ポルトガル",
    "ポーランド",
    "マケドニア共和国",
    "マルタ",
    "モナコ",
    "モルドバ",
    "モンテネグロ",
    "ラトビア",
    "リトアニア",
    "リヒテンシュタイン",
    "ルクセンブルク",
    "ルーマニア",
    "ロシア",
    "アメリカ合衆国",
    "アンティグア・バーブーダ",
    "エルサルバドル",
    "カナダ",
    "キューバ",
    "グアテマラ",
    "グレナダ",
    "コスタリカ",
    "ジャマイカ",
    "セントクリストファー・ネイビス",
    "セントルシア",
    "ドミニカ国",
    "ドミニカ共和国",
    "トリニダード・トバゴ",
    "ニカラグア",
    "ハイチ",
    "パナマ",
    "バハマ",
    "バルバドス",
    "ベリーズ",
    "ホンジュラス",
    "メキシコ",
    "アルゼンチン",
    "ウルグアイ",
    "エクアドル",
    "ガイアナ",
    "コロンビア",
    "スリナム",
    "チリ",
    "パラグアイ",
    "ブラジル",
    "ベネズエラ",
    "ペルー",
    "ボリビア",
    "オーストラリア",
    "キリバス",
    "サモア",
    "ソロモン諸島",
    "ツバル",
    "トンガ",
    "ナウル",
    "ニウエ",
    "ニュージーランド",
    "バヌアツ",
    "パプアニューギニア",
    "パラオ",
    "フィジー",
    "マーシャル諸島",
    "ミクロネシア連邦",
    "アメリカ連合国南部連合",
    "セルビア・モンテネグロ",
    "ザイール",
    "ソビエト連邦",
    "東ドイツ",
    "プロイセン王国",
    "ペルシア帝国",
    "ユーゴスラビア",
    "ローマ帝国",
    "チェコスロバキア",
];

my $ra = Regexp::Assemble->new;
foreach my $country (@{$country_name}) {
  $ra->add( $country );
}

print Encode::encode_utf8($ra->re);

=pod
Use "x(Perl|Ruby)" or "re.X or re.VERBOSE(Python)" because it includes newline.

(?^u:(?:ア(?:ル(?:(?:[バメ]ニ|ジェリ)ア|ゼンチン)|ン(?:ティグア・バーブーダ|
[ゴド]ラ)|メリカ(?:連合国南部連合|合衆国)|フ(?:ガニスタン|リカ)|イ[スル]ランド|
ゼルバイジャン|ラブ首長国連邦)|モ(?:ン(?:テネグロ|ゴル国)|ーリ(?:シャス|
タニア)|ル(?:ディブ|ドバ)|(?:ロッ|ナ)コ|ザンビーク)|セ(?:ント
(?:クリストファー・ネイビス|ルシア)|ルビア(?:・モンテネグロ)?|(?:ーシェ|
ネガ)ル)|ス(?:(?:ウェーデ|ペイ|ーダ)ン|リ(?:ランカ|ナム)|ロ(?:バキ|ベニ)ア|
ワジランド|イス)|(?:中(?:華(?:人民共和|民)|央アフリカ共和)|朝鮮民主主義人民共和|
プロイセン王|大韓民)国|マ(?:(?:ケドニア|リ)共和国|ーシャル諸島|ダガスカル|
レーシア|ラウイ|ルタ)|コ(?:ンゴ(?:民主)?共和国|ートジボワール|スタリカ|ロンビア|
ソボ|モロ)|エ(?:(?:ストニ|チオピ|リトリ)ア|(?:ルサルバ|クア)ドル|ジプト)|
イ(?:ンド(?:ネシア)?|ラ[クン]|スラエル|エメン|ギリス|タリア)|ト
(?:(?:リニダード・トバ|ー)ゴ|ル(?:クメニスタン|コ)|ンガ)|パ(?:ラ(?:グアイ|オ)|
プアニューギニア|キスタン|レスチナ|ナマ)|カ(?:(?:ザフスタ|メルー)ン|ーボベルデ|
ンボジア|タール|ナダ)|サ(?:ン(?:トメ・プリンシペ|マリノ)|(?:ウジアラビ|モ)ア)|
バ(?:(?:ーレー|チカ)ン|ングラデシュ|ルバドス|ヌアツ|ハマ)|ブ(?:ル(?:キナファソ|
ガリア|ネイ|ンジ)|ラジル|ータン)|ベ(?:ネズエラ|ラルーシ|トナム|リーズ|ルギー|
ナン)|チ(?:ェコ(?:スロバキア)?|ュニジア|ャド|リ)|ボ(?:(?:スニア・ヘルツェゴビ|
ツワ)ナ|リビア)|リ(?:(?:トアニ|ベリ|ビ)ア|ヒテンシュタイン)|ウ(?:ズベキスタン|
クライナ|ルグアイ|ガンダ)|ニ(?:ュージーランド|カラグア|ジェール|ウエ)|フ
(?:ィ(?:ンランド|リピン|ジー)|ランス)|(?:(?:赤道ギ|ケ)ニ|ユーゴスラビ)ア|キ
(?:(?:プロ|リバ|ルギ)ス|ューバ)|ガ(?:(?:イア|ー)ナ|ンビア|ボン)|オ
(?:ーストラ?リア|マーン|ランダ)|ソ(?:ビエト連邦|ロモン諸島|マリア)|ナ
(?:(?:イジェリ|ミビ)ア|ウル)|ル(?:クセンブルク|ーマニア|ワンダ)|ギ(?:ニア
(?:ビサウ)?|リシャ)|シ(?:エラレオネ|ンガポール|リア)|タ(?:ジキスタン|ンザニア|
イ王国)|ド(?:ミニカ(?:共和)?国|イツ)|グ(?:アテマラ|ルジア|レナダ)|ジ(?:ャマイカ|
ンバブエ|ブチ)|ミ(?:クロネシア連邦|ャンマー)|南(?:アフリカ共和国|スーダン)|ク
(?:ウェート|ロアチア)|ポ(?:ルトガル|ーランド)|東(?:ティモール|ドイツ)|ザ
(?:イール|ンビア)|ハ(?:ンガリー|イチ)|ペル(?:シア帝国|ー)|ロ(?:ーマ帝国|シア)|
(?:ネパー|ツバ)ル|ラ(?:トビア|オス)|レ(?:バノン|ソト)|ホンジュラス|デンマーク|
ノルウェー|メキシコ|ヨルダン|日本))(?^u:(?:ア(?:ル(?:(?:[バメ]ニ|ジェリ)ア|
ゼンチン)|ン(?:ティグア・バーブーダ|[ゴド]ラ)|メリカ(?:連合国南部連合|合衆国)|
フ(?:ガニスタン|リカ)|イ[スル]ランド|ゼルバイジャン|ラブ首長国連邦)|モ
(?:ン(?:テネグロ|ゴル国)|ーリ(?:シャス|タニア)|ル(?:ディブ|ドバ)|(?:ロッ|ナ)コ|
ザンビーク)|セ(?:ント(?:クリストファー・ネイビス|ルシア)|ルビア
(?:・モンテネグロ)?|(?:ーシェ|ネガ)ル)|ス(?:(?:ウェーデ|ペイ|ーダ)ン|リ
(?:ランカ|ナム)|ロ(?:バキ|ベニ)ア|ワジランド|イス)|(?:中(?:華(?:人民共和|民)|
央アフリカ共和)|朝鮮民主主義人民共和|プロイセン王|大韓民)国|マ(?:(?:ケドニア|リ)
共和国|ーシャル諸島|ダガスカル|レーシア|ラウイ|ルタ)|コ(?:ンゴ(?:民主)?共和国|
ートジボワール|スタリカ|ロンビア|ソボ|モロ)|エ(?:(?:ストニ|チオピ|リトリ)ア|
(?:ルサルバ|クア)ドル|ジプト)|イ(?:ンド(?:ネシア)?|ラ[クン]|スラエル|エメン|
ギリス|タリア)|ト(?:(?:リニダード・トバ|ー)ゴ|ル(?:クメニスタン|コ)|ンガ)|パ
(?:ラ(?:グアイ|オ)|プアニューギニア|キスタン|レスチナ|ナマ)|カ
(?:(?:ザフスタ|メルー)ン|ーボベルデ|ンボジア|タール|ナダ)|サ
(?:ン(?:トメ・プリンシペ|マリノ)|(?:ウジアラビ|モ)ア)|バ(?:(?:ーレー|チカ)ン|
ングラデシュ|ルバドス|ヌアツ|ハマ)|ブ(?:ル(?:キナファソ|ガリア|ネイ|ンジ)|
ラジル|ータン)|ベ(?:ネズエラ|ラルーシ|トナム|リーズ|ルギー|ナン)|チ
(?:ェコ(?:スロバキア)?|ュニジア|ャド|リ)|ボ(?:(?:スニア・ヘルツェゴビ|ツワ)ナ|
リビア)|リ(?:(?:トアニ|ベリ|ビ)ア|ヒテンシュタイン)|ウ(?:ズベキスタン|クライナ|
ルグアイ|ガンダ)|ニ(?:ュージーランド|カラグア|ジェール|ウエ)|フ
(?:ィ(?:ンランド|リピン|ジー)|ランス)|(?:(?:赤道ギ|ケ)ニ|ユーゴスラビ)ア|キ
(?:(?:プロ|リバ|ルギ)ス|ューバ)|ガ(?:(?:イア|ー)ナ|ンビア|ボン)|オ
(?:ーストラ?リア|マーン|ランダ)|ソ(?:ビエト連邦|ロモン諸島|マリア)|ナ
(?:(?:イジェリ|ミビ)ア|ウル)|ル(?:クセンブルク|ーマニア|ワンダ)|ギ
(?:ニア(?:ビサウ)?|リシャ)|シ(?:エラレオネ|ンガポール|リア)|タ(?:ジキスタン|
ンザニア|イ王国)|ド(?:ミニカ(?:共和)?国|イツ)|グ(?:アテマラ|ルジア|レナダ)|ジ
(?:ャマイカ|ンバブエ|ブチ)|ミ(?:クロネシア連邦|ャンマー)|南(?:アフリカ共和国|
スーダン)|ク(?:ウェート|ロアチア)|ポ(?:ルトガル|ーランド)|東(?:ティモール|
ドイツ)|ザ(?:イール|ンビア)|ハ(?:ンガリー|イチ)|ペル(?:シア帝国|ー)|ロ
(?:ーマ帝国|シア)|(?:ネパー|ツバ)ル|ラ(?:トビア|オス)|レ(?:バノン|ソト)|
ホンジュラス|デンマーク|ノルウェー|メキシコ|ヨルダン|日本))
=cut