#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

SOURCE=$(dirname "$0")
ACTIVEMQ_VERSION=v1.0.14
URL="https://raw.githubusercontent.com/artemiscloud/activemq-artemis-operator/${ACTIVEMQ_VERSION}"

BROKER=$(kubectl get activemqartemis/artemis-broker -n ${YAKS_NAMESPACE} || echo "")

#check for existing amq-broker instance
if [ -z "$BROKER" ]; then

  # Install AMQ Artemis
  kubectl create -f "${URL}"/deploy/crds/broker_activemqartemis_crd.yaml
  kubectl create -f "${URL}"/deploy/crds/broker_activemqartemisaddress_crd.yaml
  kubectl create -f "${URL}"/deploy/crds/broker_activemqartemisscaledown_crd.yaml
  kubectl create -f "${URL}"/deploy/crds/broker_activemqartemissecurity_crd.yaml

  kubectl create -f "${URL}"/deploy/service_account.yaml
  kubectl create -f "${URL}"/deploy/role.yaml
  kubectl create -f "${URL}"/deploy/role_binding.yaml
  kubectl create -f "${URL}"/deploy/election_role.yaml
  kubectl create -f "${URL}"/deploy/election_role_binding.yaml

  kubectl create -f "${URL}"/deploy/operator_config.yaml
  kubectl create -f "${URL}"/deploy/operator.yaml

  # wait for operator to start
  kubectl wait pod -l name=activemq-artemis-operator --for condition=Ready --timeout=300s -n ${YAKS_NAMESPACE}

  # create AMQ broker
  kubectl create -f "${SOURCE}"/amq-broker-instance.yaml -n ${YAKS_NAMESPACE}

  # wait for broker to start
  kubectl wait activemqartemis/artemis-broker --for condition=Deployed --timeout=300s -n ${YAKS_NAMESPACE}

  kubectl create -f "${SOURCE}"/amq-address.yaml -n ${YAKS_NAMESPACE}
else
  echo "AMQ Broker instance already exists"
fi
