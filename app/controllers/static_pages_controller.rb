class StaticPagesController < ApplicationController
  def home
    @board = Board.new
  end
end
