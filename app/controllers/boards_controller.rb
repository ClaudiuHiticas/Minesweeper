class BoardsController < ApplicationController
  def index
    if params[:all].present? && params[:all] == "true"
      @boards = Board.all
    else
      @boards = Board.last(10).reverse
    end
  end

  def show
    @board = Board.find(params[:id])
  end

  def create
    @board = Board.new(board_params)
    if @board.generate
      redirect_to boards_path
    else
      render 'static_pages/home'
    end
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
  end

  private
  def board_params
    params.require(:board).permit(:email, :width, :height, :no_mines, :name)
  end
end