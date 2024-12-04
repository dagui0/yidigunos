#!/bin/bash

cmd=${1:-start}
case $cmd in
    sh|bash|/bin/sh|/bin/bash)
        "$@"
        ;;
    start)
        trap 'echo "signal caught"; exit 0' TERM
        while true; do
            sleep 1
        done
        ;;
    *)
        echo "usage: $0 { sh | bash | start }"
        ;;
esac
