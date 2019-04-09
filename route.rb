class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station) if check_station(station)
  end

  def list_station
    @stations.each { |station| puts station.name }
  end

  private

  def check_station(station) # клиенту не нужно его вызывать, вызывается из метода delete_station
    station != @stations.first && station != @stations.last
  end
end
