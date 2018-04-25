#!/bin/sh

#
# An example script for handling external power control.
# Modified from: https://github.com/wrouesnel/openipmi/blob/master/lanserv/ipmi_sim_chassiscontrol

# It's parameters are:
#
#  ipmi_sim_chassiscontrol <device> get [parm [parm ...]]
#  ipmi_sim_chassiscontrol <device> set [parm val [parm val ...]]
#
# where <device> is the particular target to reset and parm is either
# "power", "reset", or "boot".
#
# The output of the "get" is "<parm>:<value>" for each listed parm,
# and only power is listed, you cannot fetch reset.
# The output of the "set" is empty on success.  Error output goes to
# standard out (so it can be captured in the simulator) and the program
# returns an error.
#
# The values for power and reset are either "1" or "0".  Note that
# reset does a pulse, it does not set the reset line level.
#
# The value for boot is either "none", "pxe" or "default".

chassis_ctrl_path=/tmp/chassis


# Debug level logging messages
debug() {
    echo "[debug] $1" >&2
}

# Error level logging messages
err() {
    echo "[error] $1" >&2
}

# Get the power state.
get_power() {
    path="$chassis_ctrl_path/power"

    # If there is no power state yet, set the power state to "on".
    if [ ! -f "$path" ]; then
        echo "1" > "$path"
    fi

    value=`cat ${path}`
    echo "$value"
}

# Set the power state.
set_power() {
    path="$chassis_ctrl_path/power"
    echo $1 > "$path"
}








prog=$0

device=$1
if [ "x$device" = "x" ]; then
    err "No device given"
    exit 1;
fi
shift

op=$1
if [ "x$op" = "x" ]; then
    err "No operation given"
    exit 1
fi
shift


do_get() {
    while [ "x$1" != "x" ]; do
    case $1 in
        power)
            val=$(get_power)
        ;;

        boot)
            val=default
        ;;

        # Note that reset has no get

        *)
            err "Invalid parameter: $1"
            exit 1
        ;;
    esac

    echo "$1:$val"
    shift
    done
}

do_set() {
    while [ "x$1" != "x" ]; do
    parm="$1"
    shift
    if [ "x$1" = "x" ]; then
        err "No value present for parameter $parm"
        exit 1
    fi
    val="$1"
    shift

    case ${parm} in
        power)
            set_power ${val}
        ;;

        reset)
        ;;

        boot)
        case $val in
            none)
            ;;
            pxe)
            ;;
                cdrom)
            ;;
            bios)
                ;;
            default)
                   ;;
            *)
            err "Invalid boot value: $val"
            exit 1
            ;;
        esac
        ;;

            identify)
        interval=$val
        force=$1
        shift
        ;;

        *)
        err "Invalid parameter: $parm"
        exit 1
        ;;
    esac
    done
}

do_check() {
    # Check is not supported for chassis control
    exit 1
}

case $op in
    get)
    do_get $@
    ;;
    set)
    do_set $@
    ;;

    check)
    do_check $@
    ;;

*)
    err "Unknown operation: $op"
    exit 1
esac