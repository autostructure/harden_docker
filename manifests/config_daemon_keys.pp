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

  augeas { 'icc_key':
    changes => [
      'set dict/entry[last()+1] icc',
    ],
    onlyif  => "match dict/entry[*][.='icc'] size == 0",
  }

  augeas { 'log-level_key':
    changes => [
      'set dict/entry[last()+1] log-level',
    ],
    onlyif  => "match dict/entry[*][.='log-level'] size == 0",
  }

  augeas { 'iptables_key':
    changes => [
      'set dict/entry[last()+1] iptables',
    ],
    onlyif  => "match dict/entry[*][.='iptables'] size == 0",
  }

  augeas { 'disable-legacy-registry_key':
    changes => [
      'set dict/entry[last()+1] disable-legacy-registry',
    ],
    onlyif  => "match dict/entry[*][.='disable-legacy-registry'] size == 0",
  }

  augeas { 'live_restore_key':
    changes => [
      'set dict/entry[last()+1] live-restore',
    ],
    onlyif  => "match dict/entry[*][.='live-restore'] size == 0",
  }

  augeas { 'userland-proxy_key':
    changes => [
      'set dict/entry[last()+1] userland-proxy',
    ],
    onlyif  => "match dict/entry[*][.='userland-proxy'] size == 0",
  }
}
