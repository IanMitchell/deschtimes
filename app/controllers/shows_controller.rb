class ShowsController < ApplicationController
  before_action do
    authenticate_user!
    set_group

    add_breadcrumb "Groups", groups_url
    add_breadcrumb @group.name, group_url(@group)
  end

  def index
    @airing = @group.shows.airing
    @active = @group.shows.active.where.not(id: @airing)
    @finished = @group.shows.finished
  end

  def show
    add_breadcrumb "Shows", group_shows_url(@group)

    @show = @group.shows.find(params[:id])
  end

  def new
    add_breadcrumb "Shows", group_shows_url(@group)

    @show = Show.new
  end

  def create
    @show = Show.new(show_params)
    @show.new_show_group = @group

    # Switch from UTC to JST
    @show.new_show_episode_air_date -= 9.hours

    if @show.save
      Project.create(group: @group, show: @show, status: :accepted)
      redirect_to group_show_url(@group, @show)
    else
      # TODO: Prevents a weird string bug. Probably a better way of handling this
      @show.new_show_episode_air_date = @show.new_show_episode_air_date.to_datetime || DateTime.now

      render 'new'
    end
  end

  def edit
    @show = @group.shows.find(params[:id])
    add_breadcrumb "Shows", group_shows_url(@group)
  end

  def update
    @show = @group.shows.find(params[:id])

    if @show.update(show_params)
      redirect_to group_show_url(@group, @show), notice: "#{@show.name} Updated"
    else
      render 'edit'
    end
  end

  def destroy
    @show = @group.shows.find(params[:id])

    if @show.destroy
      redirect_to group_shows_url(@group), notice: "Show `#{@show.name}` removed."
    else
      redirect_to group_show_url(@group, @show), alert: "Show could not be removed."
    end
  end

  private
    def show_params
      params.require(:show).permit(:name, :poster, :visible, :status, :new_show_episode_count, :new_show_episode_air_date, :new_show_episode_number_start, new_show_staff: [:position, :member])
    end
end
