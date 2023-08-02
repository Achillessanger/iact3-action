#!/bin/bash


export ALIBABA_CLOUD_ACCESS_KEY_ID=$INPUT_ACCESS_KEY_ID
export ALIBABA_CLOUD_ACCESS_KEY_SECRET=$INPUT_ACCESS_KEY_SECRET


for file in $INPUT_TEMPLATES; do
  if [[ "$file" == .github* ]]
  then
    continue
  fi
  python /iact3.py test run -t $file -c iact3-config/${file%.*}.iact3.yml
done

echo $?":code"


#exit 0