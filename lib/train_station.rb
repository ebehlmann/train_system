require 'pg'
require 'rspec'

DB = PG.connect(:dbname => 'train_system')

class TrainStation
	attr_reader :id, :name, :location
	def initialize(arguments = {})
		@name = arguments[:name]
		@location = arguments[:location]
		@id = arguments[:id]
	end

	def self.all
		results = DB.exec("SELECT * FROM stations;")
		stations = []
		results.each do |result|
			stations << TrainStation.new(name: result['name'], location: result['location'], id: result['id'])
		end
		stations
	end

	def add
		results = DB.exec("INSERT INTO stations (name, location) VALUES ('#{name}', '#{location}') RETURNING id;")
		@id = results.first['id'].to_i
	end
end