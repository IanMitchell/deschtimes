class EpisodesController < ApplicationController
  before_action do
    authenticate_user!
    set_group
    set_show

    add_breadcrumb "Groups", groups_url
    add_breadcrumb @group.name, group_url(@group)
    add_breadcrumb "Shows", group_shows_url(@group)
    add_breadcrumb @show.name, group_show_url(@group, @show)
  end

  def index
    @episodes = @show.episodes.order(number: :asc).includes(staff: :position)
  end

  def show
    add_breadcrumb "Episodes", group_show_episodes_url(@group, @show)

    @episode = @show.episodes.includes(staff: [:position, :member]).find(params[:id])
  end

  def new
    @episode = Episode.new(
      number: (@show.last_episode&.number || 0) + 1,
      air_date: (@show.last_episode&.air_date || DateTime.now) + 1.week
    )
  end

  def create
    @episode = Episode.new(episode_params)
    @episode.show = @show

    if @episode.save
      redirect_to group_show_episodes_url(@group, @show)
    else
      render 'new'
    end
  end

  def edit
    @episode = @show.episodes.find(params[:id])
    add_breadcrumb "Episodes", group_show_episodes_url(@group, @show)
  end

  def update
    @episode = @show.episodes.find(params[:id])

    if @episode.update(episode_params)
      if ActiveRecord::Type::Boolean.new.deserialize(params[:episode][:update_air_dates])
        @show.reschedule_episodes(@episode)
      end

      redirect_to group_show_episode_url(@group, @show, @episode), notice: "#{@show.name} episode #{@episode.number} Updated"
    else
      render 'edit'
    end
  end

  def destroy
  end

  private
  def episode_params
    params.require(:episode).permit(:number, :released, :air_date, :update_air_dates)
  end
end
