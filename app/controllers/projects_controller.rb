class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    set_group
    authenticate_group!

    add_breadcrumb "Groups", groups_url
    add_breadcrumb @group.name, group_url(@group)

    @accepted = @group.projects.includes(:group, :show)
                               .joins(:show)
                               .where(status: :accepted)
                               .where("shows.projects_count > ?", 1)

    @declined = @group.projects.includes(:group, :show)
                               .joins(:show)
                               .where(status: :declined)

    @pending = @group.projects.includes(:group, :show).where(status: :pending)
  end

  def new
    set_group
    set_show
    authenticate_group!

    add_breadcrumb "Groups", groups_url
    add_breadcrumb @group.name, group_url(@group)
    add_breadcrumb "Shows", group_shows_url(@group)
    add_breadcrumb @show.name, group_show_url(@group, @show)

    @project = Project.new
    @groups = Group.joins(:projects).where.not(projects: @show.projects).distinct
  end

  def create
    set_group
    set_show
    authenticate_group!

    group = Group.find(params[:project][:group].to_i.abs)
    @project = Project.new(show: @show, group: group)

    if @project.save
      redirect_to group_show_url(@group, @show)
    else
      render 'new'
    end
  end

  def update
    @project = Project.find(params[:id])

    unless current_user.shows.exists? @project.show.id
      redirect_to root_url, alert: "You can't modify that show!"
    end

    @project.update(status: params[:status])

    if @project.save
      if @project.accepted?
        redirect_to group_show_url(@project.group, @project.show), notice: "Added #{@project.show.name} to your shows!"
      else
        redirect_to request.referer, notice: "Removed #{@project.group.name} from this show."
      end
    else
      redirect_to request.referer, notice: "Error removing #{@project.group.name} from this show."
    end
  end

  def destroy
    set_group
    authenticate_group!

    @project = @group.projects.find(params[:id])

    if @project.destroy
      redirect_to request.referer, notice: "Removed #{@project.show.name}"
    else
      redirect_to request.referer, notice: "Error removing #{@project.show.name}"
    end
  end
end
