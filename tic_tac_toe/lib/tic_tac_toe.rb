# frozen_string_literal: true

SIZE = 3

# the player interface
class Player
  attr_reader :symbol

  def initialize(symbol, board)
    @symbol = symbol
    @board = board
  end

  def move
    loop do
      puts @board
      puts "Row? (1..#{SIZE})"
      row = gets.to_i
      puts "Column? (1..#{SIZE})"
      col = gets.to_i
      break if @board.put(row, col, @symbol)

      puts 'Falsche Einabe oder Feld nicht frei'
    end
    w = @board.check
    puts 'I won!' if w == @symbol
  end
end

# the "board" fot TicTacToe
class Board
  attr_reader :winner

  def initialize
    @state = (1..SIZE).each_with_object([]) do |_, rresult|
      rresult.append((1..SIZE).each_with_object([]) do |_, result|
                       result.append(' ')
                     end)
    end
    @winner = nil
    @free = SIZE * SIZE
  end

  def to_s
    rows = @state.reduce([]) { |rresult, row| rresult.append(row.join('|')) }
    rows.join("\n#{'-+' * (SIZE - 1)}-\n")
  end

  def put(row, col, symbol)
    return false unless row.between?(1, SIZE) && col.between?(1, SIZE)
    return false if @state[row - 1][col - 1] != ' '

    @state[row - 1][col - 1] = symbol
    @free -= 1
    true
  end

  def check
    check_row((0...SIZE).map { |x| @state[x][x] }) and return @winner
    check_row((0...SIZE).map { |x| @state[x][SIZE - 1 - x] }) and return @winner
    (0...SIZE).each do |y|
      check_row((0...SIZE).map { |x| @state[y][x] }) and return @winner
      check_row((0...SIZE).map { |x| @state[x][y] }) and return @winner
    end
    nil
  end

  def free?
    @free.positive?
  end

  private

  def check_row(row)
    s = row.sort.uniq
    if s.length == 1 && s[0] != ' '
      @winner = s[0]
      return true
    end
    false
  end
end

# This models a TicTacToe Game: A board and two players
class Game
  def initialize(board, player1, player2)
    @board = board
    @p1 = player1
    @p2 = player2
  end

  def run
    loop do
      puts "\nPlayer 1\n"
      @p1.move
      break if @board.winner || !@board.free?

      puts "\nPlayer 2\n"
      @p2.move
      break if @board.winner || !@board.free?
    end
    puts 'Draw' unless @board.winner
    puts @board
  end
end

# board = Board.new
# p1 =  Player.new "X", board
# p2 = Player.new "O", board
# game = Game.new board, p1, p2
# game.run
