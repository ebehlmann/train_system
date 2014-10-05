require 'pg'
require 'rspec'

DB = PG.connect(:dbname => 'train_system')

class TrainStation
	def initialize(name, location, id)
		@name = name
		@location = location
		@id = id
	end

	def name
		@name
	end

	def location
		@location
	end

	def id
		@id
	end

	def self.all
		results = DB.exec("SELECT * FROM stations;")
		stations = []
		results.each do |result|
			name = result['name']
			location = result['location']
			id = result['id']
			stations << TrainStation.new(name, location, id)
		end
		stations
	end

	def add
		DB.exec("INSERT INTO stations (name, location) VALUES ('#{name}', '#{location}');")
	end
end