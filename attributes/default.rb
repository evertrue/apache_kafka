# encoding: UTF-8
# Cookbook Name:: et_apache_kafka
# Attribute:: default
#

default["et_apache_kafka"]["version"] = "0.8.2.1"
default["et_apache_kafka"]["scala_version"] = "2.11"
default["et_apache_kafka"]["mirror"] = "http://apache.mirrors.tds.net/kafka"
# shasum -a 256 /tmp/kitchen/cache/kafka_2.11-0.8.2.1.tgz
default["et_apache_kafka"]["checksum"]["0.8.2.1"] = "9fb84546149b477bdbf167da8ca880a2c1199aeb24b2d5cd17aac0973ba4e54b"

default["et_apache_kafka"]["user"] = "kafka"
default["et_apache_kafka"]["setup_user"] = true

# heap options are set low to allow for local development
default["et_apache_kafka"]["kafka_heap_opts"] = "-Xmx512M -Xms256M"
default["et_apache_kafka"]["kafka_jvm_performance_opts"] = "-server -XX:+UseCompressedOops -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+CMSScavengeBeforeRemark -XX:+DisableExplicitGC -Djava.awt.headless=true"
default["et_apache_kafka"]["kafka_opts"] = ""

default["et_apache_kafka"]["jmx"]["port"] = ""
default["et_apache_kafka"]["jmx"]["opts"] = "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

default["et_apache_kafka"]["install_java"] = true

default["et_apache_kafka"]["install_dir"] = "/usr/local/kafka"
default["et_apache_kafka"]["data_dir"] = "/var/log/kafka"
default["et_apache_kafka"]["log_dir"] = "/var/log/kafka"
default["et_apache_kafka"]["bin_dir"] = "/usr/local/kafka/bin"
default["et_apache_kafka"]["config_dir"] = "/usr/local/kafka/config"

default["et_apache_kafka"]["service_style"] = "upstart"
# Currently only for upstart, the umask for the kafka server process
default["et_apache_kafka"]["umask"] = 007

# Kafka configuration settings are detailed here.
# https://kafka.apache.org/08/configuration.html
# Required settings are specified below as they may need special handling
# by wrapper cookbooks.  All others are fixed at default levels.  This
# allows wrapper cookbooks to override a value then subsequently remove
# the override and allow the host to fall back to the default value.
default["et_apache_kafka"]["broker.id"] = nil
default["et_apache_kafka"]["port"] = 9092
default["et_apache_kafka"]["zookeeper.connect"] = "localhost:2181/kafka"

# Check in /var/log/kafka/server.log for invalid entries
#
default["et_apache_kafka"]["conf"]["server"] = {
  "file" => "server.properties",
  "entries" => {
    ## Settings are set to defaults by kafka but can be optionally
    ## overridden in the server.properties file such as bumping the default
    ## replication factor from 1 to 2 with:
    # "default.replication.factor" => 2,
    #
    # For a full list reference kafka's config documentation
    "delete.topic.enable" => "true"
  }
}

default["et_apache_kafka"]["conf"]["log4j"] = {
  "file" => "log4j.properties",
  "entries" => {
    "log4j.additivity.kafka" => "false",
    "log4j.additivity.kafka.controller" => "false",
    "log4j.additivity.kafka.log.LogCleaner" => "false",
    "log4j.additivity.kafka.network.RequestChannel$" => "false",
    "log4j.additivity.kafka.request.logger" => "false",
    "log4j.additivity.state.change.logger" => "false",
    "log4j.appender.cleanerAppender.DatePattern" => "'.'yyyy-MM-dd-HH",
    "log4j.appender.cleanerAppender.File" => "${kafka.logs.dir}/log-cleaner.log",
    "log4j.appender.cleanerAppender.layout.ConversionPattern" => "[%d] %p %m (%c)%n",
    "log4j.appender.cleanerAppender.layout" => "org.apache.log4j.PatternLayout",
    "log4j.appender.cleanerAppender" => "org.apache.log4j.DailyRollingFileAppender",
    "log4j.appender.controllerAppender.DatePattern" => "'.'yyyy-MM-dd-HH",
    "log4j.appender.controllerAppender.File" => "${kafka.logs.dir}/controller.log",
    "log4j.appender.controllerAppender.layout.ConversionPattern" => "[%d] %p %m (%c)%n",
    "log4j.appender.controllerAppender.layout" => "org.apache.log4j.PatternLayout",
    "log4j.appender.controllerAppender" => "org.apache.log4j.DailyRollingFileAppender",
    "log4j.appender.kafkaAppender.DatePattern" => "'.'yyyy-MM-dd-HH",
    "log4j.appender.kafkaAppender.File" => "${kafka.logs.dir}/server.log",
    "log4j.appender.kafkaAppender.layout.ConversionPattern" => "[%d] %p %m (%c)%n",
    "log4j.appender.kafkaAppender.layout" => "org.apache.log4j.PatternLayout",
    "log4j.appender.kafkaAppender" => "org.apache.log4j.DailyRollingFileAppender",
    "log4j.appender.requestAppender.DatePattern" => "'.'yyyy-MM-dd-HH",
    "log4j.appender.requestAppender.File" => "${kafka.logs.dir}/kafka-request.log",
    "log4j.appender.requestAppender.layout.ConversionPattern" => "[%d] %p %m (%c)%n",
    "log4j.appender.requestAppender.layout" => "org.apache.log4j.PatternLayout",
    "log4j.appender.requestAppender" => "org.apache.log4j.DailyRollingFileAppender",
    "log4j.appender.stateChangeAppender.DatePattern" => "'.'yyyy-MM-dd-HH",
    "log4j.appender.stateChangeAppender.File" => "${kafka.logs.dir}/state-change.log",
    "log4j.appender.stateChangeAppender.layout.ConversionPattern" => "[%d] %p %m (%c)%n",
    "log4j.appender.stateChangeAppender.layout" => "org.apache.log4j.PatternLayout",
    "log4j.appender.stateChangeAppender" => "org.apache.log4j.DailyRollingFileAppender",
    "log4j.appender.stdout.layout.ConversionPattern" => "[%d] %p %m (%c)%n",
    "log4j.appender.stdout.layout" => "org.apache.log4j.PatternLayout",
    "log4j.appender.stdout" => "org.apache.log4j.ConsoleAppender",
    "log4j.logger.kafka.controller" => "TRACE, controllerAppender",
    "log4j.logger.kafka" => "INFO, kafkaAppender",
    "log4j.logger.kafka.log.LogCleaner" => "INFO, cleanerAppender",
    "log4j.logger.kafka.network.RequestChannel$" => "WARN, requestAppender",
    "log4j.logger.kafka.request.logger" => "WARN, requestAppender",
    "log4j.logger.state.change.logger" => "TRACE, stateChangeAppender",
    "log4j.rootLogger" => "WARN, stdout "
  }
}
