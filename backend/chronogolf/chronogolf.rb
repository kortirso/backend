require 'json'
require_relative 'chronogolf/prices'
require_relative 'chronogolf/adapted_prices'

class Chronogolf
  include Chronogolf::Prices
  include Chronogolf::AdaptedPrices

  attr_reader :tee_times, :reservations

  def initialize(filename)
    input = JSON.parse(File.read(filename))
    @tee_times = input['tee_times']
    @reservations = input['reservations']
  end

  private

  def calc_price(tee_time, reservation)
    tee_time['price_per_golfer'] * reservation['number_of_golfers']
  end

  def find_tee_time_for_reservation(reservation)
    tee_times.detect { |tee| tee['id'] == reservation['tee_time_id'] }
  end
end
