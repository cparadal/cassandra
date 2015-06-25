require 'spec_helper_acceptance'

describe 'cassandra class' do
  describe 'running puppet code' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
        if $::osfamily == 'Debian' {
          $java_package_name = 'openjdk-7-jre-headless'
        } else {
          $java_package_name = 'java-1.7.0-openjdk'
        }

        class { 'cassandra':
          datastax_agent_package_ensure => 'present',
          datastax_agent_service_enable => 'false',
          datastax_agent_service_ensure => 'stopped',
          manage_dsc_repo               => true,
          service_enable                => 'false',
          service_ensure                => 'stopped',
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
  end
end