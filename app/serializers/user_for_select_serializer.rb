# frozen_string_literal: true
class UserForSelectSerializer < ActiveModel::Serializer
  attributes :name, :id, :account_number
end
