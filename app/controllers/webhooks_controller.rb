class WebhooksController < ApplicationController
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
    @webhook = Webhook.new
  end

  def edit
    add_breadcrumb "Webhooks", group_webhooks_url(@group)
    @webhook = @group.webhooks.find(params[:id])
  end

  def create
    @webhook = Webhook.new(webhook_params)
    @webhook.group = @group

    if @webhook.save
      redirect_to group_webhooks_url(@group)
    else
      render 'new'
    end
  end

  def update
    @webhook = @group.webhooks.find(params[:id])

    if @webhook.update(webhook_params)
      redirect_to group_webhooks_url(@group), notice: "Updated #{@webhook.name}"
    else
      render 'edit'
    end
  end

  def destroy
    @webhook = @group.webhooks.find(params[:id])

    if @webhook.destroy
      redirect_to group_webhooks_url(@group), notice: "Deleted #{@webhook.name}"
    else
      render 'edit'
    end
  end

  private
    def webhook_params
      params.require(:webhook).permit(:name, :platform, :url)
    end
end
