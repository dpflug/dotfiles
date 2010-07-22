#!/usr/bin/env bash

#For doing things just on login.

[[ -f ~/.bash_profile_local ]] &&
source ~/.bash_profile_local

[[ -a ~/.bashrc ]] &&
source ~/.bashrc
