require_relative '../ttt'
require 'ai'
require 'spec_helper'

describe 'Cell Service' do
  let(:ai) { Ai.new }
  let(:cell) { Cell.new({:id => 5, :position => 'b3', :value => nil}, 'nonminimax') }

  it 'initializes correctly from data' do
  	[cell.position, cell.row, cell.column, cell.right_x, cell.left_x, cell.value].should ==
  	['b3', 'b', '3', false, false, nil]
  end

  it 'converts to json using the custom method' do
  	hash_cell = cell.to_hash
  	hash_cell.should == {:id => 5, :position => 'b3', :value => nil}
  end

  it 'adds win to json when there are winning cells' do
    cell.win = true
    hash_cell = cell.to_hash
    hash_cell.should == {:id => 5, :position => 'b3', :value => nil, :win => true }
  end

  it 'initializes without row, column, or diagonal values when ai is minimax' do 
    hash_cell = {:id => 0, :position => 'a1', :value => nil}.to_json
    cell = Cell.build([hash_cell], 'minimax').first
    expect([cell.row, cell.column, cell.right_x, cell.left_x]).to eq [nil, nil, nil, nil]
  end

end
