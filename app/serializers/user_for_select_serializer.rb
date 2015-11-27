# Serialize User in a simpler way for API
class UserForSelectSerializer < ActiveModel::Serializer
  attributes :name, :id, :account_number
end
