@CodequestManager.module "Dashboard", (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Settings = Marionette.ItemView.extend
  	template: "dashboard/settings"

  	ui:
      substract: ".substract"
      accountNumber: ".account-number"

    behaviors:
      Submittable: {}
      Animateable:
        types: ["fadeIn"]

    onFormSubmit: ->
      @model.save
        substract_from_self: @ui.substract.prop("checked")
        account_number: @ui.accountNumber.val()
      ,
        success: (model) ->
          App.router.navigate "/dashboard", {trigger: true}