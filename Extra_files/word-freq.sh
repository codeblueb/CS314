#!/bin/sh

tr A-Z a-z | tr -C '\na-z' ' ' |tr ' ' '\n'  |   awk -f word-freq.awk | sort -nr -k2


NR > 0 {COUNT[$1]++}

END {FOR (A IN COUNT) PRINT A, COUNT[A]}

