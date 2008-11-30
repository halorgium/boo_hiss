class System
  def self.run(command)
    `#{MOUNT_POINT}/#{command}`.chomp
  end
end
