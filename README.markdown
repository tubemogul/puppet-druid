[![Build Status](https://travis-ci.org/tubemogul/puppet-druid.svg?branch=master)](https://travis-ci.org/tubemogul/puppet-druid)
[![Puppet Forge latest release](https://img.shields.io/puppetforge/v/TubeMogul/druid.svg)](https://forge.puppetlabs.com/TubeMogul/druid)
[![Puppet Forge downloads](https://img.shields.io/puppetforge/dt/TubeMogul/druid.svg)](https://forge.puppetlabs.com/TubeMogul/druid)
[![Puppet Forge score](https://img.shields.io/puppetforge/f/TubeMogul/druid.svg)](https://forge.puppetlabs.com/TubeMogul/druid/scores)

#### Table of Contents


1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What druid affects](#what-druid-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Puppet module to manage Druid based on the Imply.io stack. This module manage all the Druid daemons and Pivot.

Some modifications will be implemented to support the Druid.io version in a near future.

## Module Description

This module will deploy the Imply.io tarball (See: http://imply.io/download) and will give you the possibility to start the different Druid services but also Pivot.

More information about the Imply.io bundle here: http://imply.io.

## Setup

### What druid affects

Files managed by this module:

* Deploy the imply tarball using Archive: [puppet-archive](https://forge.puppetlabs.com/puppet/archive)
* Modify configuration in (by default): `/opt/imply/conf`
* Manage all Druid and Pivot services: `/etc/init.d/druid-*`

If asked, the module will also deploy Java and Nodejs.

### Setup Requirements


## Usage

Deploy the version 1.1.0 of the Imply bundle:

```puppet
class { 'druid':
  imply_version => '1.1.0'
}
```

If you also want to install Java:

```puppet
class { 'druid':
  install_java => true,
}
```

By default, the package 'openjdk-8-jdk' from the PPA ppa:openjdk-r/ppa' will be deployed. You can override this configuration.


Configure a Master node:

```puppet
class { 'druid': }
class { 'druid::coordinator': }
class { 'druid::overlord': }
```

Configure a Data node:

```puppet
class { 'druid': }
class { 'druid::middle_manager': }
class { 'druid::historical': }
```

Configure a Query node:

```puppet
class { 'druid': }
class { 'druid::broker': }
class { 'druid::pivot': }
```

By default the class `druid::pivot` will not deploy Nodejs. You can use another Puppet module to deploy it before starting Pivot or use the `install_nodejs` parameter:

```puppet
class { 'druid::pivot':
  install_nodejs => false,
}
```

Here is an example with MySQL as a Metadata Storage and Statsd emitter for the performance metrics:

```puppet
class { 'druid':
  java_classpath_extensions => [
    'io/druid/extensions/mysql-metadata-storage/0.8.2/mysql-metadata-storage-0.8.2.jar',
    'mysql/mysql-connector-java/5.1.34/mysql-connector-java-5.1.34.jar'
  ],
  common_config => {
    'extensions'          => {
      'localRepository' => 'dist/druid/extensions-repobla',
      'coordinates'     => [],
    },
    'metadata' => {
      'storage' => {
        'type'      => 'mysql',
        'connector' =>  {
          'connectURI' => 'jdbc:mysql://db.example.com:3306/druid',
          'user'       => 'foo'
          'password'   => 'bar',
        }
      },
    },
    'emitter' => 'statsd',
    'emitter.statsd.hostname' => 'localhost',
    'emitter.statsd.port'     => 8125,
  }
}
```

Deploy the coordinator with some specific configuration:

```puppet
class { 'druid::coordinator':
  config => {
    'coordinator' => {
      'period'                => 'PT30S',
      'period.indexingPeriod' => 'PT900S',
    }
  }
}
```

## Reference

### Public Classes

#### Class: `druid`

Fetch and deploy the Imply.io tarball.

This class will also deploy the Druid common configuration. See: [Configuring Druid](http://druid.io/docs/latest/configuration/index.html)

**Parameters within `druid`:**

##### `imply_version`

Version of the Imply.io tarball to deploy. See: [http://imply.io/download](http://imply.io/download)

Default: `1.2.1`

##### `install_method`

Define the installation method. For now, only tarball is supported.

Default: `tarball`

##### `install_dir`

Where to deploy the tarball

Default: `/opt`

##### `install_link`

Name of the destination link

Default: `imply`

##### `install_java`

If true, the module will try to install Java. This parameter is used with `java_ppa` and `java_package`.

For the moment, only Debian link distribution are supported.

Default: `false`

##### `java_ppa`

Define the name of the Ubuntu PPA which will be used to deploy Java

Requirement: `$osfamily == Debian`

Default: `ppa:openjdk-r/ppa`

##### `java_package`

Package name of Java

Default: `openjdk-8-jdk`

##### `java_home`

Java Home directory

Default: `/usr/lib/jvm/java-8-openjdk-amd64`

##### `config_dir`

Druid configuration directory

Default: `/opt/imply/conf/druid`

##### `dist_dir`

Druid distribution directory

Default: `/opt/imply/dist/druid`

##### `user`

Druid username

Default: `druid`

##### `group`

Druid group name

Default: `druid`

##### `enable_service`

If true, the module will start the Druid services and restarts them when configuration changes are applied

Default: `true`

##### `java_classpath`

Define where Druid will find all the JAR

Default: `/opt/imply/dist/druid/lib/*`

##### `java_classpath_extensions`

Define the list of Java extensions to load at the Druid services start

Example, If you want to use MySQL as your metadata storage:

```yaml
druid::java_classpath_extensions:
  - 'io/druid/extensions/mysql-metadata-storage/0.8.2/mysql-metadata-storage-0.8.2.jar'
  - 'mysql/mysql-connector-java/5.1.34/mysql-connector-java-5.1.34.jar'
```

Default: `[]`

##### `log_dir`

Log directory

Default: `/var/log/druid`

##### `common_config`

Hash defining the Druid Common configuration

See: [http://druid.io/docs/latest/configuration/index.html](http://druid.io/docs/latest/configuration/index.html)

Default: `{}`

#### Class: `druid::coordinator`, `druid::overlord`, `druid::historical`, `druid::middle_manager`, `druid::broker`

Each Druid Node (See [http://druid.io/docs/latest/design/design.html](http://druid.io/docs/latest/design/design.html)) has its own Puppet class.

Each of these classes will use the Puppet Type `druid::node` to define the configuration and the daemon to start.

**Parameters within druid::coordinator`, `druid::overlord`, `druid::historical`, `druid::middle_manager`, `druid::broker`:**

##### `service`

Name of the Druid Node

Default: name of the class. For druid::coordinator, `$service == 'coordinator'`

##### `host`

Listening host of the Druid Node

Default: `localhost`

##### `port`

Listening port of the Druid Node

Default: `8083`

##### `java_opts`

Java options for the Java daemon

Default: `[]`

##### `config`

Hash defining the configuration of the Druid Node

Default: `{}`

#### Class: `druid::pivot`

This class will deployed and configure pivot.

**Parameters within druid::pivot`:**

##### `config_dir`

Hash defining the configuration of the Druid Node

Default: `{}`

##### `port`

Port of Pivot

Default: `9095`

##### `broker_host`

Broker host used by Pivot

Default: `localhost:8082`

##### `enable_stdout_log`

Print logs to stdout

Default: `true`

##### `enable_file_log`

Enable file logging

Default: `true`

##### `log_dir`

Location for Pivot log files

Default: `/var/log/pivot`

####  `pivot_license_source`

Location for Pivot license source

Default: `undef`

##### `max_workers`

Max number of worker processes

Default: `0`

##### `use_segment_metadata`

If true, use a segment metadata query instead of a GET request to /druid/v2/datasources to
determine datasource dimensions and metrics.

Default: `false`

##### `source_list_refresh_interval`

Check for new dataSources periodically. Set to 0 to disable background introspection

Default: `0`

##### `source_list_refresh_onload`

Checks for new dataSources every time Pivot is loaded

Default: `false`

##### `install_nodejs`

If true, the module will install NodeJS

Default: `false`

##### `nodejs_version`

Version of NdeJS to install

Default: `latest`

## Limitations

This module has only been tested with Ubuntu 14.04 and Puppet 3.8.x but should work with any other Linux distribution.

Since the module uses a Launchpad PPA if `java_ppa` is not set as `undef`, you will have to change the default value if you are not on Debian-like OS.

## Development

See CONTRIBUTING.md
