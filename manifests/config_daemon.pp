# == Class harden_docker::config
#
# This class is called from harden_docker for service config.
#
class harden_docker::config_daemon {
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
      'set dict/entry[last()+1] icc',
      "set dict/entry[last()]/const ${allow_network_traffic_between_containers}",
    ],
    onlyif  => "match dict/entry[*][.='icc'] size == 0",
  }

  augeas { 'set_the_logging_level':
    changes => [
      'set dict/entry[last()+1] log-level',
      "set dict/entry[last()]/string ${::harden_docker::set_the_logging_level}",
    ],
    onlyif  => "match dict/entry[*][.='log-level'] size == 0",
  }

  augeas { 'allow_docker_to_make_changes_to_iptables':
    changes => [
      'set dict/entry[last()+1] iptables',
      "set dict/entry[last()]/const ${::harden_docker::allow_docker_to_make_changes_to_iptables}",
    ],
    onlyif  => "match dict/entry[*][.='iptables'] size == 0",
  }

  augeas { 'disable_operations_on_legacy_registry':
    changes => [
      'set dict/entry[last()+1] disable-legacy-registry',
      "set dict/entry[last()]/const ${::harden_docker::disable_operations_on_legacy_registry}",
    ],
    onlyif  => "match dict/entry[*][.='disable-legacy-registry'] size == 0",
  }

  augeas { 'enable_live_restore':
    changes => [
      'set dict/entry[last()+1] live-restore',
      "set dict/entry[last()]/const ${::harden_docker::enable_live_restore}",
    ],
    onlyif  => "match dict/entry[*][.='live-restore'] size == 0",
  }

  $enable_userland_proxys = $harden_docker::disable_userland_proxy ? {
    true    => false,
    default => true,
  }

  augeas { 'disable_userland_proxy':

    changes => [
      'set dict/entry[last()+1] userland-proxy',
      "set dict/entry[last()]/const ${enable_userland_proxys}",
    ],
    onlyif  => "match dict/entry[*][.='userland-proxy'] size == 0",
  }
}
