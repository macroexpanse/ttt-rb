require_relative '../ttt.rb'
require 'ai.rb'
require 'spec_helper.rb'

describe 'Cell Service' do
  let(:ai) { Ai.new }
  let(:cell) { Cell.new({:id => 5, :position => 'b3', :value => nil}) }

  it 'initializes correctly from data' do
  	[cell.position, cell.row, cell.column, cell.right_x, cell.left_x, cell.value].should ==
  	['b3', 'b', '3', false, false, nil]
  end

  it 'converts to json using the custom method' do
  	json_cell = cell.to_json
  	json_cell.should == {:id => 5, :position => 'b3', :value => nil}
  end

  it 'adds win to json when there are winning cells' do
    cell.win = true
    json_cell = cell.to_json
    json_cell.should == {:id => 5, :position => 'b3', :value => nil, :win => true }
  end

end
