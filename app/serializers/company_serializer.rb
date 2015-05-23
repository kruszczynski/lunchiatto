class CompanySerializer < ActiveModel::Serializer
  attributes :name
  has_many :users
  has_many :invitations
end
