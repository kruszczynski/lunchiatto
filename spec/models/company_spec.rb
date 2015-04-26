require 'spec_helper'

describe Company, type: :model do
  it { should have_many(:users)}
  it { should validate_presence_of(:name) }
end
