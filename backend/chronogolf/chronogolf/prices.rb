class Chronogolf
  # Module for calculation for prices
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
      tee_time = find_tee_time_for_reservation(reservation)
      { 'id' => reservation['id'], 'price' => calc_price(tee_time, reservation) }
    end

    def calc_price(tee_time, reservation)
      tee_time['price_per_golfer'] * reservation['number_of_golfers']
    end

    def find_tee_time_for_reservation(reservation)
      tee_times.detect { |tee| tee['id'] == reservation['tee_time_id'] }
    end
  end
end
