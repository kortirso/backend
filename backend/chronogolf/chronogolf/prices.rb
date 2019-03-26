class Chronogolf
  # Module for detecting language of the text
  module Prices
    # call method
    def prices
      File.write('./prices_output.json', { 'reservations' => calc_price_for_reservations }.to_json)
    end

    private

    def calc_price_for_reservations
      reservations.map!(&method(:calc_price_for_reservation))
    end

    def calc_price_for_reservation(reservation)
      tee_time = tee_times.detect { |tee| tee['id'] == reservation['tee_time_id'] }
      { 'id' => reservation['id'], 'price' => tee_time['price_per_golfer'] * reservation['number_of_golfers'] }
    end
  end
end
