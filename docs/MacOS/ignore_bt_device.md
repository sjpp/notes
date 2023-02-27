# How to ignore a Bluetooth device

* Turn off your Mac's Bluetooth
* Run
```
	sudo defaults write ~/Library/Preferences/com.apple.Bluetooth.plist IgnoredDevices -array-add '<MAC_ADDRESS_HERE>'
```

to add the device's MAC address to the user copy of the *com.apple.Bluetooth.plist* file instead of the system copy. You can run

```
sudo defaults read ~/Library/Preferences/com.apple.Bluetooth.plist IgnoredDevices to see that it was added.
```

* Turn on your Mac's Bluetooth

* Run

```
sudo defaults read ~/Library/Preferences/com.apple.Bluetooth.plist IgnoredDevices
```

again to confirm that the added MAC address stuck after Bluetooth was re-enabled.

*source: https://apple.stackexchange.com/questions/90888/how-to-block-bluetooth-device-that-spams-me-with-pairing-requests*
