require 'train_station'
require 'pg'

DB = PG.connect(:dbname => 'train_system')

RSpec.configure do |config|
	config.after(:each) do
		DB.exec("DELETE FROM stations *;")
	end
end

describe TrainStation do
	it 'is initialized with a name and location' do
		station = TrainStation.new('NEW', 'Newton, KS', 1)
		station.should be_an_instance_of TrainStation
	end

	it 'tells you its name' do
		station = TrainStation.new('NEW', 'Newton, KS', 1)
		station.name.should eq 'NEW'
	end

	it 'tells you its location' do
		station = TrainStation.new('NEW', 'Newton, KS', 1)
		station.location.should eq 'Newton, KS'
	end

	it 'allows users to see all stations' do
		TrainStation.all.should eq []
	end

	it 'allows operators to add new stations' do
		station = TrainStation.new('NEW', 'Newton, KS', 1)
		station.add
		TrainStation.all.first.name.should eq 'NEW'
	end

	it 'allows you to access its id' do
		station = TrainStation.new('NEW', 'Newton, KS', 1)
		station.id.should eq 1
	end
end