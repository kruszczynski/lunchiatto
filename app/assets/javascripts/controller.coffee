@CodequestManager.Controller =
  dashboard: ->
    CodequestManager.Dashboard.Controller.layout()
  editDish: ->
    CodequestManager.Dishes.Controller.form()
  finances: ->
    console.log 'finances'