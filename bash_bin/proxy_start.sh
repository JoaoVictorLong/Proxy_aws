echo "Starting connection tunnel with the server"
ssh -D 20327 -f -C -q -N -i ./key/proxy-server-key ec2-user@13.231.129.89 -vv
