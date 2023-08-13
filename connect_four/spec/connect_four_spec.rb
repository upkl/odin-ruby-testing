require './lib/connect_four.rb'

describe Board do
  describe "#to_s" do
    subject(:board) { described_class.new }
    it "returns the correct string" do
      pieces_line = "|" + " " * COLS + "|"
      bottom_line = "+" + "-" * COLS + "+"
      expected = (pieces_line + "\n") * ROWS + bottom_line
      output = board.to_s
      expect(output).to eq(expected)
    end
  end

  describe "#put" do
    subject(:board) { described_class.new }
    it "accepts a single piece" do
      pieces_line = "|" + " " * COLS + "|"
      pieces_line_2 = "|A" + " " * (COLS - 1) + "|"
      bottom_line = "+" + "-" * COLS + "+"
      expected = (pieces_line + "\n") * (ROWS - 1) + pieces_line_2 \
               + "\n" + bottom_line
      expect(board.put 1, "A").to eq "A"
      output = board.to_s
      expect(output).to eq(expected)
    end
    it "accepts two pieces" do
      pieces_line = "|" + " " * COLS + "|"
      pieces_line_2 = "|" + " " * (COLS - 1) + "B|"
      bottom_line = "+" + "-" * COLS + "+"
      expected = (pieces_line + "\n") * (ROWS - 2) \
               + (pieces_line_2 + "\n") * 2 \
               + bottom_line
      expect(board.put COLS, "B").to eq "B"
      expect(board.put COLS, "B").to eq "B"
      output = board.to_s
      expect(output).to eq(expected)
    end
    it "refuses to accept more pieces than rows" do
      (1..ROWS).each { expect(board.put 2, "Z").to eq "Z"}
      expect(board.put 2, "Z").to be_nil
    end
    it "orders pieces correctly" do
      sequence = ["A", "U", "O", "H", "3", "?"]
      expected_lines = sequence.reverse.map { |piece| "|" + piece + " " * (COLS - 1) + "|" }
      bottom_line = "+" + "-" * COLS + "+"
      expected = expected_lines.join("\n") + "\n" + bottom_line
      sequence.each { |piece| expect(board.put 1, piece).to eq piece }
      output = board.to_s
      expect(output).to eq(expected)
    end
  end

  describe "#winner" do
    subject(:board) { described_class.new }
    it "returns nil on an empty board" do
      expect(board.winner).to be_nil
    end
    it "finds a winner in column 1" do
      (1..WIN).each { board.put 1, "/"}
      expect(board.winner).to eq ("/")
    end
    it "does not accept one piece less" do
      (1..WIN - 1).each { board.put 1, "/"}
      expect(board.winner).to be_nil
    end
    it "does not accept mixed columns" do
      (1..WIN).each { |n| board.put 1, n.to_s }
      expect(board.winner).to be_nil
    end
  
    it "accepts a horizontal sequence" do
      (1..WIN - 2).each do |row|
        (1..WIN - 1).each { |col| board.put col, "A" }
        board.put WIN, "C"
      end
      (1..WIN).each { |col| board.put col, "B"}
      expect(board.winner).to eq ("B")
    end

    it "accepts a diagonal sequence" do
      (1..WIN).each do |cols|
        (1..cols).each { |col| board.put col, cols.to_s}
      end
      expect(board.winner).to eq(WIN.to_s)
    end
  end
end

describe Player do
  describe "#initialize" do
    subject(:player) { described_class.new "*" }
    it "initializes the symbol correctly" do
      expect(player.symbol).to eq("*")
    end
  end

  describe "#read_move" do
    subject(:player) { described_class.new "?" }
    it "returns a correct value" do
      allow(player).to receive(:gets).and_return("3\n")
      expect(player.read_move).to eq(3)
    end
    it "rejects invalid input and returns the first correct input" do
      allow(player).to receive(:gets).and_return("-1\n", "#{COLS + 1}\n", "#{COLS}\n", "1\n")
      expect(player.read_move).to eq(COLS)
    end
  end
end

describe Game do
  describe "#move" do
  end
end