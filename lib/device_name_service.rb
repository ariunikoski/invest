class DeviceNameService
  def self.friendly_name(user_agent)
    detector = DeviceDetector.new(user_agent)

    device = detector.device_name.presence || "Unknown Device"
    os = detector.os_name.presence
    client = detector.name.presence

    parts = []
    parts << device if device
    parts << "(#{os})" if os
    parts << "- #{client}" if client && client != device

    parts.join(" ")
  end
end
