Puppet::Type.type(:ec2api_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do

  def section
    resource[:name].split('/', 2).first
  end

  def setting
    resource[:name].split('/', 2).last
  end

  def separator
    '='
  end

  def getvalue
    if resource[:secret] == :true
      dirpath = '/var/lib/puppet/tbag' # FIXME should be var
      f = [dirpath, resource[:value]].join("/")
      unless File.file?(f)
        self.fail "teigisecret[\"#{resource[:value]}\"] does not exist"
      end
      contents = File.open(f, &:readline).chomp
      return contents
    else
      return resource[:value]
    end
  end

  def self.file_path
    '/etc/ec2api/api-paste.ini'
  end

  # added for backwards compatibility with older versions of inifile
  def file_path
    self.class.file_path
  end

end
