| :exclamation:  Project moved to [https://dri.ven.uber.space/this/Wi-Fi_IEM](https://dri.ven.uber.space/this/Wi-Fi_IEM) |
|-----------------------------------------|

# Wi-Fi IEM
[In-Ear Monitor](https://en.wikipedia.org/wiki/In-ear_monitor)ing over wireless LAN using [Real-Time Linux](https://wiki.linuxfoundation.org/realtime/start) on [Raspberry Pi](http://www.raspberrypi.org/)

This project is for building a prototype on Raspberry Pi plattform powered by [RealtimePi](https://github.com/guysoft/RealtimePi) using [Zita-njbridge](https://kokkinizita.linuxaudio.org/linuxaudio/index.html) with [JACK Audio Connection Kit](https://github.com/jackaudio/) and [hostapd](https://w1.fi/hostapd/) for access point operation.

First of all I'd like to thank [Guy Sheffer](https://github.com/guysoft) for maintaining RealtimePi, Jouni Malinen for developing hostapd and Fons Adriaensen for creating Zita-njbridge as well as all the other people contributing to Linux and free software.

## Requirements
Hardware components:
- 2x [Raspberry Pi 3 B+](https://www.raspberrypi.org/products/raspberry-pi-3-model-b-plus/) including SD card and power supply or a powerbank for mobile receiver, respectively. Refer to [Raspberry Pi Documentation](https://www.raspberrypi.org/documentation/setup/) for details.
- [IQaudIO Pi-DAC+](http://iqaudio.co.uk/hats/8-pi-dac.html) HAT audio interface
- [HifiBerry DAC+](https://www.hifiberry.com/shop/boards/hifiberry-dac-adc) HAT audio interface

You need terminal access on both Raspberry Pis to run scripts. Either physically or remotely using [SSH](https://www.raspberrypi.org/documentation/remote-access/ssh/README.md). Furthermore an internet connection is needed for installing packages.

## Installation
1. Flash a [nightly build of RealtimePi](http://unofficialpi.org/Distros/RealtimePi/nightly/) on both SD cards (refer to Raspberry Pi Documentation for how to flash SD cards with images) and power on Raspberry Pis afterwards.
2. Log in
3. Clone this git repository: `git clone https://github.com/thisven/Wi-Fi_IEM`
4. Change directory to Wi-Fi_IEM: `cd Wi-Fi_IEM`

### Setup the transmitter: iem-tx
5. Use Raspberry Pi on power supply as transmitter
6. Changing directory to iem-tx and run install-tx.sh script: `./install-tx.sh`
7. Reboot and log in again
8. If you'd like to use a wireless router as access point:
   - Disable hostapd service: `sudo systemctl disable hostapd`
   - Connect wireless router to ethernet port of iem-tx
   - Setup network credentials to match with those in [iem-rx config file](iem-rx/conf/realtimepi-wpa-supplicant.txt)
9. Execute `tx-wlan` (or `tx-eth` if using a wireless router)

### Setup the receiver: iem-rx
10. Use Raspberry Pi on powerbank as receiver
11. Changing directory to iem-rx and run install-rx.sh script: `./install-rx.sh`
12. Reboot and log in again
13. Execute `rx-wlan`

## Hints
Operation of jackd on both systems is logged to jack-_NetworkInterfaceName-p**Frames**-r**Samplerate**_.log and zita-n2j information on resampling on iem-rx is written to zn2j-_NetworkInterfaceName-p**Frames**-r**Samplerate**_.log file. (If you didn't changed standard values: **Frames**=128, **Samplerate**=96000.)

## Tipps and Tricks
If connection is dropping out, set a higher buffer for zita-n2j by changing _3_ to a higher value in rx-wlan script line 21 inside your bin directory.
To decrease induced latency rise by this you can try using a higher samplerate in line 17 and/or a lower frames in line 16 on both systems. Refer to [Linux Audio Wiki FAQ](https://wiki.linuxaudio.org/faq/start#qhow_to_set_up_the_jack_audio_server_jackd) for more details.
Watch for xruns by executing the runtime scripts piped like this: `rx-wlan && tail -f jack*.log | grep xrun`

## Contribution and Donation
Feel free to spread the work, fork or contribute by other means to this project and its resources. Always remember to make a donation to developers and maintainers.

