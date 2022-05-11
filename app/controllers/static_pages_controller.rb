class StaticPagesController < ApplicationController
  def home
    @board = Board.new
    @boards = Board.all
  end
end
