class UsersController < ApplicationController
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
    @authorized_user = AuthorizedUser.new
  end

  def create
    user = User.find_by(email: params[:authorized_user][:email])

    if user.nil?
      return redirect_to new_group_user_url(@group), alert: "No user found with that email."
    end

    @authorized_user = AuthorizedUser.new(group: @group, user: user)

    if @authorized_user.save
      redirect_to group_users_url(@group)
    else
      render 'new'
    end
  end

  def destroy
    @authorized_user = @group.authorized_users.find(params[:id])

    if @authorized_user.owner?
      redirect_to group_users_url(@group), notice: "You cannot remove the owner."
    elsif @authorized_user.destroy
      redirect_to group_users_url(@group), notice: "Removed #{@authorized_user.user.name}"
    else
      render group_users_url(@group)
    end
  end
end
