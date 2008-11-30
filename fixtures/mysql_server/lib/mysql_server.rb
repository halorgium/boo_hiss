class MysqlServer
  class Error < StandardError; end
  class NotInstalled < Error; end
  class AlreadyInstalled < Error; end
  class DbAlreadyExists < Error; end
  class DbNonExistant < Error; end

  def install
    case System.run("bin/mysql_install #{MOUNT_POINT}")
    when "installed"
      true
    when "already installed"
      raise AlreadyInstalled, "mysql is already installed"
    else
      raise Error
    end
  end

  def installed?
    databases.include?("mysql")
  end

  def list
    System.run "bin/mysql_list #{MOUNT_POINT}"
  end

  def databases
    list.split(/\n/)
  end

  def create_db(name)
    raise NotInstalled, "mysql is not installed" unless installed?
    case System.run("bin/mysql_create #{MOUNT_POINT} #{name}")
    when "created"
      true
    when "db already exists"
      raise DbAlreadyExists, "db already exists"
    else
      raise Error
    end
  end

  def remove_db(name)
    raise NotInstalled, "mysql is not installed" unless installed?
    case System.run("bin/mysql_rm #{MOUNT_POINT} #{name}")
    when "removed"
      true
    when "db non-existant"
      raise DbNonExistant, "db non-existant"
    else
      raise Error
    end
  end
end
