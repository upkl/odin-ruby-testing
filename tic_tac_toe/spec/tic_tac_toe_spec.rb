# frozen_string_literal: true

require './lib/tic_tac_toe'

describe Player do
  describe '#move' do
    let(:board) { double }
    subject(:player) { described_class.new('W', board) }
    it 'sends arguments to board correctly' do
      allow(player).to receive(:gets).and_return(123, 478)
      expect(board).to receive(:put).with(123, 478, 'W').and_return(true)
      allow(board).to receive(:check).and_return(false)
      player.move
    end
    it 'repeats if arguments are rejected' do
      allow(player).to receive(:gets).and_return(111, 222, 333, 444)
      expect(board).to receive(:put).with(333, 444, 'W').and_return(true)
      allow(board).to receive(:put).with(any_args).and_return(false)
      allow(board).to receive(:check).and_return(false)
      player.move
    end
    it 'announces the winner' do
      allow(player).to receive(:gets).and_return(111, 222)
      expect(board).to receive(:put).with(111, 222, 'W').and_return(true)
      allow(board).to receive(:put).with(any_args).and_return(true)
      allow(board).to receive(:check).and_return('W')
      allow(player).to receive(:puts).with(any_args)
      expect(player).to receive(:puts).with('I won!')
      player.move
    end
    it 'does not announce the player as winner if he did not win' do
      allow(player).to receive(:gets).and_return(111, 222)
      expect(board).to receive(:put).with(111, 222, 'W').and_return(true)
      allow(board).to receive(:put).with(any_args).and_return(true)
      allow(board).to receive(:check).and_return('Z')
      allow(player).to receive(:puts).with(any_args)
      expect(player).not_to receive(:puts).with('I won!')
      player.move
    end
  end
end

describe Board do
  describe '#to_s' do
    context 'when the board is empty' do
      subject(:board) { described_class.new }
      it 'returns the correct string' do
        output = board.to_s
        pieces_line = "#{' |' * (SIZE - 1)} "
        middle_line = "#{'-+' * (SIZE - 1)}-"
        expected = ("#{pieces_line}\n#{middle_line}\n" * (SIZE - 1)) + pieces_line
        expect(output).to eq(expected)
      end
    end

    context 'with 3 pieces' do
      subject(:board) { described_class.new }
      before do
        board.put 1, 1, 'X'
        board.put 2, 2, 'O'
        board.put 1, 2, 'X'
      end
      it 'returns the correct string' do
        output = board.to_s
        pieces_line_one = "X|X#{'| ' * (SIZE - 2)}"
        pieces_line_two = " |O#{'| ' * (SIZE - 2)}"
        pieces_line = "#{' |' * (SIZE - 1)} "
        middle_line = "#{'-+' * (SIZE - 1)}-"
        expected = "#{pieces_line_one}\n#{middle_line}\n#{pieces_line_two}" \
                   + ("\n#{middle_line}\n#{pieces_line}" * (SIZE - 2))
        expect(output).to eq(expected)
      end
    end
  end

  describe '#put' do
    context 'when the board is empty' do
      subject(:board) { described_class.new }
      it 'does not accept values below 1' do
        output_row = board.put 0, 1, 'X'
        expect(output_row).to be false
        output_col = board.put 1, 0, 'O'
        expect(output_col).to be false
      end
      it 'does not accept values above SIZE' do
        output_row = board.put SIZE + 1, 1, 'X'
        expect(output_row).to be false
        output_col = board.put 1, SIZE + 1, 'O'
        expect(output_col).to be false
      end
      it 'accepts pieces to be put into corners' do
        output_nw = board.put 1, 1, 'A'
        output_ne = board.put 1, SIZE, 'B'
        output_sw = board.put SIZE, 1, 'C'
        output_se = board.put SIZE, SIZE, 'D'
        pieces_first_line = "A#{'| ' * (SIZE - 2)}|B"
        pieces_last_line = "C#{'| ' * (SIZE - 2)}|D"
        pieces_line = "#{' |' * (SIZE - 1)} "
        middle_line = "#{'-+' * (SIZE - 1)}-"
        expected_str = pieces_first_line \
                       + ("\n#{middle_line}\n#{pieces_line}" * (SIZE - 2)) \
                       + "\n#{middle_line}\n#{pieces_last_line}"
        expect(output_nw).to be true
        expect(output_ne).to be true
        expect(output_sw).to be true
        expect(output_se).to be true
        expect(board.to_s).to eq(expected_str)
      end
    end

    context 'When a field is occupied' do
      subject(:board) { described_class.new }
      before :each do
        board.put 1, 1, 'X'
      end
      it 'returns false' do
        expect(board.put(1, 1, 'O')).to be false
      end

      it 'leaves the board unchanged' do
        expect { board.put(1, 1, 'O') }.not_to change(board, :to_s)
      end
    end
  end

  describe '#check' do
    context 'when the board is empty' do
      subject(:board) { described_class.new }
      it 'noone wins' do
        expect(board.check).to be_nil
      end
    end

    context 'when there is no winner' do
      subject(:board) { described_class.new }
      before do
        (1...SIZE).each do |row|
          (1...SIZE).each { |col| board.put(row, col, 'X') }
        end
      end
      it 'noone wins' do
        expect(board.check).to be_nil
      end
    end

    context 'when \'X\' occupies row 1' do
      subject(:board) { described_class.new }
      before do
        (1..SIZE).each { |col| board.put(1, col, 'X') }
      end
      it '\'X\' wins' do
        expect(board.check).to eq('X')
      end
    end

    context 'when \'O\' occupies col SIZE' do
      subject(:board) { described_class.new }
      before do
        (1..SIZE).each { |row| board.put(row, SIZE, 'O') }
      end
      it '\'O\' wins' do
        expect(board.check).to eq('O')
      end
    end

    context 'when \'X\' occupies row (SIZE - 1)' do
      subject(:board) { described_class.new }
      before do
        (1..SIZE).each { |col| board.put(SIZE - 1, col, 'X') }
      end
      it '\'X\' wins' do
        expect(board.check).to eq('X')
      end
    end

    context 'when \'O\' occupies col 2' do
      subject(:board) { described_class.new }
      before do
        (1..SIZE).each { |row| board.put(row, 2, 'O') }
      end
      it '\'O\' wins' do
        expect(board.check).to eq('O')
      end
    end

    context 'when \'O\' occupies nw/se diagonal' do
      subject(:board) { described_class.new }
      before do
        (1..SIZE).each { |row| board.put(row, row, 'O') }
      end
      it '\'O\' wins' do
        expect(board.check).to eq('O')
      end
    end

    context 'when \'X\' occupies ne/sw diagonal' do
      subject(:board) { described_class.new }
      before do
        (1..SIZE).each { |row| board.put(row, SIZE + 1 - row, 'X') }
      end
      it '\'X\' wins' do
        expect(board.check).to eq('X')
      end
    end
  end

  describe '#free?' do
    context 'when the board is empty' do
      subject(:board) { described_class.new }
      it 'returns true' do
        expect(board.free?).to be true
      end
    end

    context 'when there are some pieces' do
      subject(:board) { described_class.new }
      before do
        board.put 1, 1, 'A'
        board.put 1, SIZE, 'B'
        board.put SIZE, 1, 'C'
      end
      it 'returns true' do
        expect(board.free?).to be true
      end
    end

    context 'when every field is occupied' do
      subject(:board) { described_class.new }
      before do
        (1..SIZE).each do |row|
          (1..SIZE).each { |col| board.put(row, col, 'X') }
        end
      end
      it 'returns false' do
        expect(board.free?).to be false
      end
    end
  end
end

describe Game do
  describe '#run' do
    let(:board) { Board.new }
    let(:p1) { double 'player1' }
    let(:p2) { double 'player2' }
    subject(:game) { described_class.new(board, p1, p2) }
    it 'ends in a draw when the board is full without winner' do
      p1_values = []
      p2_values = []
      winner = nil
      allow(p1).to receive(:symbol).and_return('R')
      allow(p2).to receive(:symbol).and_return('T')
      allow(p1).to receive(:move) do
        row, col = p1_values.shift
        board.put row, col, 'R'
        winner = board.check
      end
      allow(p2).to receive(:move) do
        row, col = p2_values.shift
        board.put row, col, 'T'
        winner = board.check
      end
      (1..SIZE).each do |row|
        offset = (row / 2)
        (1..SIZE).each do |col|
          col_adjusted = ((col - 1 + offset) % SIZE) + 1
          if (row + col_adjusted).even?
            p1_values << [row, col]
          else
            p2_values << [row, col]
          end
        end
      end
      expect { game.run }.to output(/Draw/).to_stdout
      expect(winner).to be_nil
    end
    it 'reports the correct winner' do
      p1_values = []
      p2_values = []
      winner = nil
      allow(p1).to receive(:symbol).and_return('R')
      allow(p2).to receive(:symbol).and_return('T')
      allow(p1).to receive(:move) do
        row, col = p1_values.shift
        board.put row, col, 'R'
        winner = board.check
      end
      allow(p2).to receive(:move) do
        row, col = p2_values.shift
        board.put row, col, 'T'
        winner = board.check
      end
      (1..SIZE).each do |row|
        p1_values << [row, 1]
        p2_values << [row, 2]
      end
      expect { game.run }.not_to output(/Draw/).to_stdout
      expect(winner).to eq 'R'
    end
  end
end
