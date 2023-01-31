class Log < ApplicationRecord
  def self.info(message)
    self.create_log('info', message)
  end
  
  def self.warn(message)
    self.create_log('warn', message)
  end
  
  def self.error(message)
    self.create_log('error', message)
  end
  
  def self.create_log(level, message)
    ll = Log.new(level: level, message: message, displayed: 0)
    ll.save
  end
end