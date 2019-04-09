require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_carriage'
require_relative 'cargo_carriage'

class Main
  attr_accessor :all_stations, :trains, :routes

  def initialize
    @all_stations = []
    @trains = []
    @routes = []
  end

  def run
    loop do
      puts "Создать станцию, введите 1"
      puts "Создать поезд, введите 2"
      puts "Создать маршрут и управлять станциями в нем (добавлять, удалять), введите 3"
      puts "Назначать маршрут поезду, введите 4"
      puts "Добавлять вагоны к поезду, введите 5"
      puts "Отцеплять вагоны от поезда, введите 6"
      puts "Перемещать поезд по маршруту вперед и назад, введите 7"
      puts "Просматривать список станций и список поездов на станции, введите 8"
      puts "Для выхода из программы, введите 0"
      case gets.to_i
        when 0 then break
        when 1 then create_station
        when 2 then create_train
        when 3 then manage_route
        when 4 then take_route
        when 5 then add_wagon
        when 6 then delete_wagon
        when 7 then move_train
        when 8 then show_stations_trains
      end
    end
  end

  def create_station
    system 'clear'
    puts "Введите название станции"
    @all_stations << Station.new(gets.chomp)
  end

  def create_train
    system 'clear'
    loop do
      puts "Создать пассажирский поезд, введите 1"
      puts "Создать грузовой поезд, введите 2"
      puts "Для выхода в основное меню, введите 0"
      case gets.to_i
        when 0 then break
        when 1 then create_passenger_train
        when 2 then create_cargo_train
      end
    end
  end

  def manage_route
    system 'clear'
    loop do
      puts "Создать маршрут, введите 1"
      puts "Добавить станцию в маршрут, введите 2"
      puts "Удалить станцию из маршрута, введите 3"
      puts "Для выхода в основное меню, введите 0"
      case gets.to_i
        when 0 then break
        when 1 then create_route
        when 2 then add_station
        when 3 then delete_station
      end
    end
  end

  def take_route
    system 'clear'
    set_train
    train = @trains[gets.to_i]
    set_route
    route = @routes[gets.to_i]
    train.take_route(route)
  end

  def add_wagon
    system 'clear'
    set_train
    train = @trains[gets.to_i]
    carriage = train.is_a?(CargoTrain) ? CargoCarriage.new : PassengerCarriage.new
    train.attach_carriage(carriage)
  end

  def delete_wagon
    system 'clear'
    set_train
    train = @trains[gets.to_i]
    puts "Выберете вагон:"
    train.carriages.each_with_index { |carriage, index| puts "#{index}: #{carriage}" }
    carriage = train.carriages[gets.to_i]
    train.detach_carriage(carriage)
  end

  def move_train
    system 'clear'
    loop do
      puts "Переместить поезд вперед, введите 1"
      puts "Переместить поезд назад, введите 2"
      puts "Для выхода в основное меню, введите 0"
      case gets.to_i
        when 0 then break
        when 1 then go_forward
        when 2 then go_back
      end
    end
  end

  def show_stations_trains
    system 'clear'
    puts "Выберете станцию:"
    @all_stations.each_with_index { |station, index| puts "#{index} - #{station.name}" }
    station = @all_stations[gets.to_i]
    puts "На станции #{station.name} находятся поезда:"
    station.trains.each { |train| puts "Номер поезда - #{train.number}, тип поезда - #{train.type}" }
  end

  def create_passenger_train
    system 'clear'
    puts "Введите номер поезда"
    @trains << PassengerTrain.new(gets.to_i)
  end

  def create_cargo_train
    system 'clear'
    puts "Введите номер поезда"
    @trains << CargoTrain.new(gets.to_i)
  end

  def create_route
    system 'clear'
    if @all_stations.size < 2
      puts "Мало станций, создайте станцию."
      return create_station
    end
    puts "Выберете начальную станцию:"
    @all_stations.each_with_index { |station, index| puts "#{index} - #{station.name}" }
    start_station = @all_stations[gets.to_i]
    puts "Выберете конечную станцию:"
    remaining_stations = @all_stations.select { |station| station != start_station }
    remaining_stations.each_with_index { |station, index| puts "#{index} - #{station.name}" }
    end_station = remaining_stations[gets.to_i]
    @routes << Route.new(start_station, end_station)
  end

  def add_station
    system 'clear'
    set_route
    route_index = gets.to_i
    puts "Выберете станцию:"
    start_end_stations = [@routes[route_index].stations.first, @routes[route_index].stations.last]
    list_adding_stations = @all_stations - start_end_stations
    list_adding_stations.each_with_index { |station, index| puts "#{index}: #{station.name}" }
    station_index = gets.to_i
    @routes[route_index].add_station(list_adding_stations[station_index])
  end

  def delete_station
    system 'clear'
    set_route
    route_index = gets.to_i
    puts "Выберете станцию:"
    start_end_stations = [@routes[route_index].stations.first, @routes[route_index].stations.last]
    list_deleting_stations = @routes[route_index].stations - start_end_stations
    list_deleting_stations.each_with_index { |station, index| puts "#{index}: #{station.name}" }
    station_index = gets.to_i
    puts list_deleting_stations[station_index].inspect
    @routes[route_index].delete_station(list_deleting_stations[station_index])
  end

  def go_forward
    system 'clear'
    set_train
    train = @trains[gets.to_i]
    train.go_forward
  end

  def go_back
    system 'clear'
    set_train
    train = @trains[gets.to_i]
    train.go_back
  end

  def set_route
    puts "Выберете маршрут:"
    @routes.each_with_index { |route, index| puts "#{index}: #{route.stations.first.name} --- #{route.stations.last.name}" }
  end

  def set_train
    puts "Выберете поезд:"
    @trains.each_with_index { |train, index| puts "#{index}: #{train.number}" }
  end

end

main = Main.new
=begin seeds
irpen = Station.new("Irpen")
kiev = Station.new("Kiev")
borispol = Station.new("Borispol")
main.all_stations << irpen << kiev << borispol
puts main.all_stations.inspect
irpen_borispol = Route.new(irpen, borispol)
irpen_borispol.add_station(kiev)
main.routes << irpen_borispol
puts main.routes.inspect
pobeda = CargoTrain.new(123)
main.trains << pobeda
puts main.trains.inspect
pobeda.take_route(irpen_borispol)
puts pobeda.inspect
=end
main.run
