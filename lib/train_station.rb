require 'pg'
require 'rspec'

DB = PG.connect(:dbname => 'train_system')

class Train_station
	def initialize(name, location)
		@name = name
		@location = location
	end

	def name
		@name
	end

	def location
		@location
	end

	def self.all
		results = DB.exec("SELECT * FROM stations;")
		stations = []
		results.each do |result|
			name = result['name']
			location = result['location']
			stations << Train_station.new(name, location)
		end
		stations
	end

	def add
		DB.exec("INSERT INTO stations (name, location) VALUES ('#{name}', '#{location}');")
	end

	def ==(another_station)
		self.name == another_station.name && self.location == another_station.location
	end
end