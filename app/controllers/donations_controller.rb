class DonationsController < ApplicationController
  before_action do
    add_breadcrumb "Donations", donations_url
  end

  def index
  end
end
