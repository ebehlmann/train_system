require 'pg'
require 'rspec'
require 'train_station'
require 'line'

DB = PG.connect(:dbname => 'train_system')

class Stop
	attr_reader :station_id, :line_id
	def initialize(arguments = {})
		@station_id = arguments[:station_id]
		@line_id = arguments[:line_id]
	end

	def add
		DB.exec("INSERT INTO stations_lines (station_id, line_id) VALUES (#{station_id}, #{line_id});")
	end

	def self.all
		results = DB.exec("SELECT * FROM stations_lines;")
		stops = []
		results.each do |result|
			stops << Stop.new(station_id: result['station_id'].to_i, line_id: result['line_id'].to_i)
		end
		stops
	end

	def self.all_on_one_line(line)
		results = DB.exec("SELECT * FROM stations_lines WHERE line_id = #{line};")
		stations = []
		results.each do |result|
			station_id = result['station_id'].to_i
			station_to_add = DB.exec("SELECT * FROM stations WHERE id = #{station_id};")
			stations << TrainStation.new(name: station_to_add['name'], location: station_to_add['location'])
		end
		stations
	end

	def self.all_at_one_station(station)
		results = DB.exec("SELECT * FROM stations_lines WHERE station_id = #{station};")
		lines = []
		results.each do |result|
			line_id = result['line_id'].to_i
			line_to_add = DB.exec("SELECT * FROM lines WHERE id = #{line_id};")
			lines << Line.new(name: line_to_add['name'])
		end
		lines
	end
end