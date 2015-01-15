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

  def created_at
    object.created_at.to_formatted_s(:short)
  end
end