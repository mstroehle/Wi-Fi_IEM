#!/bin/bash
#
# script for running Wi-Fi IEM on iem-tx (using a wireless router over eth0)

## Application setup
# jackd settings
RTON=-R
PRIO=-P84
WAIT=-t2000
PRTS=-p16
VERB=-v
ADRV=-dalsa
ADEV=-dhw:0
MODE=-C
PCNT=-n2
FCNT=-p128
RATE=-r96000
INPT=-i2
OUPT=-o0
# zita-j2n settings
CHAN="--chan 2"
SMPL=--16bit
MMTU="--mtu 1500"
HOPS="--hops 1"
MCIP=224.0.0.3
PORT=30042
ZBIF=eth0

# kill processes
killall -9 zita-j2n
killall -9 jackd

# Set the CPU scaling governor to performance
for cpu in /sys/devices/system/cpu/cpu[0-9]*; do echo -n performance \
| sudo tee $cpu/cpufreq/scaling_governor; done
sleep 1

## Run applications
# Run jackd and log verbose output
jackd $RTON $PRIO $WAIT $PRTS $VERB $ADRV $ADEV $MODE $PCNT $FCNT $RATE $INPT $OUPT &>jack-$ZBIF$FCNT$RATE.log &
sleep 2

# Start zita-j2n and connect jack ports
zita-j2n $CHAN $SMPL $MMTU $HOPS $MCIP $PORT $ZBIF &>zj2n-$ZBIF$FCNT$RATE.log &
sleep 1
jack_connect system:capture_1 zita-j2n:in_1
jack_connect system:capture_2 zita-j2n:in_2

exit 0
