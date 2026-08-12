
#!/bin/bash

FAILED=0

echo "=== SAS Midtier Lab Health Check ==="

echo
echo "Checking Apache service..."
systemctl is-active --quiet apache2
if [ $? -eq 0 ]; then
	echo "Apache: Running"
else
	echo "Apache: Down"
	FAILED=1
fi

echo
echo "Checking Tomcat service..."
systemctl is-active --quiet tomcat11
if [ $? -eq 0 ]; then
	echo "Tomcat: Running"
else
	echo "Tomcat: Down"
	FAILED=1
fi

echo
echo "Checking HTTP endpoint..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}\n" http://localhost)

echo "HTTP status: $HTTP_STATUS"

if [ "$HTTP_STATUS" -ne 200 ]; then
	FAILED=1
fi

echo
echo "Checking HTTPS proxy endpoint..." 
HTTPS_STATUS=$(curl -k -s -o /dev/null -w "%{http_code}\n" https://localhost/tomcat)

echo "HTTPS Proxy Status: $HTTPS_STATUS"
if [ "$HTTPS_STATUS" -ne 200 ]; then
	FAILED=1
fi

echo

if [ "$FAILED" -eq 0 ]; then
	echo "Overall Status: Healthy"
	exit 0
else
	echo "Overall Status: Unhealthy"
	exit 1
fi
