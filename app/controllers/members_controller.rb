class MembersController < ApplicationController
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
    @member = Member.new
  end

  def edit
    add_breadcrumb "Members", group_members_url(@group)
    @member = @group.members.find(params[:id])
  end

  def create
    @member = Member.new(member_params)
    @member.group = @group

    if @member.save
      redirect_to group_members_url(@group)
    else
      render 'new'
    end
  end

  def update
    @member = @group.members.find(params[:id])

    if @member.update(member_params)
      redirect_to group_members_url(@group), notice: "#{@member.name} Updated"
    else
      render 'edit'
    end
  end

  def destroy
    @member = @group.members.find(params[:id])

    if @member.destroy
      redirect_to group_members_url(@group), notice: "Deleted #{@member.name}."
    else
      render 'edit'
    end
  end

  private
    def member_params
      params.require(:member).permit(:name, :discord, :admin)
    end
end
