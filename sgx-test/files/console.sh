#!/bin/bash

# Require jq installed:
#  brew install jq
#  apt install jq

function req {
  rand_number=$((RANDOM))
  data="${2}"
  if [ -z "${data}" ]; then
    data='{}'
  fi
  curl -sgX POST -H "Content-Type: application/json" "http://127.0.0.1:8000/${1}" \
       -d "{\"input\":${data}, \"nonce\": {\"id\": ${rand_number}}}" \
       | tee /tmp/req_result.json | jq '.payload|fromjson'
  echo
}

function req_set {
  id=$1
  path=$2
  file_b64=$(cat "${path}"| base64 -w 0)
  req set "{\"path\": \"${id}\", \"data\": \"${file_b64}\"}"
}

function set_dataset {
  req_set "/ipfs/QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG" ./scripts/dataset.csv
}

function set_query {
  req_set "/ipfs/QmY6yj1GsermExDXoosVE3aSPxdMNYr6aKuw3nA8LoWPRS" ./scripts/query.csv
}

function get_result {
  path="/order/0"
  req get "{\"path\": \"${path}\"}"
  cat /tmp/req_result.json | jq '.payload|fromjson|.value' -r | base64 -d
}

function init {
  req init_runtime "{\"skip_ra\": false, \"bridge_genesis_info_b64\": \"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEDmnA2xKydrb2HsTrcVvPiQyA5LvV0LPHa2dh9q6ktgDFwoudZe3t+PYTAU5HROaYrFX54eG2MCC8p3PTBETFAAIiNw0F9UFjsS0UD4MEuoaCom+IA/piSJCPUM0AU+msO4BAAAAAAAAANF8LXgj6/Jg/ROPLX4n0RTAFF2Wi1/1AGEl8kFPra5pAQAAAAAAAAAMoQKALhCA33I0FGiDoLZ6HBWl1uCIt+sLgUbPlfMJqUk/gukhEt6AviHkl5KFGndUmA+ClBT2kPSvmBOvZTWowWjNYfynHU6AkLJ6ULmAAZPol0tbWaCiuvxqTk9Sx+9cqgrVL94lrrmAUJegqkIzp2A6LPkZouRRsKgiY4Wu92V8JXrn3aSXrw2AXDYZ0c8CICTMvasQ+rEpErmfEmg+BzH19s/zJX4LP8ZtAYKmqACACKEICOLbrasjYGHJaC9qmpHtUgEnM5k2qVJpNxn9mbdQXHh0cmluc2ljX2luZGV4EAAAAACAc0yvcsUiYcma5kSPZKxrMxbyDufisOfMmIsX1bDxfHedAWRyYW5kcGFfYXV0aG9yaXRpZXNJAQEIiNw0F9UFjsS0UD4MEuoaCom+IA/piSJCPUM0AU+msO4BAAAAAAAAANF8LXgj6/Jg/ROPLX4n0RTAFF2Wi1/1AGEl8kFPra5pAQAAAAAAAAA=\"}"
}

case $1 in
run)
  make && cd bin && ./app
;;
init)
  init
;;
set-dataset)
  set_dataset
;;
set-query)
  set_query
;;
set-all)
  set_dataset
  set_query
;;
get-result)
  get_result
;;
*)
  req "$@"
;;
esac