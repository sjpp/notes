# Tips and tricks about Podman

## Disable security in SELinux context

Add `--security-opt label=disable` and the `:z` option to your volume

    podman run -dit  --security-opt label=disable -v ./cockpit:/tmp/cockpit:z localhost/cockpit-builder


