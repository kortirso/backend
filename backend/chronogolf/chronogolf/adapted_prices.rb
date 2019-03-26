require 'date'

class Chronogolf
  # Module for price adaptation
  module AdaptedPrices
    SECONDS_IN_DAY = 86_400.0

    # call method
    def adapted_prices
      File.write('./prices_adaptation_output.json', { 'reservations' => calc_price_adaptations }.to_json)
    end

    private

    def calc_price_adaptations
      reservations.map!(&method(:calc_price_adaptation))
    end

    def calc_price_adaptation(reservation)
      tee_time = find_tee_time_for_reservation(reservation)
      { 'id' => reservation['id'], 'price' => calc_adapted_price(tee_time, reservation).round }
    end

    def calc_adapted_price(tee_time, reservation)
      calc_price(tee_time, reservation) * adaption_koefficient(tee_time, reservation)
    end

    def adaption_koefficient(tee_time, reservation)
      starts_at = DateTime.parse(tee_time['starts_at'])
      reserved_at = DateTime.parse(reservation['reserved_at']).new_offset(starts_at.zone)

      if starts_at.strftime('%Y-%m-%d') == reserved_at.strftime('%Y-%m-%d')
        1.05
      else
        days_difference = (starts_at.to_time.to_i - reserved_at.to_time.to_i) / SECONDS_IN_DAY
        if days_difference > 7
          0.8
        elsif days_difference <= 7 && days_difference > 2
          0.9
        else
          1
        end
      end
    end
  end
end
