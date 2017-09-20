# == Class secure_docker::config
#
# This class is called from secure_docker for service config.
#
class harden_docker::config_auditd {
  # Defaults for file_line
  $file_line_auditd_defaults = {
    path    => $::harden_docker::docker_auditd_path,
  }

  # Audit docker daemon
  # Audit Docker files and directories - /var/lib/docker
  # Audit Docker files and directories - /etc/docker
  # Audit Docker files and directories - docker.service
  # Audit Docker files and directories - docker.socket
  # Audit Docker files and directories - /etc/default/docker
  # Audit Docker files and directories - /etc/docker/daemon.json
  # Audit Docker files and directories - /usr/bin/docker-containerd
  # Audit Docker files and directories - /usr/bin/docker-runc
  file_line {
    default:
      * => $file_line_auditd_defaults,;

    'docker_daemon_audit':
      line => '-w /usr/bin/docker -k docker',;

    'docker_var_files_audit':
      line => '-w /var/lib/docker -k docker',;

    'docker_etc_files_audit':
      line => '-w /etc/docker -k docker',;

    'docker_registry_service_audit':
      line => '-w /usr/lib/systemd/system/docker.service -k docker',;

    'docker_sock_audit':
      line => '-w /usr/lib/systemd/system/docker.socket -k docker',;

    'docker_sysconfig_audit':
      line => '-w /etc/default/docker -k docker',;

    'docker_daemon_json_audit':
      line => '-w /etc/docker/daemon.json -k docker',;

    'docker_containerd_audit':
      line => '-w /usr/bin/docker-containerd -k docker',;

    'docker_runc_audit':
      line => '-w /usr/bin/docker-runc -k docker',;
  }
}
