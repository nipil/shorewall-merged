#!/usr/bin/env bash

TARGETS="shorewall{,6}"
declare -A HOSTINDEX=(["shorewall"]=2 ["shorewall6"]=3)
declare -A ZONETYPE=(["shorewall"]="ipv4" ["shorewall6"]="ipv6")
declare -A IFOPTS=(["shorewall"]=3 ["shorewall6"]=4)

function info {
	echo "INFO: ${@}"
}

function err {
	>&2 echo "ERROR: ${@}"
}

function banner {
    echo -e "\n#\n# ${@}\n#\n"
}

function append {
    local __SRC=${1} __TARGET=${2}
    if [ -f ${__SRC} ]
    then
        info "append" ${__SRC} ${__TARGET}
        banner "from ${__SRC}" >> ${__TARGET}
        cat ${__SRC} >> ${__TARGET}
    else
        err ${__SRC} "not found"
    fi
}

function generate_source {
    local __TARGET=${1} __SRC=${2} __PATH __FILE
    for __PATH in $(find src/${__SRC} -type f -regex '[^.]*')
    do
        __FILE=$(basename ${__PATH})
        append ${__PATH} build/${__TARGET}/${__FILE}
    done
}

function generate_target {
    local __TARGET=${1}
    mkdir -p build/${__TARGET}
    generate_source ${__TARGET} "raw-common"
    generate_source ${__TARGET} "raw-${__TARGET}"
    append src/raw-${__TARGET}/${__TARGET}.conf build/${__TARGET}/${__TARGET}.conf
}

function generate_addresses {
    local __TARGET=${1}
    local __INDEX=${HOSTINDEX[${1}]}
    local __SRC=src/processed/addresses
    local __DST=build/${__TARGET}/params

    info "generate_addresses" ${__DST} "using column" ${__INDEX} "from" ${__SRC}
    banner "from ${__SRC}" >> ${__DST}
    cat ${__SRC} | \
        egrep -v '^[[:space:]]*(|#.*)$' | \
        awk "{ print \$1 \"=\" \$${__INDEX} }" | \
        grep -v '=-$' >> ${__DST}
}

function generate_zones {
    local __TARGET=${1}
    local __TYPE=${ZONETYPE[${1}]}
    local __SRC=src/processed/interfaces
    local __DST=build/${__TARGET}/zones

    info "generate_zones" ${__DST} "using column" ${__INDEX} "from" ${__SRC}
    banner "from ${__SRC}" >> ${__DST}
    cat ${__SRC} | \
        egrep -v '^[[:space:]]*(|#.*)$' | \
        awk "{ print \$1  \" \" \"${__TYPE}\" }" >> ${__DST}
}

function generate_interfaces {
    local __TARGET=${1}
    local __INDEX=${IFOPTS[${1}]}
    local __SRC=src/processed/interfaces
    local __DST=build/${__TARGET}/interfaces

    info "generate_interfaces" ${__DST} "using column" ${__INDEX} "from" ${__SRC}
    banner "from ${__SRC}" >> ${__DST}
    cat ${__SRC} | \
        egrep -v '^[[:space:]]*(|#.*)$' | \
        awk "{ print \$1 \" \" \$2 \" \" \$${__INDEX} }" >> ${__DST}
}

function run {
    local __TARGET
    rm -Rf build
    for __TARGET in $(eval echo ${TARGETS})
    do
        generate_target ${__TARGET}
        generate_zones ${__TARGET}
        generate_addresses ${__TARGET}
        generate_interfaces ${__TARGET}
    done
}

run
