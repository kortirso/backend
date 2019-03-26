require 'json'
require_relative 'chronogolf/prices'

class Chronogolf
  include Chronogolf::Prices

  attr_reader :tee_times, :reservations

  def initialize(filename)
    input = JSON.parse(File.read(filename))
    @tee_times = input['tee_times']
    @reservations = input['reservations']
  end
end
