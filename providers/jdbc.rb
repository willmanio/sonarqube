def whyrun_supported?
  true
end

action :update do
  file = Chef::Util::FileEdit.new(new_resource.file)
  file.search_file_replace_line(/^sonar\.jdbc\.username=/, "sonar.jdbc.username=#{new_resource.username}")
  file.search_file_replace_line(/^sonar\.jdbc\.password=/, "sonar.jdbc.pasword=#{new_resource.password}")
  file.search_file_replace_line(/^# Comment the following line to deactivate the default embedded database\./, '# Database URL')
  file.search_file_replace_line(/^sonar\.jdbc\.url=/, "sonar.jdbc.url=#{new_resource.url}")
  file.write_file
  new_resource.updated_by_last_action(file.file_edited?)
end
