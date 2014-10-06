require 'stop'
require 'line'
require 'train_station'
require 'pg'

DB = PG.connect(:dbname => 'train_system')

#RSpec.configure do |config|
#	config.after(:each) do
#		DB.exec("DELETE FROM stations_lines *;")
#	end
#end

describe Stop do
	it 'is initialized with a station id and a line id' do
		stop = Stop.new(station_id: 1, line_id: 1)
		stop.should be_an_instance_of Stop
	end

	it 'can tell you its station id' do
		stop = Stop.new(station_id: 1, line_id: 1)
		stop.station_id.should eq 1
	end

	it 'can tell you its line id' do
		stop = Stop.new(station_id: 1, line_id: 1)
		stop.line_id.should eq 1
	end

	it 'allows operators to add new stops' do
		stop = Stop.new(station_id: 1, line_id: 1)
		stop.add
		Stop.all.first.station_id.should eq 1
	end

	it 'tells you which lines go through a station' do
		station = TrainStation.new(name: 'NEW', location: 'Newton, KS')
		station.add
		line = Line.new(name: 'Southwest Chief')
		line2 = Line.new(name: 'Zephyr')
		line.add
		stop = Stop.new(station_id: station.id, line_id: line.id)
		stop.add
		Stop.all_at_one_station(station.id).should eq line
	end

#	it 'tells you which stations a line visits' do
#		station = TrainStation.new(name: 'NEW', location: 'Newton, KS')
#		station.add
#		line = Line.new(name: 'Southwest Chief')
#		line2 = Line.new(name: 'Zephyr')
#		line.add
#		stop = Stop.new(station_id: station.id, line_id: line.id)
#		stop.add
#		Stop.all_on_one_line(line.id).should eq station
#	end
end