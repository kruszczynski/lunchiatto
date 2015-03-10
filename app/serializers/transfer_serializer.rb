class TransferSerializer < ActiveModel::Serializer
  attributes :id, :amount, :status, :from, :to, :created_at

  def amount
    object.amount.to_s
  end

  def from
    object.from.name
  end

  def to
    object.to.name
  end

  delegate :created_at, to: :object
end