#!/bin/bash

awk '{ print length($0) " " $0;  }' $1 | sort -n | cut -d ' ' -f 2- > $2
