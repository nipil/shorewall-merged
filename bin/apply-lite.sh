#!/usr/bin/env bash

TARGETS="shorewall{,6}"

function info {
	echo "INFO: ${@}"
}

function err {
	>&2 echo "ERROR: ${@}"
}

function apply_lite {
    local __HOST=${1} __TARGET
    info "Processing host" ${__HOST}
    for __TARGET in $(eval echo ${TARGETS})
    do
        info "Applying " ${__TARGET}
        ${__TARGET} remote-restart -c build/${__TARGET} ${__HOST}
    done
}

for TARGET in "${@}"
do
    apply_lite ${TARGET}
done
