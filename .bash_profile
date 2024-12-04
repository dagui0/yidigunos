#!/bin/sh
# if login shell, change to common shell process.
# and environments are set from .bashrc.
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
