# Tips and tricks about Podman

## Disable security in SELinux context

Most of the time just add `:Z` after volume parameters:

    podman run -dit -v ./cockpit:/tmp/cockpit:z localhost/cockpit-builder

If it is not working, add `--security-opt label=disable` and the `:z` option to your volume

    podman run -dit  --security-opt label=disable -v ./cockpit:/tmp/cockpit:z localhost/cockpit-builder

