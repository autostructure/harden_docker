# == Class secure_docker::config
#
# This class is called from secure_docker for service config.
#
class harden_docker::config {
  file { $::harden_docker::docker_auditd_path:
    ensure => file,
  }

  # 3.5 Verify that /etc/docker directory ownership is set to root:root
  # 3.6 Verify that /etc/docker directory permissions are set to 755 or more restrictive
  file { '/etc/docker':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => 'go-w',
  }

  # 3.7 Verify that registry certificate file ownership is set to root:root
  # 3.8 Verify that registry certificate file permissions are set to 444 or more restrictive
  file { '/etc/docker/certs.d':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    recurse => true,
    mode    => 'a-rx',
  }

  # # 3.9 Verify that TLS CA certificate file ownership is set to root:root
  # # 3.10 Verify that TLS CA certificate file permissions are set to 444 or more restrictive
  # file { $::secure_docker::tls_cacert:
  #   ensure => file,
  #   owner  => 'root',
  #   group  => 'root',
  #   mode   => '0444',
  # }

  # # 3.11 Verify that Docker server certificate file ownership is set to root:root
  # # 3.12 Verify that Docker server certificate file permissions are set to 444 or more restrictive
  # file { $::secure_docker::tls_cert:
  #   ensure => file,
  #   owner  => 'root',
  #   group  => 'root',
  #   mode   => '0444',
  # }

  # # 3.13 Verify that Docker server certificate key file ownership is set to root:root
  # # 3.14 Verify that Docker server certificate key file permissions are set to 400
  # file { $::secure_docker::tls_key:
  #   ensure => file,
  #   owner  => 'root',
  #   group  => 'root',
  #   mode   => '0400',
  # }

  # 3.15 Verify that Docker socket file ownership is set to root:docker
  # 3.16 Verify that Docker socket file permissions are set to 660 or more restrictive
  file { '/var/run/docker.sock':
    owner   => 'root',
    group   => 'docker',
    mode    => 'a-x,o-rwx',
    seltype => 'var_run_t',
  }

  # 3.17 Verify that daemon.json file ownership is set to root:root
  # 3.18 Verify that daemon.json file permissions are set to 644 or more restrictive
  file { '/etc/docker/daemon.json':
    ensure => absent,
    owner  => 'root',
    group  => 'root',
    mode   => 'a-x,go-w',
  }

  # 3.19 Verify that /etc/default/docker file ownership is set to root:root
  # 3.20 Verify that /etc/default/docker file permissions are set to 644 or more restrictive
  file { '/etc/default/docker':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => 'a-x,go-w',
  }
}
