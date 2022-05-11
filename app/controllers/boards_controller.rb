class BoardsController < ApplicationController
  def index
    @boards = Board.all
  end

  def show
    @board = Board.find(params[:id])
  end

  def create
    @board = Board.new(board_params)
    if @board.save
      redirect_to boards_path(@board)
    else
      render 'static_pages/home'
    end
  end

  private
  def board_params
    params.require(:board).permit(:email, :width, :height, :no_mines, :name)
  end
end