# Using JMS with Camel K: Producing data to a JMS Broker

## Scenario

This example shows how to use JMS to connect to a message broker in order to produce messages to a JMS broker.

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

## Preparing the project

```
oc project jms-examples
```

```
oc create configmap jms-sink-config --from-file jms-sink/configs/application.properties
```

## Preparing the message broker

We assume you already have a message broker up and running. If it's not the case, you can easily create a new instance on [Openshift Online](https://www.openshift.com/products/online/) or [create your own using AMQ Online](https://access.redhat.com/documentation/en-us/red_hat_amq/2021.q1/html/installing_and_managing_amq_online_on_openshift/index). You can also deploy any other compatible message broker instance through a wizard using the _+Add_ button on your **Openshift Console**.

Please note that there are different messaging protocols with their own client, configurations and characteristics. This guide shows the configuration for the most commonly used open source ones, however, the process should be similar for all the others.

## Configuration File

The example contains a [configuration file](configs/application.properties) which has the set of mimimum required properties in order to the JMS example to run. When using a the JMS component, it is necessary to inform how the connection to the message broker will be made. This example is based on [Apache Camel's JMS](https://camel.apache.org/components/latest/jms-component.html) component. When using the AMQP 1.0 protocol with the Apache Qpid JMS client you will have to provide the connection configuration property `quarkus.qpid-jms.url`.

*Note*: you must edit the file and provide your broker host and port.

The second set of parameters that may need to be adjusted are the `destination type`, which is used to inform whether a `queue` or a `topic` will be used and the destination name. These two configurations are referenced in the component configuration (i.e: using `{{jms.destinationType}}` and `{{jms.destinationName}}` respectively).

## Understanding the Example

The example generates fake person data at a regular interval and sends that information to the message broker. To understand the example, please access the [source code](JmsSinkExample.java).

## Runtime Considerations

The JMS is a flexible standard, therefore, users are free to choose the message broker, protocol and clients that are suitable for their solution. This example demonstrates how to use the Apache QPid JMS client with the client dependency: `mvn:org.amqphub.quarkus:quarkus-qpid-jms`.

## Running the Example

To run the project you can use:

```
kamel run --config configmap:jms-sink-config -d mvn:org.amqphub.quarkus:quarkus-qpid-jms --dev jms-sink/JmsSinkExample.java
```

You should see an output like the following:

```
...
[1] 2021-07-16 07:22:39,628 INFO  [info] (Camel (camel-1) thread #0 - timer://1000) Exchange[ExchangePattern: InOnly, BodyType: String, Body: Mrs. Kam Cronin lives on 20553 Devon Circles]
[1] 2021-07-16 07:22:40,933 INFO  [org.apa.qpi.jms.JmsConnection] (AmqpProvider :(1):[amqp://my-amqp-service:5672]) Connection ID:0c0192c9-e71d-4f43-bc97-e7fc8ee9dbac:1 connected to server: amqp://my-amqp-service:5672
[1] 2021-07-16 07:22:41,135 INFO  [info] (Camel (camel-1) thread #0 - timer://1000) Exchange[ExchangePattern: InOnly, BodyType: String, Body: Latina Morissette lives on 73051 Phillip Village]
...
```