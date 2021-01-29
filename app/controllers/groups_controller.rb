class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_group!, only: [:show, :update, :destroy]

  before_action do
    authenticate_user!

    add_breadcrumb "Groups", groups_url
  end

  def index
    @groups = current_user.groups
  end

  def show
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      # Add logged in user to the group
      AuthorizedUser.create(user: current_user, group: @group, owner: true)

      redirect_to @group
    else
      render 'new'
    end
  end

  def update
    if @group.update(group_params)
      redirect_to group_url(@group), notice: "#{@group.name} Updated"
    else
      render 'edit'
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_url, notice: "#{@group.name} has been deleted."
  end

  private
    def set_group
      @group = current_user.groups.friendly.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :acronym, :icon)
    end
end
