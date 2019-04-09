class Train
  attr_accessor :speed
  attr_reader :carriages, :type, :number

  def initialize(number)
    @number = number
    @speed = 0
    @carriages = []
  end

  def stop
    @speed = 0
  end

  def take_route(route)
    @route = route
    @route.stations.first.take_train(self)
    @station_index = 0
  end

  def go_forward
    return unless next_station
    current_station.send_train(self)
    next_station.take_train(self)
    @station_index += 1
  end

  def go_back
    return unless previous_station
    current_station.send_train(self)
    previous_station.take_train(self)
    @station_index -= 1
  end

  def current_station
    @route.stations[@station_index]
  end

  def next_station
    @route.stations[@station_index + 1] if @route.stations.length > @station_index + 1
  end

  def previous_station
    @route.stations[@station_index - 1] if @station_index > 0
  end
end
