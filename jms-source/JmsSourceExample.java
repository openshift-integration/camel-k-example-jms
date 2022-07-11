// camel-k: language=java
// camel-k: dependency=camel:camel-quarkus-jms

/*
 * The above statements provide information required for running the example. This includes
 * the metadata informing the language used by this code and the dependencies used by
 * Camel K to run this example.
 * As for the dependencies, these are:
 * - camel-quarkus-jms which is from Camel, thus resolved automatically (hence the prefix notation "camel:")
 */

import org.apache.camel.builder.RouteBuilder;

public class JmsSourceExample extends RouteBuilder {
  @Override
  public void configure() throws Exception {
      /*
       * Explanation, method by method:
       *
       * - from("jms:{{jms.destinationType}}:{{jms.destinationName}}")
       * Consumes data from the JMS destination configured on the configuration
       * file
       *
       * - to("log:info")
       * Logs the generated fake person name and address to the logger using the info level
       *
       */
      from("jms:{{jms.destinationType}}:{{jms.destinationName}}")
        .to("log:info");
  }
}
