require_relative '../ttt.rb'
require_relative '../lib/ai.rb'
require 'spec_helper.rb'

describe 'Cell Service' do
  let(:ai) { Ai.new }
  let(:cell) { Cell.new({'id' => 'b3', 'value' => ''}) }

  it 'initializes correctly from data' do
  	[cell.id, cell.row, cell.column, cell.right_x, cell.left_x, cell.value].should ==
  	['b3', 'b', '3', false, false, '']
  end

  it 'converts to json using the custom method' do
  	json_cell = cell.to_json
  	json_cell.should == {'id' => 'b3', 'value' => ''}
  end

  it 'adds win to json when there are winning cells' do
    cell.win = true
    json_cell = cell.to_json
    json_cell.should == {'id' => 'b3', 'value' => '', 'win' => true }
  end

end
