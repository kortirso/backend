class Chronogolf
  # Module for fee calculation
  module Fee
    TOTAL_FEE_KOEF = 0.03
    PAYMENT_GATEWAY_FEE_KOEF = 0.019
    PAYMENT_GATEWAY_FEE_CONSTANT = 0.3

    # call method
    def fee
      File.write('./fee_output.json', { 'reservations' => calc_fee_for_reservations }.to_json)
    end

    private

    def calc_fee_for_reservations
      reservations.map!(&method(:calc_fee_for_reservation))
    end

    def calc_fee_for_reservation(reservation)
      tee_time = find_tee_time_for_reservation(reservation)
      price = calc_adapted_price(tee_time, reservation).round
      { 'id' => reservation['id'], 'price' => price, 'fee' => calc_fee(price) }
    end

    def calc_fee(price)
      total_fee = (price * TOTAL_FEE_KOEF).round(2)
      payment_gateway_fee = (price * PAYMENT_GATEWAY_FEE_KOEF + PAYMENT_GATEWAY_FEE_CONSTANT).round(2)
      chronogolf_fee = (total_fee - payment_gateway_fee).round(2)
      { 'payment_gateway_fee' => payment_gateway_fee, 'chronogolf_fee' => chronogolf_fee }
    end
  end
end
