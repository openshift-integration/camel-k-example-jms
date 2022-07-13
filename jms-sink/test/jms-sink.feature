@require('org.apache.activemq:artemis-jms-client:2.11.0')
Feature: JMS sink

  Background:
    Given load variables application-test.properties
    Given JMS connection factory
      | type      | org.apache.activemq.artemis.jms.client.ActiveMQConnectionFactory |
      | brokerUrl | ${messaging.broker.url} |
    Given JMS destination: ${jms.destinationName}

  Scenario: Consume message from JMS
    Given Camel K integration jms-sink-example should be running
    Then expect JMS message with body: @matches('[^\\s]+ [^\\s]+ lives on [0-9]+ .+')@

  Scenario: Remove Camel-K resources
    Given delete Camel K integration jms-sink-example
