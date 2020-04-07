#!/bin/bash
#
# script for running Wi-Fi IEM on iem-rx

## Application setup
# jackd settings
RTON=-R
PRIO=-P84
WAIT=-t2000
PRTS=-p16
VERB=-v
ADRV=-dalsa
ADEV=-dhw:0
MODE=-P
PCNT=-n2
FCNT=-p128
RATE=-r96000
INPT=-i0
OUPT=-o2
# zita-n2j settings
BUFF="--buff 3" # more buffer for stability
CHAN="--chan 1,2"
INFO=--info
MCIP=224.0.0.3
PORT=30042
ZBIF=wlan0

# kill old processes
killall -9 zita-n2j
killall -9 jackd

# Set the CPU scaling governor to performance
for cpu in /sys/devices/system/cpu/cpu[0-9]*; do echo -n performance \
| sudo tee $cpu/cpufreq/scaling_governor; done
sleep 1

## Run applications
# Run jackd and log verbose output
jackd $RTON $PRIO $WAIT $PRTS $VERB $ADRV $ADEV $MODE $PCNT $FCNT $RATE $INPT $OUPT &>jack-$ZBIF$FCNT$RATE.log &
sleep 2

# Start zita-n2j and connect jack ports
zita-n2j $BUFF $CHAN $INFO $MCIP $PORT $ZBIF &>zn2j-$ZBIF$FCNT$RATE.log &
sleep 1
jack_connect zita-n2j:out_1 system:playback_1
jack_connect zita-n2j:out_2 system:playback_2

exit 0
