require "spec_helper"


describe BalanceMailer, type: :mailer do
  describe '#debt_email' do
    let(:user) { create :user }
    let(:other_user) { create :other_user }
    let(:balances) do
      balance_one = build :user_balance do |b|
        b.user = user
        b.payer = user
        b.balance = 10
      end
      balance_one.save!
      balance_two = build :user_balance do |b|
        b.user = user
        b.payer = other_user
        b.balance = 40
      end
      balance_two.save!
      [balance_one,balance_two]
    end
    let(:mail) { BalanceMailer.debt_email(user,balances) }

    it 'renders the subject' do
      expect(mail.subject).to eql('Bartek Szef you owe people money!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql(['bartek@test.net'])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['noreply@codequest-manager.herokuapp.com'])
    end
  end

end
