require 'pg'
require 'rspec'

DB = PG.connect(:dbname => 'train_system')

class Line
	def initialize(name)
		@name = name
	end

	def name
		@name
	end

	def self.all
		results = DB.exec("SELECT * FROM lines;")
		lines = []
		results.each do |result|
			name = result['name']
			lines << Line.new(name)
		end
		lines
	end

	def save
		DB.exec("INSERT INTO lines (name) VALUES ('#{@name}');")
	end

	def ==(another_line)
		self.name == another_line.name
	end
end