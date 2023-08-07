#!/bin/bash


export ALIBABA_CLOUD_ACCESS_KEY_ID=$INPUT_ACCESS_KEY_ID
export ALIBABA_CLOUD_ACCESS_KEY_SECRET=$INPUT_ACCESS_KEY_SECRET
pass_test=1

for file in $INPUT_TEMPLATES; do
  if [[ "$file" == .github* ]]
  then
    continue
  fi

  if [ -f iact3-config/${file%.*}.iact3.yml ]; then
    python /iact3.py test run -t $file -c iact3-config/${file%.*}.iact3.yml

    test_name=$(basename $file)
    test_name=${test_name%.*}
    test_name="test-${test_name}"

    cat iact3_outputs/${test_name}-result.json

    test_result=$(jq '.Result' iact3_outputs/${test_name}-result.json)


    if [[ $test_result != "\"Success\"" ]]; then
      pass_test=0
    fi
  else
    python /iact3.py validate -t $file  > output.txt
    echo "output.txt:\n"
    cat output.txt
    apt-get install -y tree
    tree
  fi
done

if [ $pass_test -eq 1 ]
then
	exit 0
else
	exit 1
fi




#  python /iact3.py test run -t $file -c iact3-config/${file%.*}.iact3.yml


#echo $?":code"


#exit 0