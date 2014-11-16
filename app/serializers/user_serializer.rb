class UserSerializer < ActiveModel::Serializer
  attributes :name, :admin, :substract_from_self, :account_number
end