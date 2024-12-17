#!/bin/bash

if [[ -f $HOME/.docker/config.json ]]; then
	echo $HOME/.docker/config.json
else
	echo ${XDG_RUNTIME_DIR}/containers/auth.json
fi
