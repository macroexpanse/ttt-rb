require 'command_line_interface'
require 'cell_factory'
require 'board'

describe CommandLineInterface do
  let(:cli) { CommandLineInterface.new }

  it "outputs message" do
    greeting_output = described_class::GREETING + "\n"
    expect { cli.output_message("GREETING") }.to output(greeting_output).to_stdout
  end

  context "ai type" do
    it "gets simple ai type" do
      allow(cli).to receive(:accept_input).and_return("1")
      expect(cli.get_ai_type).to eq("simple")
    end

    it "gets minimax ai type" do
      allow(cli).to receive(:accept_input).and_return("0")
      expect(cli.get_ai_type).to eq("minimax")
    end
  end

  context "board height" do
    it "gets 3x3 board height" do
      allow(cli).to receive(:accept_input).and_return(3)
      expect(cli.get_board_height).to eq(3)
    end

    it "gets 4x4 board height" do
      allow(cli).to receive(:accept_input).and_return(4)
      expect(cli.get_board_height).to eq(4)
    end

    it "defaults to 3x3 board height when outside allowed range" do
      allow(cli).to receive(:accept_input).and_return(100)
      expect(cli.get_board_height).to eq(3)
    end
  end

  context "first player name" do
    it "gets human first player option" do
      allow(cli).to receive(:accept_input).and_return("1")
      expect(cli.get_first_player_name).to eq("human")
    end

    it "gets ai first player option" do
      allow(cli).to receive(:accept_input).and_return("0")
      expect(cli.get_first_player_name).to eq("ai")
    end
  end

  context "human value" do
    it "gets O value" do
      allow(cli).to receive(:accept_input).and_return("O")
      expect(cli.get_human_value).to eq("O")
    end

    it "gets X value" do
      allow(cli).to receive(:accept_input).and_return("X")
      expect(cli.get_human_value).to eq("X")
    end

    it "defaults to X" do
      allow(cli).to receive(:accept_input).and_return("foobar")
      expect(cli.get_human_value).to eq("X")
    end
  end

  context "3x3" do
    let(:cells) { CellFactory.new(:ai_type => 'minimax').generate_cells(:board_height => 3) }

    it "draws 3x3" do
      board = Board.new(:cells => cells)
      string_board = " | | \n | | \n | | \n"
      expect { cli.draw_board(board) }.to output(string_board).to_stdout
    end

    it "draws board with cells filled" do
      board = Board.new(:cells => cells)
      board.fill_cell(0, "X")
      board.fill_cell(4, "O")
      string_board = "X| | \n |O| \n | | \n"
      expect { cli.draw_board(board) }.to output(string_board).to_stdout
    end

    it "responds to player loss" do
      board = Board.new(:cells => cells)
      loss_response = " | | \n | | \n | | \n #{described_class::LOSS}\n"
      expect { cli.player_loss_response(board) }.to output(loss_response).to_stdout
    end

    it "responds to draw" do
      board = Board.new(:cells => cells)
      draw_response = " | | \n | | \n | | \n #{described_class::DRAW}\n"
      expect { cli.draw_response(board) }.to output(draw_response).to_stdout
    end
  end

  context "4x4" do
    it "draws 4x4" do
      cells = CellFactory.new(:ai_type => 'minimax').generate_cells(:board_height => 4)
      board = Board.new(:cells => cells)
      string_board = " | | | \n | | | \n | | | \n | | | \n"
      expect { cli.draw_board(board) }.to output(string_board).to_stdout
    end
  end
end

