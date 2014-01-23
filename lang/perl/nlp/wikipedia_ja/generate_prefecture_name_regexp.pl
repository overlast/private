#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Regexp::Assemble;
use Encode;

my $country_name = [
"北海道", "青森県", "秋田県", "岩手県", "山形県", "宮城県", "福島県", "新潟県",
"群馬県", "栃木県", "茨城県", "千葉県", "埼玉県", "東京都", "神奈川県",
"静岡県", "山梨県", "長野県", "富山県", "石川県", "福井県", "滋賀県", "岐阜県",
"愛知県", "三重県", "奈良県", "和歌山県", "大阪府", "京都府", "兵庫県",
"岡山県", "鳥取県", "島根県", "広島県", "山口県", "香川県", "徳島県", "愛媛県",
"高知県", "福岡県", "佐賀県", "長崎県", "大分県", "宮崎県", "熊本県",
"鹿児島県", "沖縄県",
];

my $ra = Regexp::Assemble->new;
foreach my $country (@{$country_name}) {
  $ra->add( $country );
}

print Encode::encode_utf8($ra->re);

=pod

Use "x(Perl|Ruby)" or "re.X or re.VERBOSE(Python)" because it includes newline.

(?^u:(?:(?:(?:[富岡]|和歌)山|(?:[広徳]|鹿児)島|(?:[石香]|神奈)川|山[口形梨]|
福[井岡島]|[佐滋]賀|宮[城崎]|愛[媛知]|長[崎野]|三重|兵庫|千葉|埼玉|奈良|
岐阜|岩手|島根|新潟|栃木|沖縄|熊本|秋田|群馬|茨城|青森|静岡|高知|鳥取)県|
大(?:分県|阪府)|京都府|北海道|東京都))

=cut
