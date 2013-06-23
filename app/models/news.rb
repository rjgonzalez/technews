class News
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  field :url, type: String
  field :name, type: String
  field :twitter, type: String
  field :email, type: String
end
