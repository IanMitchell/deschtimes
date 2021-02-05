class StaffController < ApplicationController
  before_action do
    authenticate_user!

    set_group
    set_show
    set_episode

    add_breadcrumb "Groups", groups_url
    add_breadcrumb @group.name, group_url(@group)
    add_breadcrumb "Shows", group_shows_url(@group)
    add_breadcrumb @show.name, group_show_url(@group, @show)
    add_breadcrumb "Episodes", group_show_episodes_url(@group, @show)
    add_breadcrumb "Episode #{@episode.number}", group_show_episode_url(@group, @show, @episode)
  end

  def new
    @staff = Staff.new(episode: @episode)
  end

  def create
    @staff = Staff.new
    @staff.episode = @episode
    @staff.position = @group.positions.find(params["staff"]["position"].to_i)
    @staff.member = @group.members.find(params["staff"]["member"].to_i)

    if @staff.save
      redirect_to group_show_episode_url(@group, @show, @episode)
    else
      render 'new'
    end
  end

  def edit
    @staff = @episode.staff.find(params[:id])
  end

  def update
    @staff = @episode.staff.find(params[:id])

    if @staff.update(staff_params)
      redirect_to group_show_episode_url(@group, @show, @episode), notice: "#{@staff.member.name} Updated"
    else
      render 'edit'
    end
  end

  def destroy
    @staff = @episode.staff.find(params[:id])

    if @staff.destroy
      redirect_to group_show_episode_url(@group, @show, @episode), notice: "#{@staff.title(@show.joint?)} removed."
    else
      redirect_to group_show_episode_url(@group, @show, @episode), alert: "#{@staff.title(@show.joint?)} could not be removed."
    end
  end

  private
    def staff_params
    params.require(:staff).permit(:member_id, :position_id, :finished)
  end
end
