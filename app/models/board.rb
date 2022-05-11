class Board < ApplicationRecord
  has_many :mines, dependent: :destroy
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true, length: { maximum: 50 }
  validates :height, presence: true, :numericality => { greater_than_or_equal_to: 0 }
  validates :width, presence: true, :numericality => { greater_than_or_equal_to: 0 }
  validates :no_mines, presence: true, :numericality => { greater_than_or_equal_to: 0 }
  validates_numericality_of :no_mines, :less_than => Proc.new { |minesweeper_board| minesweeper_board.width * minesweeper_board.height }


  def to_matrix
    matrix = Array.new(self.height) { Array.new(self.width) {nil} }
    mines = self.mines
    mines.each do |mine|
      matrix[mine.y][mine.x] = :mine
    end
    matrix
  end

  def generate
    return false if self.no_mines > self.height * self.width
    matrix = Array.new(self.height) { Array.new(self.width) {nil} }
    mines = []
    height_mine = *(0..self.height - 1)
    width_mine = *(0..self.width - 1)
    mines_location = height_mine.product(width_mine)
    mines_location.shuffle!
    (0..self.no_mines - 1).each do |i|
      x_pos = mines_location[i][0]
      y_pos = mines_location[i][1]
      matrix[y_pos][x_pos] = :mine
      mine = { x: x_pos, y: y_pos, created_at: Time.now, updated_at: Time.now }
      mines << mine
    end
    Board.transaction do
      self.save!
      Mine.insert_all(mines.map{ |mine| mine[:board_id] = self.id; mine })
    end
    matrix
  end

end
