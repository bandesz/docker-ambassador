#!/bin/bash
env | grep _TCP= | sed 's/.*_PORT_\([0-9]*\)_TCP=tcp:\/\/\(.*\):\(.*\)/exec socat -ls TCP4-LISTEN:\1,fork,reuseaddr TCP4:\2:\3 /'  | sh