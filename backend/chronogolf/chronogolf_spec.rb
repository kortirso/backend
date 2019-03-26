require_relative 'chronogolf'

RSpec.describe Chronogolf do
  let!(:service) { Chronogolf.new('../level1/data/input.json') }

  describe '.initialize' do
    it 'service has tee_times variable' do
      expect(service.tee_times.is_a?(Array)).to eq true
      expect(service.tee_times.size).to eq 3
    end

    it 'service has reservations variable' do
      expect(service.reservations.is_a?(Array)).to eq true
      expect(service.reservations.size).to eq 3
    end
  end

  describe '.prices' do
    before { service.prices }

    it 'creates output file' do
      expect(File.file?('./prices_output.json')).to eq true
    end

    it 'and json in output file equals to json in test output file' do
      output = JSON.parse(File.read('./prices_output.json'))
      test_output = JSON.parse(File.read('../level1/data/output.json'))

      expect(output == test_output).to eq true
    end
  end

  describe '.calc_price_for_reservation' do
    let!(:reservation) { service.reservations.sample }
    let!(:tee_time) { service.tee_times.detect { |tee| tee['id'] == reservation['tee_time_id'] } }

    it 'returns hash with id and price for reservation' do
      result = service.send(:calc_price_for_reservation, reservation)

      expect(result.is_a?(Hash)).to eq true
      expect(result['id']).to eq reservation['id']
      expect(result['price']).to eq tee_time['price_per_golfer'] * reservation['number_of_golfers']
    end
  end
end
