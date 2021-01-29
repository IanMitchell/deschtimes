module ProjectsHelper
  def status_color_classes(status)
    case status
    when "accepted"
      "bg-green-100 text-green-800"
    when "declined"
      "bg-red-100 text-red-800"
    when "pending"
      "bg-yellow-100 text-yellow-800"
    end
  end
end
