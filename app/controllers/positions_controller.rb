class PositionsController < ApplicationController
  before_action do
    authenticate_user!
    set_group
    authenticate_group!

    add_breadcrumb "Groups", groups_url
    add_breadcrumb @group.name, group_url(@group)
  end

  def index
  end

  def new
    @position = Position.new
  end

  def edit
    add_breadcrumb "Positions", group_positions_url(@group)
    @position = @group.positions.find(params[:id])
  end

  def create
    @position = Position.new(position_params)
    @position.group = @group

    if @position.save
      redirect_to group_positions_url(@group)
    else
      render 'new'
    end
  end

  def update
    @position = @group.positions.find(params[:id])

    if @position.update(position_params)
      redirect_to group_positions_url(@group), notice: "Updated #{@position.name}"
    else
      render 'edit'
    end
  end

  def destroy
    @position = @group.positions.find(params[:id])

    if @position.destroy
      redirect_to group_positions_url(@group), notice: "Deleted #{@position.name}"
    else
      render 'edit'
    end
  end

  private
    def position_params
      params.require(:position).permit(:name, :acronym)
    end
end
