# Using JMS with Camel K: Consuming data from a JMS Broker



## Scenario

This example shows how to use JMS to connect to a message broker in order to consume messages from a JMS broker.


## Requirements


A messaging broker is required for running the examples, but it is not necessary for going through this example. The text and code comments will highlight the relevant parts.

<a href='didact://?commandId=vscode.didact.validateAllRequirements' title='Validate all requirements!'><button>Validate all Requirements at Once!</button></a>

**OpenShift CLI ("oc")**

The OpenShift CLI tool ("oc") will be used to interact with the OpenShift cluster.

[Check if the OpenShift CLI ("oc") is installed](didact://?commandId=vscode.didact.cliCommandSuccessful&text=oc-requirements-status$$oc%20help&completion=Checked%20oc%20tool%20availability "Tests to see if `oc help` returns a 0 return code"){.didact}

*Status: unknown*{#oc-requirements-status}

**Connection to an OpenShift cluster**

In order to execute this demo, you will need to have an OpenShift cluster with the correct access level, the ability to create projects and install operators as well as the Apache Camel K CLI installed on your local system.

[Check if you're connected to an OpenShift cluster](didact://?commandId=vscode.didact.requirementCheck&text=cluster-requirements-status$$oc%20get%20project%20camel-k-jdbc&completion=OpenShift%20is%20connected. "Tests to see if `oc get project` returns a result"){.didact}

*Status: unknown*{#cluster-requirements-status}

**Apache Camel K CLI ("kamel")**

Apart from the support provided by the VS Code extension, you also need the Apache Camel K CLI ("kamel") in order to access all Camel K features.

[Check if the Apache Camel K CLI ("kamel") is installed](didact://?commandId=vscode.didact.requirementCheck&text=kamel-requirements-status$$kamel%20version$$Camel%20K%20Client&completion=Apache%20Camel%20K%20CLI%20is%20available%20on%20this%20system. "Tests to see if `kamel version` returns a result"){.didact}

*Status: unknown*{#kamel-requirements-status}

### Optional Requirements

The following requirements are optional. They don't prevent the execution of the demo, but may make it easier to follow.

**VS Code Extension Pack for Apache Camel**

The VS Code Extension Pack for Apache Camel by Red Hat provides a collection of useful tools for Apache Camel K developers, such as code completion and integrated lifecycle management. They are **recommended** for the tutorial, but they are **not** required.

You can install it from the VS Code Extensions marketplace.

[Check if the VS Code Extension Pack for Apache Camel by Red Hat is installed](didact://?commandId=vscode.didact.extensionRequirementCheck&text=extension-requirement-status$$redhat.apache-camel-extension-pack&completion=Camel%20extension%20pack%20is%20available%20on%20this%20system. "Checks the VS Code workspace to make sure the extension pack is installed"){.didact}

*Status: unknown*{#extension-requirement-status}

## Preparing the project

```
oc new-project jms-examples
```

([^ execute](didact://?commandId=vscode.didact.sendNamedTerminalAString&text=newTerminal$$oc%20new-project%20jms-examples))


```
oc create configmap jms-source-config --from-file jms-source/configs/application.properties
```

([^ execute](didact://?commandId=vscode.didact.sendNamedTerminalAString&text=newTerminal$$oc%20create%20configmap%20jms-source-config%20--from-file%20jms-source/configs/application.properties))


## Preparing the message broker

We assume you already have a message broker up and running. If it's not the case, you can easily create a new instance on [Openshift Online](https://www.openshift.com/products/online/) or [create your own using AMQ Online](https://access.redhat.com/documentation/en-us/red_hat_amq/2021.q1/html/installing_and_managing_amq_online_on_openshift/index). You can also deploy any other compatible message broker instance through a wizard using the _+Add_ button on your **Openshift Console**.

Please note that there are different messaging protocols, which with their own client, configurations and characteristics. This guide shows the configuration for the most commonly used open source ones, however, the process should be similar for all the others. When client-specific details are relevant, they will be noted in the text and/or in comments in the example code.

## Configuration File

The example contains a [configuration file](configs/application.properties) which has the set of mimimum required properties in order to the JMS example to run.

When using a the JMS component, it necessary to inform how the connection to the message broker will be made. Specifically, this means configuring the "connection factory" class and the address of the message broker.

This example is based on [Apache Camel's JMS](https://camel.apache.org/components/latest/jms-component.html) component. As such we can use the Spring Boot auto-configuration for convenience and adjust the properties `camel.component.jms.connection-factory` to set the connection factory.

Setting the message broker address is specific to the JMS client being used. When using the AMQP 1.0 protocol with the Apache Qpid JMS client, this is done through the property `camel.component.jms.connection-factory.remoteURI`. When using the Apache Artemis CORE protocol, this is done via the property `camel.component.jms.connection-factory.brokerURL`.

*Note*: the configuration file contains commented examples for both properties.

The second set of parameters that may need to be adjusted are the `destination type`, which is used to inform whether a `queue` or a `topic` will be used and the destination name. These two configurations are referenced in the component configuration (i.e: using `{{jms.destinationType}}` and `{{jms.destinationName}}` respectively).


## Understanding the Example

The example generates consumes messages published on to the message broker. To understand the example, please access the [source code](JmsSourceExample.java).


## Runtime Considerations


The JMS is a flexible standard, therefore, users are free to choose the message broker, protocol and clients that are suitable for their solution.

This example demonstrates how the Apache Artemis Core Client or the Apache QPid JMS client can be used to access a compatible message broker speaking the Apache Artemis Core protocol (such as Apache Artemis) or AMQP 1.0 (such as Apache ActiveMQ, Apache Artemis, Azure Service Bus and others).

To use this example with the Apache Artemis Core Client, the respective client dependency must be informed (i.e.: `mvn:org.apache.activemq:artemis-jms-client-all:2.17.0`).

To use this example with the Apache QPid JMS client, the following client dependency is used: `mvn:org.apache.qpid:qpid-jms-client:jar:1.0.0`.


## Running the Example: Using Apache Artemis Core Client


To run the project using the Apache Artemis Core Client, use:


```
kamel run --configmap jms-source-config -d mvn:org.apache.activemq:artemis-jms-client-all:2.17.0 --dev JmsSourceExample.java
```

([^ execute](didact://?commandId=vscode.didact.sendNamedTerminalAString&text=newTerminal$$kamel%20run%20--configmap%20jms-source-config%20-d%20mvn:org.apache.activemq:artemis-jms-client-all:2.17.0%20--dev%20JmsSourceExample.java))


## Running the Example: Using Apache Qpid


To run the project using the Apache QPid JMS client, use:


```
kamel run --configmap jms-source-config -d mvn:org.apache.qpid:qpid-jms-client:jar:1.0.0 --dev JmsSourceExample.java
```

([^ execute](didact://?commandId=vscode.didact.sendNamedTerminalAString&text=newTerminal$$kamel%20run%20--configmap%20jms-source-config%20-d%20mvn:org.apache.qpid:qpid-jms-client:jar:1.0.0%20--dev%20JmsSourceExample.java))
