#!/bin/sh

# delete secret
oc delete configmap jms-sink-config -n ${YAKS_NAMESPACE}
