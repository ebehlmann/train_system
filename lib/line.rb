require 'pg'
require 'rspec'

DB = PG.connect(:dbname => 'train_system')

class Line
	attr_reader :id, :name
	def initialize(arguments = {})
		@name = arguments[:name]
		@id = arguments[:id]
	end

	def self.all
		results = DB.exec("SELECT * FROM lines;")
		#puts results.first['name']
		lines = []
		results.each do |result|
			lines << Line.new(name: result['name'], id: result['id'])
		end
		lines
	end

	def save
		results = DB.exec("INSERT INTO lines (name) VALUES ('#{@name}') RETURNING id;")
		@id = results.first['id'].to_i
	end
end