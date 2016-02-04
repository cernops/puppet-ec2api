Puppet::Type.newtype(:ec2api_config) do

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc 'Section/setting name to manage from ec2api.conf'
    newvalues(/\S+\/\S+/)
  end
end
