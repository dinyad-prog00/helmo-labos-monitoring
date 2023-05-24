#!/bin/bash
set -eu

cat daemon-status.csv | grep -v "$3;$2"  > daemon-status-tmp.csv
cat daemon-status-tmp.csv > daemon-status.csv
rm daemon-status-tmp.csv
echo
echo "$4;$3;$2;$1" >> daemon-status.csv
