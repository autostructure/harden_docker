[![Build Status](https://travis-ci.org/autostructure/harden_docker.svg?branch=master)](https://travis-ci.org/autostructure/harden_docker)
[![Puppet Forge](https://img.shields.io/puppetforge/v/autostructure/harden_docker.svg)](https://forge.puppetlabs.com/autostructure/harden_docker)
[![Puppet Forge](https://img.shields.io/puppetforge/f/autostructure/harden_docker.svg)](https://forge.puppetlabs.com/autostructure/harden_docker)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with harden_docker](#setup)
    * [What harden_docker affects](#what-harden_docker-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with harden_docker](#beginning-with-harden_docker)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Hardens a Docker installation. Please note: this does NOT install Docker. It does not harden images or containers

## Module Description

One of Puppet biggest strength's is securing and enforcing your environment. If you decide to run Docker it's very important you secure its
configuration files and daemon.

Docker is a great product, but it open to exploitation by savvy hackers. This module will help ensure:

* Common sense hardening rules are enforced
* Basic rules to help network performance between containers

## Setup

### What harden_docker affects

* Configuration files and directories
* Docker daemon Configuration
  * **Warning** A daemon change will restart dockerd. But, only if the service is managed elsewhere.
* Auditing rules for configuration files and directories

### Setup Requirements

This module requires that Docker already be installed.

### Beginning with harden_docker

To have Puppet harden docker with the default parameters, declare the [`harden_docker`][] class:

``` puppet
class { 'harden_docker': }
```

## Usage

You can choose to turn off management of the files and configurations harden_docker manages.

If you are using Swarm you will want to turn off management of live-restore.

``` puppet
class { 'harden_docker':
  enable_live_restore => false,
}
```

## Reference

- [**Public classes**](#public-classes)
    - [Class: harden_docker](#class-harden_docker)
- [**Private classes**](#private-classes)
    - [Class: harden_docker::config](#class-harden_dockerconfig)
    - [Class: harden_docker::config_auditd](#class-harden_dockerconfig_auditd)
    - [Class: harden_docker::config_daemon](#class-harden_dockerconfig_daemon)


### Public Classes

#### Class: `harden_docker`

Hardens a Docker installation. Please note: this does NOT install Docker. It also does not harden images or containers.

##### `restrict_network_traffic_between_containers`

Disables inter-container communication.

Values: true, false

Default: `true`

##### `set_the_logging_level`

Set the logging level ("debug", "info", "warn", "error", "fatal") or false to turn off management (default "info")

Values: false, "debug", "info", "warn", "error", "fatal"

Default: `info`

##### `allow_docker_to_make_changes_to_iptables`

Enable addition of iptables rules.

Values: true, false

Default: `true`

##### `disable_operations_on_legacy_registry`

Disables contacting legacy registries.

Values: true, false

Default: `true`

##### `enable_live_restore`

Enables live restore of docker when containers are still running. Do not use with Swarm.

Values: true, false

Default: `true`

##### `disable_userland_proxy`

Disables use of userland proxy for loopback traffic.

Values: true, false

Default: `true`

## Limitations

Currently only supports Linux OS's.

## Development

Feel free to pull and contribute.
