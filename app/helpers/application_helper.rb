module ApplicationHelper

  def icon_action_link(icon_name, action_name, url_path)
    link_to_string = '<span class="pull-right" style="margin-right: 5px; font-size:12px;"><i class="' + icon_name + '"></i> ' + action_name + '</span>'
    link_to link_to_string.html_safe, url_path
  end

end
