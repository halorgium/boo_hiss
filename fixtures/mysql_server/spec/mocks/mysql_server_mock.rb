class MysqlServerMock
  def initialize
    @databases = []
  end

  def locate(command)
    case command
    when /\/mysql_install /
      :install
    when /\/mysql_list /
      :list
    when /\/mysql_create /
      :create
    when /\/mysql_rm /
      :remove
    end
  end

  def install(command)
    if @databases.include?("mysql")
      return "already installed"
    end
    @databases = ["mysql"]
    "installed"
  end

  def list(command)
    @databases.join("\n")
  end

  def create(command)
    if command =~ /mysql_create [^ ]+ (\w+)$/
      name = $1
      if @databases.include?(name)
        "db already exists"
      else
        @databases << $1
        "created"
      end
    else
      "FAILED"
    end
  end

  def remove(command)
    if command =~ /mysql_rm [^ ]+ (\w+)$/
      name = $1
      unless @databases.include?(name)
        "db non-existant"
      else
        @databases.delete($1)
        "removed"
      end
    else
      "FAILED"
    end
  end
end
