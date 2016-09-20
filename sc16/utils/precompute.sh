#!/bin/bash

hashcat --stdout $1 -r $2 > $3
