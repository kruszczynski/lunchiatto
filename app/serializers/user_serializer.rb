class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :substract_from_self, :account_number
end