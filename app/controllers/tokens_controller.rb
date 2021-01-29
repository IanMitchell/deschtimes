class TokensController < ApplicationController
  before_action do
    authenticate_user!
    set_group
  end

  def update
    @group.generate_token

    if @group.save
      redirect_to group_url(@group), notice: 'Your token has been regenerated.'
    else
      redirect_to group_url(@group), alert: 'There was a problem regenerating your token.'
    end
  end
end
