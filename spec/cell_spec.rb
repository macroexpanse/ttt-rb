require_relative '../ttt.rb'
require_relative '../lib/cell.rb'
require_relative '../lib/ai.rb'
require 'rack/test'

set :environment, :test

def app
  Sinatra::Application
end

describe 'Cell Service' do
  let(:ai) { Ai.new }
  let(:cell) { Cell.new({'id' => '5', 'row' => '1', 
  										'column' => '2', 'right_x' => false, 
  										'left_x' => false, 'value' => ''}) }

  it 'initializes correctly from data' do
  	[cell.id, cell.row, cell.column, cell.right_x, cell.left_x, cell.value].should == 
  	[5, 1, 2, false, false, '']
  end

  it 'converts to json using the custom method' do
  	json_cell = cell.to_json
  	json_cell.should == {'id' => 5, 'row' => 1, 'column' => 2, 
  											'right_x' => false, 'left_x' => false, 'value' => ''}
  end

end
