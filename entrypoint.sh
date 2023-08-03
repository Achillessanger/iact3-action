#!/bin/bash


export ALIBABA_CLOUD_ACCESS_KEY_ID=$INPUT_ACCESS_KEY_ID
export ALIBABA_CLOUD_ACCESS_KEY_SECRET=$INPUT_ACCESS_KEY_SECRET


for file in $INPUT_TEMPLATES; do
  if [[ "$file" == .github* ]]
  then
    continue
  fi

  python /iact3.py test run -t $file -c iact3-config/${file%.*}.iact3.yml

  test_name=$(basename $file)
  test_name=${test_name%.*}
  test_name="test-${test_name}"

  cat iact3_outputs/${test_name}-result.json

  test_result=$(jq '.Result' iact3_outputs/${test_name}-result.json)
  echo $test_result":test_result"
  if [ "$test_result" = "Success" ]; then
    echo "0"
    exit 0
  else
    echo "1"
    exit 1
  fi



#  python /iact3.py test run -t $file -c iact3-config/${file%.*}.iact3.yml
done

#echo $?":code"


#exit 0