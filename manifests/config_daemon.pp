# == Class harden_docker::config
#
# This class is called from harden_docker for service config.
#
class harden_docker::config_daemon {
  $augeas_docker_daemon_defaults = {
    lens => 'Json.lns',
    incl => '/etc/docker/daemon.json',
  }

  # Restrict network traffic between containers
  # Set the logging level
  # Allow Docker to make changes to iptables
  # Disable operations on legacy registry
  # Enable live restore
  # Disable Userland Proxy
  augeas {
    default:
      * => $augeas_docker_daemon_defaults,;

    'restrict_network_traffic_between_containers':
      changes => [
        'set dict/entry[.=\'icc\'] icc',
        'set dict/entry[.=\'icc\']/boolean false',
      ],;

    'set_the_logging_level':
      changes => [
        'set dict/entry[.=\'log-level\'] log-level',
        'set dict/entry[.=\'log-level\']/string info',
      ],;

    'allow_docker_to_make_changes_to_iptables':
      changes => [
        'set dict/entry[.=\'iptables\'] iptables',
        'set dict/entry[.=\'iptables\']/boolean true',
      ],;

    'disable_operations_on_legacy_registry':
      changes => [
        'set dict/entry[.=\'disable-legacy-registry\'] disable-legacy-registry',
        'set dict/entry[.=\'disable-legacy-registry\']/boolean true',
      ],;

    'enable_live_restore':
      changes => [
        'set dict/entry[.=\'live-restore\'] live-restore',
        'set dict/entry[.=\'live-restore\']/boolean true',
      ],;

    'disable_userland_proxy':
      changes => [
        'set dict/entry[.=\'userland-proxy\'] userland-proxy',
        'set dict/entry[.=\'userland-proxy\']/boolean false',
      ],;
  }
}
