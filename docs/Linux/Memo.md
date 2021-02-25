# Memo

## Suppr all output

    >/dev/null 2>&1

## Rescan disk size

    echo 1>/sys/class/block/sdd/device/rescan

### Python: Convertir un résultat pipé en json → yaml

    python -c 'import sys, yaml, json;  yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'

### Generate Tilix bookmarks from SSH config

    #!/bin/bash

    # FILE=$HOME/.config/tilix/bookmarks.json
    echo -e "{\n\t\"list\": [\n" > "$FILE"
    for i in $(cat ~/.ssh/config | grep "Host\ " | awk '{print $2}' | grep -v "*" | sort)
    do
        echo -e "\t\t{\n\t\t\t\"command\": \"\",\n\t\t\t\"host\": \"$i\",\n\t\t\t\"name\": \"$i\",\n\t\t\t\"params\": \"\",\n\t\t\t\"port\": 22,\n\t\t\t\"protocolType\": \"SSH\",\n\t\t\t\"type\": \"REMOTE\",\n\t\t\t\"user\": \"root\"\n\t\t}," \
        | sed 's/\t/\ \ \ \ /g'
    done >> "$FILE"
    echo -e "\t]\n}\n" >> "$FILE"
