module ErrorHandler
  extend ActiveSupport::Concern
  include ApiResponses

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :invalid_token

    rescue_from MemberNotFoundError, with: :member_not_found
    rescue_from InsufficientPermissionsError, with: :insufficient_permissions

    rescue_from PositionNotFoundError, with: :position_not_found

    rescue_from EpisodeStaffIncompleteError, with: :episode_incomplete
    rescue_from EpisodePositionStaffNotFoundError, with: :position_staff_not_found
    rescue_from StaffNotFoundError, with: :staff_not_found
    rescue_from UnairedEpisodeError, with: :unaired_episode

    rescue_from ShowFinishedError, with: :show_finished
    rescue_from ShowNotFoundError, with: :unknown_show
    rescue_from MultipleMatchingShowsError, with: :multiple_shows
  end

  #
  # Error messages are defined below for API consistency
  #

  def invalid_token
    error_response 404, "Invalid token."
  end

  def member_not_found
    error_response 401, "You are not a group member. Please ping an admin and ask to be added."
  end

  def insufficient_permissions
    error_response 401, "You are not a group admin."
  end

  def position_not_found
    error_response 404, "Unknown position."
  end

  def episode_incomplete(exception)
    error_response 400, exception.message
  end

  def position_staff_not_found
    error_response 404, "There are no episode staff for that position."
  end

  def staff_not_found
    error_response 400, "You don't have permission to modify that position."
  end

  def unaired_episode
    error_response 400, "The current episode has not aired yet."
  end

  def show_finished
    error_response 400, "That show is already complete."
  end

  def unknown_show
    error_response 404, "No matching show found."
  end

  def multiple_shows(exception)
    error_response 400, exception.message
  end
end
