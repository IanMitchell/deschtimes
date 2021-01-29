module WebhooksHelper
  def platform_color_classes(platform)
    case platform
    when "discord"
      "bg-purple-100 text-purple-800"
    when "generic"
    else
      "bg-gray-100 text-gray-800"
    end
  end
end
