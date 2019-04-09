class PassengerTrain < Train
  def initialize(number)
    super(number)
    @type = :passenger
  end

  def attach_carriage(carriage)
    @carriages << carriage if carriage.type == :passenger && !@carriages.include?(carriage) && @speed == 0
  end
  def detach_carriage(carriage)
    @carriages.delete(carriage) if carriage.type == :passenger && @carriages.include?(carriage) && @speed == 0
  end
end
