module Api
  module V1
    class GroupsController < ApplicationController
      include ErrorHandler

      respond_to :json
      protect_from_forgery with: :null_session

      def index
        @groups = Group.all.order(id: :asc)
      end

      def show
        @group = Group.find_by!(token: params[:token])
      end
    end
  end
end
