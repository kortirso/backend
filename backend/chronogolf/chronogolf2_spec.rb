require_relative 'chronogolf'

RSpec.describe Chronogolf do
  let!(:service) { Chronogolf.new('../level2/data/input.json') }

  describe '.initialize' do
    it 'service has tee_times variable' do
      expect(service.tee_times.is_a?(Array)).to eq true
      expect(service.tee_times.size).to eq 1
    end

    it 'service has reservations variable' do
      expect(service.reservations.is_a?(Array)).to eq true
      expect(service.reservations.size).to eq 2
    end
  end

  describe '.adapted_prices' do
    before { service.adapted_prices }

    it 'creates output file' do
      expect(File.file?('./prices_adaptation_output.json')).to eq true
    end

    it 'and json in output file equals to json in test output file' do
      output = JSON.parse(File.read('./prices_adaptation_output.json'))
      test_output = JSON.parse(File.read('../level2/data/output.json'))

      expect(output == test_output).to eq true
    end
  end

  describe '.adaption_koefficient' do
    context 'for 7 days difference' do
      let!(:reservation) { service.reservations[0] }
      let!(:tee_time) { service.send(:find_tee_time_for_reservation, reservation) }

      it 'returns 0.8' do
        result = service.send(:adaption_koefficient, tee_time, reservation)

        expect(result).to eq 0.8
      end
    end

    context 'for the same day' do
      let!(:reservation) { service.reservations[1] }
      let!(:tee_time) { service.send(:find_tee_time_for_reservation, reservation) }

      it 'returns 1.05' do
        result = service.send(:adaption_koefficient, tee_time, reservation)

        expect(result).to eq 1.05
      end
    end
  end

  describe '.calc_price_adaptation' do
    let!(:reservation) { service.reservations.sample }
    let!(:tee_time) { service.send(:find_tee_time_for_reservation, reservation) }

    it 'returns hash with id and price for reservation' do
      result = service.send(:calc_price_adaptation, reservation)

      expect(result.is_a?(Hash)).to eq true
      expect(result['id']).to eq reservation['id']
      expect(result['price']).to eq service.send(:calc_adapted_price, tee_time, reservation).round
    end
  end

  describe '.calc_adapted_price' do
    let!(:reservation) { service.reservations.sample }
    let!(:tee_time) { service.send(:find_tee_time_for_reservation, reservation) }

    it 'returns result of price adaptation' do
      result = service.send(:calc_adapted_price, tee_time, reservation)

      expect(result).to eq service.send(:calc_price, tee_time, reservation) * service.send(:adaption_koefficient, tee_time, reservation)
    end
  end
end
