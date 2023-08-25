#!/bin/sh

SOURCE=$(dirname "$0")

# create configmap from properties file
oc create configmap jms-sink-config --from-file "${SOURCE}"/../application-test.properties -n ${YAKS_NAMESPACE}
