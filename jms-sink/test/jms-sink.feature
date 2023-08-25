@require('org.apache.activemq:artemis-jms-client:2.21.0')
Feature: JMS sink

  Background:
    Given load variables application-test.properties

  Scenario: Consume message from JMS
    Given Camel K integration jms-sink-example should be running
    Given JMS connection factory
      | type      | org.apache.activemq.artemis.jms.client.ActiveMQConnectionFactory |
      | brokerUrl | ${messaging.broker.url} |
    Given JMS destination: ${jms.destinationName}
    Then expect JMS message with body: @matches('[^\\s]+ [^\\s]+ lives on [0-9]+ .+')@

  Scenario: Remove Camel-K resources
    Given delete Camel K integration jms-sink-example
