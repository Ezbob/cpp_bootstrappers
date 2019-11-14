#!/bin/bash

die() {
    echo $1
    umake_resources
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

[ -z "$1" ] && die "Expected first argument to be path to the implementation filename"
CUR_DIR=$(dirname $0)
DELIM="// "

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

    LICENSE_FILE=${TMP_DIR%/}/${RANDOM}_impl_license

    cp ${LICENSE_FILE_TEMPLATE} ${LICENSE_FILE}

    CURRENT_YEAR=$(date +%Y)

    replace_parameter "@@CURRENT_YEAR@@" "${CURRENT_YEAR}" ${LICENSE_FILE}
    replace_parameter "^" "${DELIM}" ${LICENSE_FILE}

    PATH_TO_IMPL=$1

    cat > ${PATH_TO_IMPL} << EOF

$(cat ${LICENSE_FILE})


${DELIM} Add you code here

EOF

else

    PATH_TO_IMPL=$1

    cat > ${PATH_TO_IMPL} << EOF


${DELIM} Add you code here

EOF

fi

umake_resources

