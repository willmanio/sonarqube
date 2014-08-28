actions :update
default_action :update

attribute :file, name_attribute: true, kind_of: String
attribute :username, kind_of: String
attribute :password, kind_of: String
attribute :url, kind_of: String
