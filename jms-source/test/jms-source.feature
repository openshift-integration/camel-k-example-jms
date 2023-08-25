@require('org.apache.activemq:artemis-jms-client:2.21.0')
Feature: JMS source

  Background:
    Given load variables application-test.properties

  Scenario: Publish message on JMS
    Given Camel K integration jms-source-example should be running
    Given JMS connection factory
      | type      | org.apache.activemq.artemis.jms.client.ActiveMQConnectionFactory |
      | brokerUrl | ${messaging.broker.url} |
    Given JMS destination: ${jms.destinationName}
    When send JMS message with body: Alf lives on Melmac
    Then Camel K integration jms-source-example should print Alf lives on Melmac

  Scenario: Remove Camel-K resources
    Given delete Camel K integration jms-source-example
