require 'json'
require_relative 'chronogolf/prices'
require_relative 'chronogolf/adapted_prices'
require_relative 'chronogolf/fee'

class Chronogolf
  include Chronogolf::Prices
  include Chronogolf::AdaptedPrices
  include Chronogolf::Fee

  attr_reader :tee_times, :reservations

  def initialize(filename)
    input = JSON.parse(File.read(filename))
    @tee_times = input['tee_times']
    @reservations = input['reservations']
  end

  private

  def save_file(filename, result)
    File.write(filename, { 'reservations' => result }.to_json)
  end
end
