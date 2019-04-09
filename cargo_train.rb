class CargoTrain < Train
  def initialize(number)
    super(number)
    @type = :cargo
  end

  def attach_carriage(carriage)
    @carriages << carriage if carriage.type == :cargo && !@carriages.include?(carriage) && @speed == 0
  end
  def detach_carriage(carriage)
    @carriages.delete(carriage) if carriage.type == :cargo && @carriages.include?(carriage) && @speed == 0
  end
end
