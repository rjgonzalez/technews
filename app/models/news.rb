class News
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  field :url, type: String
end
