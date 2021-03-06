module Api
  module V1
    class StaffController < ApplicationController
      include ErrorHandler
      include ApiResponses

      respond_to :json
      protect_from_forgery with: :null_session

      def update
        finished = ActiveRecord::Type::Boolean.new.deserialize(params[:finished])
        return error_response 400, "Please provide the finished parameter." if finished.nil?

        @group = Group.find_by!(token: params[:group_token])
        @show = @group.priority_show_search!(URI.decode_www_form_component(params[:show_name]))
        @member = @group.members.find_by(discord: params[:member])

        if params[:episode_number].nil?
          @episode = @show.current_unreleased_episode
        else
          @episode = @show.episodes.find_by(number: params[:episode_number])

          if @episode.nil?
            return error_response 404, "Could not find episode ##{params[:episode_number]}"
          end
        end

        raise MemberNotFoundError if @member.nil?
        raise ShowFinishedError if @show.finished?
        raise UnairedEpisodeError unless @episode.aired?

        @positions = Position.where_name_or_acronym_equals!(params[:position]).where(group: @show.groups)
        @staff = @episode.find_staff_for_member_and_position!(@member, @positions, finished)

        if @staff.finished == finished
          error_response 400, "Your position is already marked as #{finished ? 'complete' : 'incomplete'}."
        elsif @staff.update(finished: finished)
          @show = Show.includes(episodes: [staff: [:position, member: [:group]]]).find(@show.id)
          render 'api/v1/shows/show'
        else
          error_response 500, "Error updating #{@show.name}"
        end
      end
    end
  end
end
