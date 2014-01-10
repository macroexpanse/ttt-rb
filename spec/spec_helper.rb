require_relative '../lib/cell.rb'
require 'spec_helper.rb'

class Cell
	DEFAULT_JSON_CELLS = [
	  {'id' => 'a1', 'value' => ''},
	  {'id' => 'a2', 'value' => ''},
	  {'id' => 'a3', 'value' => ''},
	  {'id' => 'b1', 'value' => ''},
	  {'id' => 'b2', 'value' => ''},
	  {'id' => 'b3', 'value' => ''},
	  {'id' => 'c1', 'value' => ''},
	  {'id' => 'c2', 'value' => ''},
	  {'id' => 'c3', 'value' => ''}
	].map { |cell| cell.to_json }
end

set :environment, :test

def app
  Sinatra::Application
end