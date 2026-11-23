#!/bin/bash
cd /workspace/certify/kc
./status.sh > status.now
while IFS=$'\t' read -r r id st con sha; do
  [ "$r" = frohmanian-tether-sdiff ] && continue
  grep -q "\"repo\": \"$r\"" stage2.jsonl 2>/dev/null && continue
  if [ "$st" = completed ] && [ "$con" = success ]; then python3 stage2.py "$r" "$id" >> stage2.jsonl 2>>stage2.err || echo "STAGE2 FAIL $r" | tee -a stage2.err; 
  elif [ "$st" = completed ]; then echo "CI $con: $r $id"; fi
done < status.now
grep -c repo stage2.jsonl
