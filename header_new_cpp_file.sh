#!/bin/bash
# Requires a random generator

die() {
    echo $1
    exit 1
}

make_resources() {
    TMP_DIR=${CUR_DIR%/}/.tmp/
    mkdir -p $TMP_DIR
}

umake_resources() {
    if [ -n "${LICENSE_FILE}" ]; then
        rm -f ${LICENSE_FILE}
    fi
}

replace_parameter() {
    sed -i "s:$1:$2:g" $3
}

[ -z "$1" ] && die "Expected first argument to be path to the header filename"

CUR_DIR=$(dirname $0)
RANDOM_GENERATOR=${RANDOM_GENERATOR:-'openssl rand -hex 25'}
DELIM="// "
CURRENT_YEAR=$(date +%Y)

HEADER_RANDOM_TOKEN=$(${RANDOM_GENERATOR})
PATH_TO_HEADER=$1

case $2 in
    mit|MIT)
        LICENSE_FILE_TEMPLATE=${CUR_DIR%/}/license_templates/mit
        ;;
    *)
        LICENSE_FILE_TEMPLATE=
        ;;
esac


if [ -n "${LICENSE_FILE_TEMPLATE}" ] && [ -f ${LICENSE_FILE_TEMPLATE} ]; then
    make_resources

    LICENSE_FILE=${TMP_DIR%/}/${RANDOM}_header_license

    cp ${LICENSE_FILE_TEMPLATE} ${LICENSE_FILE}

    CURRENT_YEAR=$(date +%Y)

    replace_parameter "@@CURRENT_YEAR@@" "${CURRENT_YEAR}" "${LICENSE_FILE}"
    replace_parameter "^" "${DELIM}" "${LICENSE_FILE}"

    cat > ${PATH_TO_HEADER} << EOF
$(cat ${LICENSE_FILE})


#ifndef _HEADER_GUARD_${HEADER_RANDOM_TOKEN}
#define _HEADER_GUARD_${HEADER_RANDOM_TOKEN}

${DELIM} Add some code here

#endif
EOF

else

    cat > ${PATH_TO_HEADER} << EOF


#ifndef _HEADER_GUARD_${HEADER_RANDOM_TOKEN}
#define _HEADER_GUARD_${HEADER_RANDOM_TOKEN}

${DELIM} Add some code here

#endif
EOF

fi

umake_resources