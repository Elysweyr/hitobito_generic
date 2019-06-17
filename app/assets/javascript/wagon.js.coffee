toggleSepaFields = ->
  value = $('select#person_payment_method').val()
  if value == "sepa"
    $(".sepa-fields").show()
  else
    $(".sepa-fields").hide()

$(document).on('change', 'select#person_payment_method', toggleSepaFields)
$(document).on('ready page:load turbolinks:load', toggleSepaFields)
