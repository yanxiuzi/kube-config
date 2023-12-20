KEY_FILE=ca.key
CERT_FILE=ca.crt
HOST=spatial-dim-6.org
CERT_NAME=x509-secret


openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}" -addext "subjectAltName = DNS:${HOST}"

kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}
