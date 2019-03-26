require 'date'

class Chronogolf
  # Module for price adaptation
  module AdaptedPrices
    SECONDS_IN_DAY = 86_400.0

    # call method
    def adapted_prices
      save_file('./prices_adaptation_output.json', calc_price_adaptations)
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

      return 1.05 if same_day?(starts_at, reserved_at)
      days_difference = calc_days_difference(starts_at, reserved_at)
      return 0.8 if days_difference > 7
      return 0.9 if days_difference <= 7 && days_difference > 2
      1
    end

    def same_day?(date1, date2)
      date1.strftime('%Y-%m-%d') == date2.strftime('%Y-%m-%d')
    end

    def calc_days_difference(date1, date2)
      (date1.to_time.to_i - date2.to_time.to_i) / SECONDS_IN_DAY
    end
  end
end
