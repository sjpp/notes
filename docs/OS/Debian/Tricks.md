---
tags:
    - debian
    - various
---

## Debian-tricks

If you’d like to prevent daemons from starting after installing a package, just toss a few lines into /usr/sbin/policy-rc.d:

    cat > /usr/sbin/policy-rc.d << EOF
    #!/bin/sh
    echo "All runlevel operations denied by policy" >&2
    exit 101
    EOF
