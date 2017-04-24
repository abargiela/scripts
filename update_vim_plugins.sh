#!/bin/bash
 
VIM_PATH="/home/${USER}/.vim/bundle/"
 
for i in $(ls -1 ${VIM_PATH}); do 
  git --git-dir=${VIM_PATH}/${i}/.git pull; 
done
