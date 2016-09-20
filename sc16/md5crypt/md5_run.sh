#!/bin/bash

hashcat -a 0 \
        -m 500 \
        -D 2 \
        -w 3 \
        --status \
        --status-timer=30 \
        -o md5_cracked.txt \
        md5crypt.txt \
        words
