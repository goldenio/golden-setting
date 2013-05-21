$ ->
  $('.settings')
    .on 'change', '#setting_field_type', ->
      switch $(this).val()
        when 'string', 'boolean'
          $('.setting_field_values').hide()
        else
          $('.setting_field_values').show()
