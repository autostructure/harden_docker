# Class: harden_docker
# ===========================
#
# Full description of class harden_docker here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# TODO: 2.6 Configure TLS authentication for Docker daemon
# TODO: Add to notes that log_level param is removed
#
class harden_docker {

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
    Class['::harden_docker::config_auditd']
    ~> Service['docker']
  }
}
