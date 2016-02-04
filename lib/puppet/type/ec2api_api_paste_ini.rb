Puppet::Type.newtype(:ec2api_api_paste_ini) do

  ensurable

  newparam(:name, :namevar => true) do
    desc 'Section/setting name to manage from /etc/ec2api/api-paste.ini'
    newvalues(/\S+\/\S+/)
  end
end
