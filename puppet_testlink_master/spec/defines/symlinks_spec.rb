require 'spec_helper'

describe 'testlink::symlinks', :type => :define do

  context 'using default parameters on Debian' do
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      }
    end
    
    let(:title) do
      'dummy_instance'
    end
    
  end
end
