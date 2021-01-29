module Api
  module V1
    class GroupsController < ApplicationController
      include ErrorHandler
      respond_to :json

      def index
        @groups = Group.all
      end

      def show
        @group = Group.find_by!(token: params[:token])
      end
    end
  end
end
