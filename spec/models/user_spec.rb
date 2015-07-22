require 'spec_helper'

describe User do
  it { should have_many(:orders) }
  it { should have_many(:user_balances) }
  it { should have_many(:balances_as_payer) }
  it { should have_many(:submitted_transfers) }
  it { should have_many(:received_transfers) }
  it { should belong_to(:company) }
  it { should callback(:add_first_balance).after(:create) }

  let(:user) { create(:user) }
  let(:payer) { create(:other_user) }
  let!(:balance_one) { create :user_balance, user: user, payer: payer, balance: 15 }
  let!(:balance_two) { create :user_balance, user: user, payer: payer, balance: 17 }
  let!(:balance_three) { create :user_balance, user: user, payer: user, balance: 34 }

  describe '#balances' do
    it 'should return adequate' do
      expect(UserBalance).to receive(:balances_for).with(user).and_return([balance_two, balance_three])
      balances = user.balances
      expect(balances.count).to be(2)
    end
  end

  describe '#add_first_balance' do
    before do
      @user = User.new
    end
    it 'should create a user_balance' do
      balances = double('UserBalances')
      expect(balances).to receive(:create).with({balance: 0, payer: @user})
      expect(@user).to receive(:user_balances).and_return(balances)
      @user.add_first_balance
    end
  end

  describe '#subtract' do
    it 'add a new reduced user balance' do
      money = Money.new 1200, 'PLN'
      expect(user).to receive(:payer_balance).with(payer).and_return(Money.new(5000, 'PLN'))
      expect { user.subtract(money, payer) }.to change(user.user_balances, :count).by(1)
    end
    it 'doesnt reduce when subtract_from_self is false' do
      money = Money.new 1200, 'PLN'
      expect(user).to receive(:subtract_from_self).and_return(false)
      expect(user).to_not receive(:payer_balance).with(user)
      expect { user.subtract(money, user) }.to_not change(user.user_balances, :count)
    end
    it 'does reduce when subtract_from_self is true' do
      money = Money.new 1200, 'PLN'
      expect(user).to receive(:payer_balance).with(user).and_return(Money.new(5000, 'PLN'))
      expect(user).to receive(:subtract_from_self).and_return(true)
      expect { user.subtract(money, user) }.to change(user.user_balances, :count).by(1)
    end
  end

  describe '#to_s' do
    it 'should call name' do
      expect(user).to receive(:name).and_return('mock name')
      expect(user.to_s).to eq('mock name')
    end
  end

  describe '#payer_balance' do
    it 'calls scope method' do
      payer = double('Payer')
      expect(payer).to receive(:id).and_return(5)
      user_balances = double('UserBalances')
      balance = double('UserBalance')
      newest_for_payer = double('UserBalance')
      expect(newest_for_payer).to receive(:balance).and_return(balance)
      expect(user_balances).to receive(:newest_for).with(5).and_return(newest_for_payer)
      expect(user).to receive(:user_balances).and_return(user_balances)
      expect(user.payer_balance(payer)).to eq(balance)
    end
  end

  describe '#total_balance' do
    it 'returns proper balance' do
      money = Money.new 5100, 'PLN'
      expect(user.total_balance).to eq(money)
    end
  end

  describe '#debt_to' do
    let(:user_2) { create :other_user, email: 'janek@yolo.com' }
    let!(:balance_four) { create :user_balance, user: user_2, payer: payer, balance: 100 }

    it 'returns debt of user_2' do
      expect(user_2.debt_to(payer)).to eq(Money.new(10000, 'PLN'))
    end
  end

  describe '#debts' do
    it 'returns adequate' do
      expect(UserBalance).to receive(:debts_to).with(user).and_return(:debts)
      expect(user.debts).to be(:debts)
    end
  end

  describe '#total_debt' do
    it 'returns proper balance' do
      money = Money.new 3400, 'PLN'
      expect(user.total_debt).to eq(money)
    end
  end

  describe '#pending_transfers_count' do
    let!(:transfer_one) { create :transfer, from: user, to: payer }
    let!(:transfer_two) { create :transfer, from: payer, to: user }
    it 'returns adequate count' do
      expect(user.pending_transfers_count).to eq(1)
    end
  end

  describe "admin scope" do
    let(:admin) { create :user, admin: true, email: "admin@adminbook.com" }
    before do
      user
      payer
      admin
    end
    it "Only returns admin" do
      expect(User.admin.count).to be(1)
    end
  end
end
