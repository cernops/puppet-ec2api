require 'spec_helper'

describe 'ec2api::db::mysql' do

  let :pre_condition do
    [
      'include mysql::server',
      'include ec2api::db::sync'
    ]
  end

  let :facts do
    { :osfamily => 'Debian' }
  end

  let :params do
    {
      'password'      => 'pwd',
    }
  end

  describe 'with only required params' do
    it { is_expected.to contain_openstacklib__db__mysql('ec2api').with(
      'user'          => 'ec2api',
      'password_hash' => '*0000000',
      'dbname'        => 'ec2api',
      'host'          => '127.0.0.1',
      'charset'       => 'utf8',
      :collate        => 'utf8_general_ci',
    )}
  end

  describe "overriding allowed_hosts param to array" do
    let :params do
      {
        :password       => 'pwd',
        :allowed_hosts  => ['127.0.0.1','%']
      }
    end

  end
  describe "overriding allowed_hosts param to string" do
    let :params do
      {
        :password       => 'pwd',
        :allowed_hosts  => '192.168.1.1'
      }
    end

  end

  describe "overriding allowed_hosts param equals to host param " do
    let :params do
      {
        :password       => 'pwd',
        :allowed_hosts  => '127.0.0.1'
      }
    end

  end

end
