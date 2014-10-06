require 'line'
require 'pg'

DB = PG.connect(:dbname => 'train_system')

RSpec.configure do |config|
	config.after(:each) do
		DB.exec("DELETE FROM lines *;")
	end
end

describe Line do
	it 'is initialized with a name' do
		test_line = Line.new(name: 'Southwest Chief')
		test_line.should be_an_instance_of Line
	end

	it 'lets you see its name' do
		test_line = Line.new(name: 'Southwest Chief')
		test_line.name.should eq 'Southwest Chief'
	end

	it 'allows users to see all lines' do
		Line.all.should eq []
	end

	it 'allows operators to add new lines' do
		test_line = Line.new(name: 'Southwest Chief')
		test_line.add
		puts test_line.inspect
		Line.all.first.name.should eq 'Southwest Chief'
	end
end