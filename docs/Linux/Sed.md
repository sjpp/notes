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

### Remove carriage return and merge lines

    # exemple to remove 'server_alias' from line 2 and merge it with line 1:
    sed -e ':a' -e 'N' -e '$!ba' -e 's/\;\n  server_alias//g' -i file

### Insert new line at top of file

    # 1i is important, the leading \ pushes the content at line 2
    sed -i -e '1i# {{ ansible_managed }}\' $file

### Replace new lines by spaces

    sed ':a;N;$!ba;s/\n/ /g' $file
