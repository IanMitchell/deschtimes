module Api
  module V1
    class EpisodesController < ApplicationController
      include ErrorHandler
      include ApiResponses

      respond_to :json

      def update
        @group = Group.find_by!(token: params[:group_token])
        @show = @group.priority_show_search!(URI.decode_www_form_component(params[:show_name]))
        @member = @group.members.find_by(discord: params[:member])

        raise MemberNotFoundError if @member.nil?
        raise InsufficientPermissionsError unless @member.admin?
        raise ShowFinishedError if @show.finished?

        unfinished_staff = @show.current_unreleased_episode.staff.where(finished: false)
        if unfinished_staff.present?
          positions = unfinished_staff.map { |staff| staff.position.name }
          raise EpisodeStaffIncompleteError, "The #{positions.to_sentence} positions are still incomplete!"
        end

        @show.current_unreleased_episode.update(released: true)
        render 'api/v1/shows/show'
      end
    end
  end
end
