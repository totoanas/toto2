require 'spec_helper'
#require 'ruby-debug'

describe 'testlink', :type => :class do

  context 'using default parameters on Debian' do
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '6',
        :processorcount => 1
      }
    end

    let(:params) do
      {
        :server_name      => 'www.example.com',
        :admin_email      => 'admin@puppetlabs.com',
        :db_root_password => 'long_password'
      }
    end

    it {
      should contain_class('testlink')
      should contain_class('apache')
      should contain_class('apache::mod::php')
      should contain_class('apache::mod::prefork')
      should contain_class('testlink::params')
      should contain_package('php5').with('ensure' => 'latest')
      should contain_package('php5-mysql').with('ensure'=> 'latest')
      should contain_class('mysql::server').with('config_hash' => {'root_password' => 'long_password'})
#      should contain_class('memcached').with('max_memory' => '2048')
    }
  end

  context 'using custom parameters on Debian' do
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '6',
        :processorcount => 1
      }
    end

    let(:params) do
      {
        :server_name      => 'www.example.com',
        :admin_email      => 'admin@puppetlabs.com',
        :db_root_password => 'long_password',
        :doc_root         => '/var/www/testlinks',
        :tarball_url      => 'http://download.testlinkmedia.org/testlink/1.19/testlink-1.19.1.tar.gz',
        :package_ensure   => 'installed',
        :max_memory       => '1024'
      }
    end

    it {
      should contain_class('testlink')
      should contain_class('apache').with('mpm_module' => 'prefork')
      should contain_class('apache::mod::php')
      should contain_class('testlink::params')
      should contain_package('php5').with('ensure' => 'installed')
      should contain_package('php5-mysql').with('ensure' => 'installed')
      should contain_class('mysql::server').with('config_hash' => {'root_password' => 'long_password'})
#      should contain_class('memcached').with('max_memory' => '1024')
    }
  end

  # Implement additional contexts for different Ubuntu, CentOS, and RedHat.
  context 'using default parameters on Ubuntu' do
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :processorcount => 1
      }
    end
    let(:params) do
      {
        :server_name      => 'www.example.com',
        :admin_email      => 'admin@puppetlabs.com',
        :db_root_password => 'long_password'
      }
    end
  end

  context 'using default parameters on CentOS and RedHat' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :processorcount => 1
      }
    end
    let(:params) do
      {
        :server_name      => 'www.example.com',
        :admin_email      => 'admin@puppetlabs.com',
        :db_root_password => 'long_password'
      }
    end
  end
end
