#!/bin/sh

# delete secret
oc delete configmap jms-source-config -n ${YAKS_NAMESPACE}
