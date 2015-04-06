#!/bin/sh
cd /home/myokoym/src/ruby/shogiteatime
if [ ! -f sendlist.yaml ]; then
  echo "---" >sendlist.yaml
  echo "" >>sendlist.yaml
fi
/usr/local/bin/yapra -c shogiteatime.yaml
/usr/local/bin/ruby shogiteatime.rb
