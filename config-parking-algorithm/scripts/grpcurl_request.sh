
if [ $# != 1 ] ; then
echo "USAGE: sh $0 request_json_file"
echo " e.g.: sh $0 test.json"
exit 1;
fi

json=`cat $1`

./grpcurl -plaintext -d @ 10.35.46.21:9397 service.VideoService/TaskAdd < $1
