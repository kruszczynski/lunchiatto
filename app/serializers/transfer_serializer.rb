class TransferSerializer < ActiveModel::Serializer
  attributes :id, :amount, :status

  has_one :from
  has_one :to

  def amount
    object.amount.to_s
  end
end