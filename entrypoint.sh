#!/bin/bash

export ALIBABA_CLOUD_ACCESS_KEY_ID=$INPUT_ACCESS_KEY_ID
export ALIBABA_CLOUD_ACCESS_KEY_SECRET=$INPUT_ACCESS_KEY_SECRET
pass_test=1

for file in $INPUT_TEMPLATES
do
  if [[ "$file" == .github* ]]; then
    continue
  fi
  if [[ "$file" == .DS_Store* ]]; then
    continue
  fi

  echo -e "\n------Testing $file------"
  python /iact3.py validate -t $file  >> output.txt 2>&1
  cat output.txt
  if ! grep -q "LegalTemplate" output.txt; then
    pass_test=0
  fi
  rm -rf output.txt

done

if [ $pass_test -eq 1 ]
then
  echo "status=success" >> $GITHUB_OUTPUT
	exit 0
else
  echo "status=fail" >> $GITHUB_OUTPUT
	exit 1
fi