$form = $(".request-access-form")
$form.on 'ajax:complete', ->
  $form.parent()
    .html('<h3 class="small text-center">We will invite you shortly</h3>')
