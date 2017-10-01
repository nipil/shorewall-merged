#!/usr/bin/env bash

TARGETS="shorewall{,6}"

SSH_OPTIONS="-o BatchMode=yes -o ClearAllForwardings=yes"

function info {
	echo "INFO: ${@}"
}

function err {
	>&2 echo "ERROR: ${@}"
}

function apply_full {
    local __HOST=${1} __TARGET
    info "Processing host" ${__HOST}
    for __TARGET in $(eval echo ${TARGETS})
    do
        info "Pushing ${__TARGET} configuration"
        scp ${SSH_OPTIONS} -r build/${__TARGET} root@${1}:/etc/
        [ ${?} -eq 0 ] || { err "Could not copy files to ${1}" ; return ; }
    done
    for __TARGET in $(eval echo ${TARGETS})
    do
        info "Restarting ${__TARGET}" ${__HOST}
        ssh ${SSH_OPTIONS} root@${1} ${__TARGET} restart
        [ ${?} -eq 0 ] || { err "Could not restart ${__TARGET} on ${1}" ; return ; }
    done
}

for TARGET in "${@}"
do
    apply_full ${TARGET}
done
