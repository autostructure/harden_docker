# == Class harden_docker::config
#
# This class is called from harden_docker for service config.
#
class harden_docker::config_daemon_keys {
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

  augeas { 'icc_key':
    changes => [
      'set dict/entry[last()+1] icc',
      "set dict/entry[.='icc']/const ${allow_network_traffic_between_containers}",
    ],
    onlyif  => "match dict/entry[.='icc'] size == 0",
  }

  augeas { 'log-level_key':
    changes => [
      'set dict/entry[last()+1] log-level',
      "set dict/entry[.='log-level']/string ${::harden_docker::set_the_logging_level}",
    ],
    onlyif  => "match dict/entry[.='log-level'] size == 0",
  }

  # augeas { 'iptables_key':
  #   changes => [
  #     'set dict/entry[last()+1] iptables',
  #     "set dict/entry[.='iptables']/const ${::harden_docker::allow_docker_to_make_changes_to_iptables}",
  #   ],
  #   onlyif  => "match dict/entry[.='iptables'] size == 0",
  # }

  augeas { 'disable-legacy-registry_key':
    changes => [
      'set dict/entry[last()+1] disable-legacy-registry',
      "set dict/entry[.='disable-legacy-registry']/const ${::harden_docker::disable_operations_on_legacy_registry}",
    ],
    onlyif  => "match dict/entry[.='disable-legacy-registry'] size == 0",
  }

  augeas { 'live_restore_key':
    changes => [
      'set dict/entry[last()+1] live-restore',
      "set dict/entry[.='live-restore']/const ${::harden_docker::enable_live_restore}",
    ],
    onlyif  => "match dict/entry[.='live-restore'] size == 0",
  }

  $enable_userland_proxys = $harden_docker::disable_userland_proxy ? {
    true    => false,
    default => true,
  }

  augeas { 'userland-proxy_key':
    changes => [
      'set dict/entry[last()+1] userland-proxy',
      "set dict/entry[.='userland-proxy']/const ${enable_userland_proxys}",
    ],
    onlyif  => "match dict/entry[.='userland-proxy'] size == 0",
  }
}
