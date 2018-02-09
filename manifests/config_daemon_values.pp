# == Class harden_docker::config
#
# This class is called from harden_docker for service config.
#
class harden_docker::config_daemon_values {
  Augeas {
    lens => 'Json.lns',
    incl => '/etc/docker/daemon.json',
  }

  # Restrict network traffic between containers
  # Set the logging level
  # Allow Docker to make changes to iptables
  # Disable operations on legacy registry
  # Enable live restore
  # Disable Userland Proxy

  $allow_network_traffic_between_containers = $harden_docker::restrict_network_traffic_between_containers ? {
    true    => false,
    default => true,
  }

  augeas { 'restrict_network_traffic_between_containers':
    changes => [
      "set dict/entry[.='icc']/const ${allow_network_traffic_between_containers}",
    ],
  }

  augeas { 'set_the_logging_level':
    changes => [
      "set dict/entry[.='log-level']/string ${::harden_docker::set_the_logging_level}",
    ],
  }

  augeas { 'allow_docker_to_make_changes_to_iptables':
    changes => [
      "set dict/entry[.='iptables']/const ${::harden_docker::allow_docker_to_make_changes_to_iptables}",
    ],
  }

  augeas { 'disable_operations_on_legacy_registry':
    changes => [
      "set dict/entry[.='disable-legacy-registry']/const ${::harden_docker::disable_operations_on_legacy_registry}",
    ],
  }

  augeas { 'enable_live_restore':
    changes => [
      "set dict/entry[.='live-restore']/const ${::harden_docker::enable_live_restore}",
    ],
  }

  $enable_userland_proxys = $harden_docker::disable_userland_proxy ? {
    true    => false,
    default => true,
  }

  augeas { 'disable_userland_proxy':

    changes => [
      "set dict/entry[.='userland-proxy']/const ${enable_userland_proxys}",
    ],
  }
}
