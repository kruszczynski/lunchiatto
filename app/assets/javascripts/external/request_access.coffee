$form = $(".request-access-form")
$form.on 'ajax:success', () ->
  $form.parent().html('<h3 class="small text-center">We will invite you shortly</h3>')

$form.on 'ajax:error', (xhr, status) ->
  alert status.responseJSON.errors.join(" ")