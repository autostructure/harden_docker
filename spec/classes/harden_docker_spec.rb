require 'spec_helper'

describe 'harden_docker' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "harden_docker class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('harden_docker') }

          it { is_expected.to contain_class('harden_docker::config').that_comes_before('Class[harden_docker]') }
          it { is_expected.to contain_class('harden_docker::config_daemon_keys').that_comes_before('Class[harden_docker::config_daemon_values]') }
          it { is_expected.to contain_class('harden_docker::config_daemon_values').that_comes_before('Class[harden_docker]') }

          it { is_expected.to contain_class('harden_docker::config_auditd').that_comes_before('Class[harden_docker]') }

          # Restrict network traffic between containers
          # Set the logging level
          # Allow Docker to make changes to iptables
          # Disable operations on legacy registry
          # Enable live restore
          # Disable Userland Proxy
          it { is_expected.to contain_augeas('restrict_network_traffic_between_containers') }
          it { is_expected.to contain_augeas('set_the_logging_level') }
          it { is_expected.to contain_augeas('allow_docker_to_make_changes_to_iptables') }
          it { is_expected.to contain_augeas('disable_operations_on_legacy_registry') }
          it { is_expected.to contain_augeas('enable_live_restore') }
          it { is_expected.to contain_augeas('disable_userland_proxy') }

          # 1.1 Create a separate partition for containers (Scored)
          # it {
          #   is_expected.to contain_mount('/var/lib/docker').with('ensure' => 'present')
          # }

          it {
            is_expected.to contain_file('/etc/audit/rules.d/docker.rules').with( 'ensure' => 'file')
          }

          it {
            is_expected.to contain_file('/etc/default/docker').with(
              'ensure' => 'file',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => 'a-x,go-w'
            )
          }

          it {
            is_expected.to contain_file('/etc/docker/certs.d').with(
              'ensure'  => 'directory',
              'owner'   => 'root',
              'group'   => 'root',
              'recurse' => true,
              'mode'    => 'a-rx'
            )
          }

          it {
            is_expected.to contain_file('/etc/docker/daemon.json').with(
              'ensure' => 'file',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => 'a-x,go-w'
            )
          }

          it {
            is_expected.to contain_file('/etc/docker').with(
              'ensure' => 'directory',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => 'go-w'
            )
          }

          it {
            is_expected.to contain_file('/var/run/docker.sock').with(
              'owner'  => 'root',
              'group'  => 'docker',
              'mode'   => 'a-x,o-rwx'
            )
          }

          # 1.7 Audit docker daemon (Scored)
          it {
            is_expected.to contain_file_line('docker_daemon_audit').with(
              'path' => '/etc/audit/rules.d/docker.rules',
              'line' => '-w /usr/bin/docker -k docker'
            )
          }

          # 1.8 Audit Docker files and directories - /var/lib/docker (Scored)
          it {
            is_expected.to contain_file_line('docker_var_files_audit').with(
              'path' => '/etc/audit/rules.d/docker.rules',
              'line' => '-w /var/lib/docker -k docker'
            )
          }

          # 1.9 Audit Docker files and directories - /etc/docker (Scored)
          it {
            is_expected.to contain_file_line('docker_etc_files_audit').with(
              'path' => '/etc/audit/rules.d/docker.rules',
              'line' => '-w /etc/docker -k docker'
            )
          }

          # 1.10 Audit Docker files and directories - docker.service (Scored)
          it {
            is_expected.to contain_file_line('docker_registry_service_audit').with(
              'path' => '/etc/audit/rules.d/docker.rules',
              'line' => '-w /usr/lib/systemd/system/docker.service -k docker'
            )
          }

          # 1.11 Audit Docker files and directories - docker.socket (Scored)
          it {
            is_expected.to contain_file_line('docker_sock_audit').with(
              'path' => '/etc/audit/rules.d/docker.rules',
              'line' => '-w /usr/lib/systemd/system/docker.socket -k docker'
            )
          }

          # 1.12 Audit Docker files and directories - /etc/default/docker (Scored)
          it {
            is_expected.to contain_file_line('docker_sysconfig_audit').with(
              'path' => '/etc/audit/rules.d/docker.rules',
              'line' => '-w /etc/default/docker -k docker'
            )
          }

          # 1.13 Audit Docker files and directories - /etc/docker/daemon.json (Scored)
          it {
            is_expected.to contain_file_line('docker_daemon_json_audit').with(
              'path' => '/etc/audit/rules.d/docker.rules',
              'line' => '-w /etc/docker/daemon.json -k docker'
            )
          }

          # 1.14 Audit Docker files and directories - /usr/bin/docker-containerd (Scored)
          it {
            is_expected.to contain_file_line('docker_containerd_audit').with(
              'path' => '/etc/audit/rules.d/docker.rules',
              'line' => '-w /usr/bin/docker-containerd -k docker'
            )
          }

          # 1.15 Audit Docker files and directories - /usr/bin/docker-runc (Scored)
          it {
            is_expected.to contain_file_line('docker_runc_audit').with(
              'path' => '/etc/audit/rules.d/docker.rules',
              'line' => '-w /usr/bin/docker-runc -k docker'
            )
          }
        end
      end
    end
  end

  # 1.2 Use the updated Linux Kernel (Scored)
  context "harden_docker with older kernel" do
    let(:facts) do
      {
        kernelversion: '3.9.10',
      }
    end

    it { is_expected.not_to compile.with_all_deps }
  end
end
