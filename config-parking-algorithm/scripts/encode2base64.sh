
if [ $# != 2 ] ; then
echo "USAGE: $0 src_file dst_file"
echo " e.g.: $0 call.wav call.base64"
exit 1;
fi

if [ -e $2 ]; then 

read -r -p "file $2 exists, ensure to force cover? [Y/n] " input

case $input in
    [yY][eE][sS]|[yY])
	echo "Yes"
	echo {\"base\":{\"trace\":\"trace_foo\", \"ts\":\"`date +%s`\"}, \"voice\":\"`base64 -w 0 $1`\", \"voiceUrl\":\"\"} > $2
	;;

    [nN][oO]|[nN])
	echo "No"
	exit 0       
	;;

    *)
	echo "Invalid input..."
	exit 1
	;;
esac

else
	echo {\"base\":{\"trace\":\"trace_foo\", \"ts\":\"`date +%s`\"}, \"voice\":\"`base64 -w 0 $1`\", \"voiceUrl\":\"\"} > $2
fi

