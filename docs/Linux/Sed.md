---
tags:
    - cli
    - sed
    - linux
    - shell
---

## Sed tricks

### To remove the line and print the output to standard out:

    sed '/pattern to match/d' ./infile

### To directly modify the file:

    sed -i '/pattern to match/d' ./infile

### To directly modify the file (and create a backup):

    sed -i.bak '/pattern to match/d' ./infile

###  Delete N lines in a file

As long as the file is not a symlink or hardlink, you can use sed, tail, or awk. Example below.

    $ cat t.txt
    12
    34
    56
    78
    90
    
    $ sed -e '1,3d' < t.txt
    78
    90

### Delete empty lines

    sed '/^\s*$/d'

### sed + remove # and empty lines with one sed command

    sed -e 's/#.*$//' -e '/^$/d' inputFile

### Remove trailing witespaces

    sed -i 's/[ \t]*$//' file

### Replace between strings

    sed -n -e '/Word A/,/Word D/ p' file