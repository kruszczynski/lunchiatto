require 'spec_helper'

describe DishPresenter do
  before do
    @user = create(:user)
    @order = build(:order) do |order|
      order.user = @user
    end
    @order.save
    @dish = build(:dish) do |dish|
      dish.user = @user
      dish.order = @order
    end
    @dish.save!
    @dish = @dish.decorate
    allow(@dish).to receive(:current_user).and_return(@user)
    @presenter = DishPresenter.new(@dish, @user)
    @other_user = create :other_user
  end

  it '#initialize' do
    expect(@presenter.current_user).to be(@user)
    expect(@presenter.dish).to be(@dish)
  end

  describe '#table_buttons' do
    it 'calls necessary methods' do
      expect(@presenter).to receive(:edit_button).and_return('edit_button')
      expect(@presenter).to receive(:delete_button).and_return('delete_button')
      expect(@presenter).to receive(:copy_button).and_return('copy_button')
      expect(@presenter.table_buttons).to eq('edit_buttondelete_buttoncopy_button')
    end
    it 'works well with nils' do
      expect(@presenter).to receive(:edit_button).and_return(nil)
      expect(@presenter).to receive(:delete_button).and_return(nil)
      expect(@presenter).to receive(:copy_button).and_return(nil)
      expect(@presenter.table_buttons).to eq('')
    end
  end

  describe '#edit_button' do
    before do
      @expected = '<a class="margin-right-small" href="\/orders\/.*?\/dishes\/.*?\/edit">Edit</a>'
    end
    it 'returns nil when dish belongs to different user' do
      allow(@dish).to receive(:current_user).and_return(@other_user)
      expect(@presenter.edit_button).to be_nil
    end
    it 'returns nil when order is delivered' do
      @order.delivered!
      expect(@presenter.edit_button).to be_nil
    end
    describe 'order in_progress' do
      it 'returns button when current_user' do
        expect(@presenter.edit_button).to match(@expected)
      end
      it 'returns nil when other user' do
        allow(@dish).to receive(:current_user).and_return(@other_user)
        expect(@presenter.edit_button).to be_nil
      end
    end
    describe 'order ordered' do
      before do
        @order.ordered!
      end
      it 'return button viewed by payer' do
        allow(@dish).to receive(:current_user).and_return(@other_user)
        allow(@dish).to receive(:order_by_current_user?).and_return(true)
        expect(@presenter.edit_button).to match(@expected)
      end
      it 'returns button viewed by creator' do
        expect(@presenter.edit_button).to match(@expected)
      end
      it 'returns nil viewed bo anybody else' do
        allow(@dish).to receive(:current_user).and_return(@other_user)
        expect(@presenter.edit_button).to be_nil
      end
    end
  end

  describe '#delete_button' do
    it 'returns nil when dish belongs to different user' do
      allow(@dish).to receive(:current_user).and_return(@other_user)
      expect(@presenter.delete_button).to be_nil
    end
    it 'returns button when order is in_progress' do
      expected = '<a data-confirm="Are you sure\?" data-method="delete" href="\/orders\/.*?\/dishes\/.*?" rel="nofollow">Delete</a>'
      expect(@presenter.delete_button).to match(expected)
    end
    describe 'otherwise' do
      it 'returns nil when order is ordered' do
        @order.ordered!
        expect(@presenter.delete_button).to be_nil
      end
      it 'returns nil when order is delivered' do
        @order.delivered!
        expect(@presenter.delete_button).to be_nil
      end
    end
  end

  describe '#copy_button' do
    describe 'order is in_progress' do
      it 'returns nil if dish belongs to current user' do
        expect(@presenter.copy_button).to be_nil
      end
      it 'returns button when not' do
        allow(@dish).to receive(:current_user).and_return(@other_user)
        expected = '<a data-confirm="This will overwrite your current dish! Are you sure\?" href="\/orders\/.*?\/dishes\/.*?\/copy">Copy</a>'
        expect(@presenter.copy_button).to match(expected)
      end
    end
    describe 'otherwise' do
      it 'returns nil when order is ordered' do
        @order.ordered!
        expect(@presenter.copy_button).to be_nil
      end
      it 'returns nil when order is delivered' do
        @order.delivered!
        expect(@presenter.copy_button).to be_nil
      end
    end
  end
end