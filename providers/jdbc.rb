def whyrun_supported?
  true
end

action :update do
  original_file = ::File.read(new_resource.file)
  file = Chef::Util::FileEdit.new(new_resource.file)
  if original_file.match(/^sonar\.jdbc\.username=#{Regexp.escape(new_resource.username)}$/).nil?
    file.search_file_replace_line(/^#?sonar\.jdbc\.username=/, "sonar.jdbc.username=#{new_resource.username}")
  end
  if original_file.match(/^sonar\.jdbc\.password=#{Regexp.escape(new_resource.password)}$/).nil?
    file.search_file_replace_line(/^#?sonar\.jdbc\.password=/, "sonar.jdbc.password=#{new_resource.password}")
  end
  if original_file.match(/^# Database URL$/).nil?
    file.search_file_replace_line(/^#----- MySQL.*$\./, '# Database URL')
  end
  if original_file.match(/^# Database URL$/).nil?
    file.search_file_replace_line(/^# Comment the following line to deactivate the default embedded database\./, '# Database URL')
  end
  if original_file.match(/^sonar\.jdbc\.url=#{Regexp.escape(new_resource.url)}$/).nil?
    file.search_file_replace_line(/^#?sonar\.jdbc\.url=/, "sonar.jdbc.url=#{new_resource.url}")
  end
  file.write_file
  new_resource.updated_by_last_action(file.file_edited?)
end
