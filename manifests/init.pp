# Class: harden_docker
# ===========================
#
# @summary Hardens a Docker installation. Please note: this does NOT install Docker. It also does not harden images or containers.
#
# Parameters
# ----------
#
# @param restrict_network_traffic_between_containers [Boolean] Disables inter-container communication.
# @param set_the_logging_level [Variant[Boolean, Enum['info', 'debug', 'warn', 'error', 'fatal']]]
#        Set the logging level ("debug", "info", "warn", "error", "fatal") or false to turn off management (default "info")
# @param allow_docker_to_make_changes_to_iptables [Boolean] Enable addition of iptables rules.
# @param disable_operations_on_legacy_registry [Boolean] Disables contacting legacy registries.
# @param enable_live_restore [Boolean] Enables live restore of docker when containers are still running. Do not use with Swarm.
# @param disable_userland_proxy [Boolean] Disables use of userland proxy for loopback traffic.
#
class harden_docker(
  Boolean $restrict_network_traffic_between_containers = true,
  Variant[Boolean, Enum['info', 'debug', 'warn', 'error', 'fatal']] $set_the_logging_level = 'info',
  Boolean $allow_docker_to_make_changes_to_iptables = true,
  Boolean $disable_operations_on_legacy_registry = true,
  Boolean $enable_live_restore = true,
  Boolean $disable_userland_proxy = true,
  ) {

  # 1.2 Use the updated Linux Kernel (Scored)
  if versioncmp($::facts['kernelversion'], '3.10') < 0 {
    fail('The Linux kernelversion must be at least version 3.10')
  }

  # Docker audit roles path
  $docker_auditd_path = '/etc/audit/rules.d/docker.rules'

  class { '::harden_docker::config': }
  -> class { '::harden_docker::config_auditd': }
  -> Class['::harden_docker']

  class { '::harden_docker::config_daemon': }
  -> Class['::harden_docker']

  if defined(Service['docker']) {
    Class['::harden_docker::config_daemon']
    ~> Service['docker']
  }
}
