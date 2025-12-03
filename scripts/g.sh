#!/usr/bin/bash

git init;
git add -A;
git commit -m "first commit";
git branch -M main;
git remote add origin git@github.com:onedusk/tf.git;
git push -u origin main;
