#!/bin/sh

curl -sSL https://api.github.com/repos/ancwrd1/snx-rs/releases/latest | grep tag_name | cut -d "\"" -f 4 | cut -d "v" -f2
