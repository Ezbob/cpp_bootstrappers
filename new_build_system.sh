#!/bin/bash

die() {
    echo "Error: $1"
    unmake_resources
    exit 1
}

unmake_resources() {
    if [ -n "${TEMP_DIR}" ]; then
        2>/dev/null rm -rf ${TEMP_DIR}
    fi
}

make_resources() {
    mkdir -p ${TEMP_DIR}
}

replace_parameter() {
    sed -i "s:$1:$2:g" $3
}

get_input() {
    local PROMPT=$1
    local DEFAULT=$2
    local VARIABLE=""

    read -p "${PROMPT} [${DEFAULT}] " VARIABLE

    if [ -n "${VARIABLE}" ]; then
        echo ${VARIABLE}
    else
        echo ${DEFAULT}
    fi
}

OUT_DIR=$(realpath ".")

if [ -n "$1" ]; then
    OUT_DIR=$1
fi

[ ! -d "$OUT_DIR" ] && die "'$OUT_DIR' is not a directory"

CUR_DIR=$(dirname $0)
TEMPLATE_DIR=${CUR_DIR}/build_sys_templates
TEMP_DIR=${CUR_DIR}/.tmp/${RANDOM}build_sys_temp${RANDOM}
CURRENT_YEAR=$(date +%Y)

PROJECT_NAME=$(get_input "Project name ?" "Untitled")
PROJECT_DESCRIPTION=$(get_input "Project description ?")

echo "Copying templates over to '${OUT_DIR}'..."
make_resources

cd ${TEMPLATE_DIR} && cp -r . ${TEMP_DIR%/}/ && cd - 2> /dev/null > /dev/null

ALL_REPLACE_TEMPLATES_FILES=$(find ${TEMP_DIR} -type f)

replace_parameter "@@CURRENT_YEAR@@" "${CURRENT_YEAR}" "${ALL_REPLACE_TEMPLATES_FILES}"
replace_parameter "@@PROJECT_NAME@@" "${PROJECT_NAME}" "${ALL_REPLACE_TEMPLATES_FILES}"
replace_parameter "@@PROJECT_DESCRIPTION@@" "${PROJECT_DESCRIPTION}" "${ALL_REPLACE_TEMPLATES_FILES}"

cd ${TEMP_DIR} && cp -r -n . ${OUT_DIR%/}/ && cd - 2> /dev/null > /dev/null

unmake_resources

echo "Done."