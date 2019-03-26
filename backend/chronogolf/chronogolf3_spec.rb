require_relative 'chronogolf'

RSpec.describe Chronogolf do
  let!(:service) { Chronogolf.new('../level3/data/input.json') }

  describe '.initialize' do
    it 'service has tee_times variable' do
      expect(service.tee_times.is_a?(Array)).to eq true
      expect(service.tee_times.size).to eq 1
    end

    it 'service has reservations variable' do
      expect(service.reservations.is_a?(Array)).to eq true
      expect(service.reservations.size).to eq 1
    end
  end

  describe '.adapted_prices' do
    before { service.fee }

    it 'creates output file' do
      expect(File.file?('./fee_output.json')).to eq true
    end

    it 'and json in output file equals to json in test output file' do
      output = JSON.parse(File.read('./fee_output.json'))
      test_output = JSON.parse(File.read('../level3/data/output.json'))

      expect(output == test_output).to eq true
    end
  end

  describe '.calc_fee_for_reservation' do
    let!(:reservation) { service.reservations.sample }
    let!(:tee_time) { service.send(:find_tee_time_for_reservation, reservation) }

    it 'returns hash with id and price for reservation' do
      result = service.send(:calc_fee_for_reservation, reservation)

      expect(result.is_a?(Hash)).to eq true
      expect(result['id']).to eq reservation['id']
      expect(result['price']).to eq service.send(:calc_adapted_price, tee_time, reservation).round
      expect(result['fee'].is_a?(Hash)).to eq true
    end
  end

  describe '.calc_fee' do
    let!(:price) { 32 }

    it 'returns hash with fees' do
      result = service.send(:calc_fee, price)

      expect(result.is_a?(Hash)).to eq true
      expect(result['payment_gateway_fee']).to eq 0.91
      expect(result['chronogolf_fee']).to eq 0.05
    end
  end
end
