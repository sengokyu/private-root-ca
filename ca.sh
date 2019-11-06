#!/bin/bash

PASS_PHRASE=$(ps aux | shasum)
CA_ROOT=./PrivateRootCA

usage() {
    echo Usage: CA.sh command [ command_opts ]
    echo
}

name_of_base() {
    date +%Y%j%H%M
}

init() {
        mkdir -p ${CA_ROOT}/certs
        mkdir -p ${CA_ROOT}/crl
        mkdir -p ${CA_ROOT}/newcerts
        mkdir -p ${CA_ROOT}/private
        mkdir private
        mkdir export
        mkdir request
        touch ${CA_ROOT}/index.txt
        touch ${CA_ROOT}/index.txt.attr
        echo 00 > ${CA_ROOT}/serial

        keyfile=${CA_ROOT}/private/cakey.pem
        certfile=${CA_ROOT}/cacert.pem

        ## -x509 option outputs a self signed certificate instead of CSR
        ##
        openssl req \
            -config openssl.cnf \
            -new \
            -utf8 \
            -x509 \
            -newkey rsa:2048 \
            -keyout $keyfile \
            -out $certfile \
            -days 9131 \
            -extensions v3_ca

        chmod 500 ${CA_ROOT}/private
        chmod 400 $keyfile
        chmod 444 $certfile
}

privkey() {
    output=private/${1}.pem
    tmp=private/${1}.tmp.pem

    openssl genrsa -out $tmp -aes256 -passout "pass:$2"
    openssl rsa -in $tmp -out $output -passin "pass:$2"
    rm $tmp

    echo $output
}

request() {
    output=request/$(basename $1 .pem).pem

    openssl req -config openssl.cnf -new -utf8 -key $1 -out $output

    echo $output
}

sign() {
    openssl ca -config openssl.cnf -utf8 -extensions $2 -in $1 -batch

    echo ${CA_ROOT}/newcerts/$(cat ${CA_ROOT}/serial.old).pem
}

export() {
    output=export/$(basename $1 .pem).pfx

    openssl pkcs12 -export -inkey $1 -in $2 -out $output

    echo $output
}

revoke() {
    openssl ca -config openssl.cnf -revoke $1
}


case "$1" in
    init)
        init
        ;;
    server)
        f=$(name_of_base)

        key=$(privkey $f $PASS_PHRASE)
        csr=$(request $key)
        cert=$(sign $csr v3_server)
        export $key $cert
        ;;
    client)
        f=$(name_of_base)

        key=$(privkey $f $PASS_PHRASE)
        csr=$(request $key)
        cert=$(sign $csr v3_client)
        export $key $cert
        ;;
    privkey)
        privkey $2 $3
        ;;
    request)
        request $2
        ;;
    signserver)
        sign $2 v3_server
        ;;
    signclient)
        sign $2 v3_client
        ;;
    export)
        export $2 $3
        ;;
    revoke)
        revoke $2
        ;;
    *)
        usage
        ;;
esac
