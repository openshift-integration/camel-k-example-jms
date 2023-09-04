# Using JMS with Camel K: Consuming data from a JMS Broker

## Scenario

This example shows how to use JMS to connect to a message broker in order to consume messages from a JMS broker.

## Preparing the cluster

This example can be run on any OpenShift 4.3+ cluster or a local development instance (such as [CRC](https://github.com/code-ready/crc)). Ensure that you have a cluster available and login to it using the OpenShift `oc` command line tool.

You need to create a new project named `jms-examples` for running this example. This can be done directly from the OpenShift web console or by executing the command `oc new-project jms-examples` on a terminal window.

You need to install the Camel K operator in the `jms-examples` project. To do so, go to the OpenShift 4.x web console, login with a cluster admin account and use the OperatorHub menu item on the left to find and install **"Red Hat Integration - Camel K"**. You will be given the option to install it globally on the cluster or on a specific namespace.
If using a specific namespace, make sure you select the `jms-examples` project from the dropdown list.
This completes the installation of the Camel K operator (it may take a couple of minutes).

When the operator is installed, from the OpenShift Help menu ("?") at the top of the WebConsole, you can access the "Command Line Tools" page, where you can download the **"kamel"** CLI, that is required for running this example. The CLI must be installed in your system path.

Refer to the **"Red Hat Integration - Camel K"** documentation for a more detailed explanation of the installation steps for the operator and the CLI.

You can use the following section to check if your environment is configured properly.

## Requirements

A messaging broker is required for running the examples, but it is not necessary for going through this example. The text and code comments will highlight the relevant parts.

**OpenShift CLI ("oc")**

The OpenShift CLI tool ("oc") will be used to interact with the OpenShift cluster.

**Connection to an OpenShift cluster**

In order to execute this demo, you will need to have an OpenShift cluster with the correct access level, the ability to create projects and install operators as well as the Apache Camel K CLI installed on your local system.

**Apache Camel K CLI ("kamel")**

Apart from the support provided by the VS Code extension, you also need the Apache Camel K CLI ("kamel") in order to access all Camel K features.

### Optional Requirements

The following requirements are optional. They don't prevent the execution of the demo, but may make it easier to follow.

**VS Code Extension Pack for Apache Camel**

The VS Code Extension Pack for Apache Camel by Red Hat provides a collection of useful tools for Apache Camel K developers, such as code completion and integrated lifecycle management. They are **recommended** for the tutorial, but they are **not** required.

You can install it from the VS Code Extensions marketplace.

## Preparing the message broker

We assume you already have a message broker up and running. 
If it's not the case, you can simply follow **"Creating a Message Broker with Red Hat Integration - AMQ Broker on OpenShift"** or easily create a new instance on [Openshift Online](https://www.openshift.com/products/online/). You can also deploy any other compatible message broker instance through a wizard using the _+Add_ button on your **Openshift Console**.

Please note that there are different messaging protocols with their own client, configurations and characteristics. This guide shows the configuration for the most commonly used open source ones, however, the process should be similar for all the others.

## Creating a Message Broker with Red Hat Integration - AMQ Broker on OpenShift

First, let's create a new project (namespace) in the OpenShift cluster where we will set up the messaging broker:

```
oc new-project jms-examples-messaging-broker
```

Next, we need to install the Red Hat Integration - AMQ Broker operator to manage the lifecycle of our messaging broker:

Navigate to Operators > OperatorHub.
Search for **"Red Hat Integration - AMQ Broker for RHEL 8 (Multiarch)"** in the OperatorHub catalog. 
Click on the operator and then click Install. Make sure you select the `jms-examples-messaging-broker` project from the dropdown list.
Wait for the operator to be installed. You can check the status in the Operators > Installed Operators section.

After operator is installed and running on the project, we will proceed to create the broker instance:

```
oc create -f jms-source/test/infra/amq-broker-instance.yaml
```

To ensure that the AMQ Broker instance is created successfully, you can use the following command:

```
oc get activemqartemises
```

## Configuration File

The example contains a [configuration file](configs/application.properties) which has the set of mimimum required properties in order to the JMS example to run. When using a the JMS component, it is necessary to inform how the connection to the message broker will be made. This example is based on [Apache Camel's JMS](https://camel.apache.org/components/latest/jms-component.html) component. When using the AMQP 1.0 protocol with the Apache Qpid JMS client you will have to provide the connection configuration property `quarkus.qpid-jms.url`.

If you followed the section **"Creating a Message Broker with Red Hat Integration - AMQ Broker on OpenShift"**, you do not need to edit the file. Otherwise, you **must** edit the file and provide your broker host and port.

The second set of parameters that may need to be adjusted are the `destination type`, which is used to inform whether a `queue` or a `topic` will be used and the destination name. These two configurations are referenced in the component configuration (i.e: using `{{jms.destinationType}}` and `{{jms.destinationName}}` respectively).

## Understanding the Example

The example generates consumes messages published on to the message broker. To understand the example, please access the [source code](JmsSourceExample.java).

## Preparing the project

```
oc project jms-examples
```

```
oc create configmap jms-source-config --from-file jms-source/configs/application.properties
```

## Runtime Considerations

The JMS is a flexible standard, therefore, users are free to choose the message broker, protocol and clients that are suitable for their solution. This example demonstrates how to use the Apache QPid JMS client with the client dependency: `mvn:org.amqphub.quarkus:quarkus-qpid-jms`.

## Running the Example

To run the project you can use:

```
kamel run --config configmap:jms-source-config -d mvn:org.amqphub.quarkus:quarkus-qpid-jms --dev jms-source/JmsSourceExample.java
```

You should see an output like the following:

```
...
[1] 2023-07-26 14:38:23,619 INFO  [info] (Camel (camel-1) thread #1 - JmsConsumer[person]) Exchange[ExchangePattern: InOnly, BodyType: String, Body: Eusebio Nitzsche lives on 04307 Kirlin Pine]
[1] 2023-07-26 14:38:23,624 INFO  [info] (Camel (camel-1) thread #1 - JmsConsumer[person]) Exchange[ExchangePattern: InOnly, BodyType: String, Body: Jung Rempel lives on 758 Reynolds Orchard]
[1] 2023-07-26 14:38:23,625 INFO  [info] (Camel (camel-1) thread #1 - JmsConsumer[person]) Exchange[ExchangePattern: InOnly, BodyType: String, Body: Concepcion Lemke lives on 367 Leeann Stream]
[1] 2023-07-26 14:38:23,626 INFO  [info] (Camel (camel-1) thread #1 - JmsConsumer[person]) Exchange[ExchangePattern: InOnly, BodyType: String, Body: Mr. Lovie Trantow lives on 6444 Davis Prairie]
...
```

## Cleanup

To clean up all the resources created during this setup, you need to delete both projects (namespaces). Run the following commands:

```
oc delete project jms-examples-messaging-broker
oc delete project jms-examples
```
