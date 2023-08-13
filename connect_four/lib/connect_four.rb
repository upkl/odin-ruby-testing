ROWS = 6
COLS = 7
WIN = 4

class Board
  def initialize
    @state = (1..ROWS).reduce([]) do |rresult, row|
      rresult.append((1..COLS).reduce([]) do |result, col|
                       result.append(" ")
                       result
                     end
                    )
      rresult
    end
  end

  def to_s
    string = (0...ROWS).to_a.reverse.reduce("") do |rresult, row|
      rresult += (0...COLS).reduce("|") do |result, col|
                       result += @state[row][col]
                       result
      end                   
      rresult + "|\n"
    end
    string + "+" + "-" * COLS + "+"
  end

  def put col, symbol
    col -= 1
    column_pieces = (0...ROWS).map { |row| @state[row][col]}
    row = column_pieces.find_index(" ")
    if row
      @state[row][col] = symbol
    end
  end

  def winner
    win_sequences.each do |sequence|
      get_pieces = sequence.map { |row, col| @state[row][col] }
      get_pieces = get_pieces.sort.uniq
      if get_pieces.length == 1 and get_pieces[0] != " "
        return get_pieces[0]
      end
    end

    nil
  end

  private
  def win_sequences
    result = []

    # horizontal sequences
    (0...ROWS).each do |row|
      (0...COLS - WIN + 1).each do |col|
        sequence = (0...WIN).map do |i|
          [row, col + i]
        end
        result << sequence
      end
    end

    # vertical sequences
    (0...COLS).each do |col|
      (0...ROWS - WIN + 1).each do |row|
        sequence = (0...WIN).map do |i|
          [row + i, col]
        end
        result << sequence
      end
    end

    # sw-ne sequences
    (0...ROWS - WIN + 1).each do |row|
      (0...COLS - WIN + 1).each do |col|
        sequence = (0...WIN).map do |i|
          [row + i, col + i]
        end
        result << sequence
      end
    end

    # se-nw sequences
    (0...ROWS - WIN + 1).each do |row|
      (0...COLS - WIN + 1).each do |col|
        sequence = (0...WIN).map do |i|
          [row + WIN - 1 - i, col + i]
        end
        result << sequence
      end
    end

    result
  end
end

class Player
  attr_reader :symbol
  def initialize symbol
    @symbol = symbol
  end

  def read_move
    begin
      puts "Enter move (1..#{COLS})"
      answer = gets.chomp.to_i
    end until 1 <= answer && answer <= COLS
    answer
  end
end

class Game
  def initialize
    @p1 = Player.new "X"
    @p2 = Player.new "O"
    @board = Board.new
  end

  def move player
    begin
      col = player.read_move
      ok = @board.put col, player.symbol
    end until ok
  end

  def run
    winner = nil
    loop do
      puts @board
      puts "Player 1"
      move @p1
      winner = @board.winner
      break if !winner.nil?
      puts @board
      puts "Player 2"
      move @p2
      winner = @board.winner
      break if !winner.nil?
    end
    puts "\"#{winner}\", you win."
  end
end