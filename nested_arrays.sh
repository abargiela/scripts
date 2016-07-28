#!/bin/bash

LIST=(a b c d)
REPO=(y g w p)
counter=0

#Gets arrays position
while [[ $counter -le ${#LIST[@]} ]]; do
for list in ${LIST[$counter]}; do
        for repo in ${REPO[$counter]}; do
          echo $list $repo
        done
  done
  let counter+=1
  echo $counter
done
