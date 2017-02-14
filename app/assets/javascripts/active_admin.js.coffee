#= require active_admin/base
#= require chosen-jquery

$ ->
  $('#active_admin_content select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '240px'
