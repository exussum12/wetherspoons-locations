#!/bin/bash

curl 'https://www.jdwetherspoon.com/api/advancedsearch' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0' -H 'Accept: application/json, text/plain, */*'  --compressed -H 'Content-Type: application/json;charset=utf-8'  --data-raw '{"region":null,"paging":{"UsePagination":false},"facilities":[],"searchType":0}' > spoons.json

jq -r '.regions [].subRegions [].items [] | del(.facilities) | keys |  @csv'  spoons.json | uniq >  spoons.csv

jq -r '.regions [].subRegions [].items| del(.[].facilities) | (map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $rows[] | @csv' spoons.json | sort >> spoons.csv
