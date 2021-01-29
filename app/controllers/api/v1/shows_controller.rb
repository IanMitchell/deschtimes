module Api
  module V1
    class Api::V1::ShowsController < ApplicationController
      include ErrorHandler

      respond_to :json

      def show
        @group = Group.find_by!(token: params[:group_token])
        @show = @group.priority_show_search!(URI.decode_www_form_component(params[:name]))
      end
    end
  end
end
