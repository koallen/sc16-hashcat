#!/bin/bash

hashcat64.bin -a 0 \
              -m 500 \
              -D 2 \
              -w 2 \
              --status \
              --status-timer=30 \
              -o md5_cracked.txt \
              md5crypt.txt \
              ../dicts/words_with_rules_sorted
