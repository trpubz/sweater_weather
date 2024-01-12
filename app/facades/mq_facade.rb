class MqFacade
  def self.get_lat_long(location)
    MqService.get_lat_lon(location)
  end
end
