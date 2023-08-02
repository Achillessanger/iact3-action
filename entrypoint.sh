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
  test_name=${file%.*}
  test_name="test-${test_name}"
  echo $test_name":test name"
#  if grep -q 'CREATE_COMPLETE' output.txt; then
#    echo "000000000"
##    exit 0
#  else
#    echo "111111111"
##    exit 1
#  fi
  apt-get install tree
  tree ./

  cat iact3_outputs/${test_name}-result.json




#  python /iact3.py test run -t $file -c iact3-config/${file%.*}.iact3.yml
done

#echo $?":code"


#exit 0