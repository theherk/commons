#!/bin/bash
while read p; do
  git cherry-pick $p
done < <(tac ~/commits.txt)
