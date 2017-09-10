window.Lunchiatto.module('Balance', function(Balance, App, Backbone, Marionette, $, _) {
  Balance.Balance = Marionette.ItemView.extend({
    className: 'balance-box',
    template: 'balances/balance',

    templateHelpers() {
      return {
        formattedBalance: this.formattedBalance(),
        amountClass: this.amountClass(),
        transferLink: this.transferLink(),
        adequateUser: this._adequateUser()
      };
    },

    amountClass() {
      if (!this.model.get('balance')) { return; }
      const modifier = +this.model.get('balance') >= 0 ? 'positive' : 'negative';
      return `money-box--${modifier}`;
    },

    formattedBalance() {
      const account_balance = this.model.get('balance');
      return (account_balance && `${account_balance} PLN`) || 'N/A';
    },

    transferLink() {
      return `/transfers/new?to_id=${this.model.get('user_id')}\
&amount=${-this.model.get('balance')}`;
    },

    _adequateUser() {
      return this.model.get('user');
    }
  });
});
