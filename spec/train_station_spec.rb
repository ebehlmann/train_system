require 'train_station'
require 'pg'

DB = PG.connect(:dbname => 'train_system')

RSpec.configure do |config|
	config.after(:each) do
		DB.exec("DELETE FROM stations *;")
	end
end

describe Train_station do
	it 'is initialized with a name and location' do
		station = Train_station.new('NEW', 'Newton, KS')
		station.should be_an_instance_of Train_station
	end

	it 'tells you its name' do
		station = Train_station.new('NEW', 'Newton, KS')
		station.name.should eq 'NEW'
	end

	it 'tells you its location' do
		station = Train_station.new('NEW', 'Newton, KS')
		station.location.should eq 'Newton, KS'
	end

	it 'allows users to see all stations' do
		Train_station.all.should eq []
	end

	it 'allows operators to add new stations' do
		station = Train_station.new('NEW', 'Newton, KS')
		station.add
		Train_station.all.should eq [station]
	end
end