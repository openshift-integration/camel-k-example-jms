Using JMS with Camel K: Producing data to a JMS Broker
============


Introduction
----

This example shows how to use JMS to connect to a message broker in order to produce messages to a JMS broker.


Initial Considerations
----

There are different messaging protocols, which with their own client, configurations and characteristics. This guide shows the configuration for the most commonly used open source ones, however, the process should be similar for all the others. When client-specific details are relevant, they will be noted in the text and/or in comments in the example code.


Pre-requisites
----

A messaging broker is required for running the examples, but it is not necessary for going through this example. The text and code comments will highlight the relevant parts.

Configuration File
----

The example contains a [configuration file](configs/application.properties) which has the set of mimimum required properties in order to the JMS example to run.

When using a the JMS component, it necessary to inform how the connection to the message broker will be made. Specifically, this means configuring the "connection factory" class and the address of the message broker.

This example is based on [Apache Camel's JMS](https://camel.apache.org/components/latest/jms-component.html) component. As such we can use the Spring Boot auto-configuration for convenience and adjust the properties `camel.component.jms.connection-factory` to set the connection factory.

Setting the message broker address is specific to the JMS client being used. When using the AMQP 1.0 protocol with the Apache Qpid JMS client, this is done through the property `camel.component.jms.connection-factory.remoteURI`. When using the Apache Artemis CORE protocol, this is done via the property `camel.component.jms.connection-factory.brokerURL`.

*Note*: the configuration file contains commented examples for both properties.

The second set of parameters that may need to be adjusted are the `destination type`, which is used to inform whether a `queue` or a `topic` will be used and the destination name. These two configurations are referenced in the component configuration (i.e: using `{{jms.destinationType}}` and `{{jms.destinationName}}` respectively).


Understanding the Example
----

The example generates fake person data at a regular interval and sends that information to the message broker. To understand the example, please access the [source code](JmsSinkExample.java).


Runtime Considerations
----

The JMS is a flexible standard, therefore, users are free to choose the message broker, protocol and clients that are suitable for their solution.

This example demonstrates how the Apache Artemis Core Client or the Apache QPid JMS client can be used to access a compatible message broker speaking the Apache Artemis Core protocol (such as Apache Artemis) or AMQP 1.0 (such as Apache ActiveMQ, Apache Artemis, Azure Service Bus and others).

To use this example with the Apache Artemis Core Client, the respective client dependency must be informed (i.e.: `mvn:org.apache.activemq:artemis-jms-client-all:2.17.0`).

To use this example with the Apache QPid JMS client, the following client dependency is used: `mvn:org.apache.qpid:qpid-jms-client:jar:1.0.0`.


Preparing the Environment
----

Create the project:

```
oc create project jms-examples
oc create configmap jms-sink-config --from-file configs/application.properties
```


Running the Example: Using Apache Artemis Core Client
----

To run the project using the Apache Artemis Core Client, use:

```
kamel run --configmap jms-sink-config -d mvn:org.apache.activemq:artemis-jms-client-all:2.17.0 --dev -t builder.verbose=true JmsSinkExample.java
```


Running the Example: Using Apache Qpid
----

To run the project using the Apache QPid JMS client, use:

```
kamel run --configmap jms-sink-config -d mvn:org.apache.qpid:qpid-jms-client:jar:1.0.0 --dev -t builder.verbose=true JmsSinkExample.java
```