---
tags:
    - various
    - git
    - cli
---

## Rename Git Branch

Start by switching to the local branch which you want to rename:

    git checkout <old_name>

Rename the local branch by typing:

    git branch -m <new_name>

At this point, you have renamed the local branch.
If you’ve already pushed the <old_name> branch to the remote repository, perform the next steps to rename the remote branch.
Push the <new_name> local branch and reset the upstream branch:

    git push origin -u <new_name>

Delete the <old_name> remote branch:

    git push origin --delete <old_name>

## Sign Git commits with GPG

- Declare key to be used

    git config --global user.signingkey A34RED67G4 

- now you can add the `-S` flag when committing

    git commit -S

- or you can ask Git to automatically sign all your future commits

    git config --global commit.gpgsign true

- To check a commit

    git verify-commit cce09ca

## Clear Git history without removing repository

    cd myrepo
    rm -rf .git

    git init
    git add .
    git commit -m "initial commit"

    git remote add origin github.com:yourhandle/yourrepo.git
    git push -u --force origin master

## Delete a file from all commits in a branch

    git filter-branch --tree-filter 'rm -rf path/to/file.ext' <BRANCH>

## Delete all tags locally and remotely

Delete All local tags. (Optional Recommended)

    git tag -d $(git tag -l)

Fetch remote All tags. (Optional Recommended)

    git fetch

Delete All remote tags.

!!! note
    pushing once should be faster than multiple times

    git push origin --delete $(git tag -l) 

Delete All local tags.

    git tag -d $(git tag -l)

