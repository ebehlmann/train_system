require 'pg'
require 'rspec'
require 'train_station'
require 'line'

DB = PG.connect(:dbname => 'train_system')

class Stop
	def initialize(station_id, line_id)
		@line_id = line_id
		@station_id = station_id
	end

	def save
		DB.exec("INSERT INTO stations_lines (station_id, line_id) VALUES '#{station_id}''#{line_id}';")
	end

	def self.all
		results = DB.exec("SELECT * FROM stops;")
		stops = []
		results.each do |result|
			station_id = result['station_id']
			line_id = result['line_id']
			stops << Stop.new(station_id, line_id)
		end
		stops
	end

	def self.all_on_one_line(line)
		results = DB.exec("SELECT * FROM stops WHERE line_id = #{line};")
		stations = []
		results.each do |result|
			station_id = result['station_id'].to_i
			station_to_add = DB.exec("SELECT * FROM train_stations WHERE id = #{station_id};")
			station_to_add_name = station_to_add['name']
			station_to_add_location = station_to_add['location']
			stations << TrainStation.new(station_to_add_name, station_to_add_location)
		end
		stations
	end

	def self.all_at_one_station(station)
		results = DB.exec("SELECT * FROM stops WHERE station_id = #{station};")
		lines = []
		results.each do |result|
			line_id = result['line_id'].to_i
			line_to_add = DB.exec("SELECT * FROM lines WHERE id = #{line_id};")
			line_to_add_name = line_to_add['name']
			lines << Lines.new(line_to_add_name)
		end
		lines
	end
end