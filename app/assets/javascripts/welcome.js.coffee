# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  window.cookie= (cname)->
    cvalues = document.cookie.split(';')
    return x.split('=')[1] for x in cvalues when x.split('=')[0].trim() == cname

  $('#voter_name').val(cookie('name'))

  $('#voter_name').on 'blur', ->
    document.cookie = "name=#{$('#voter_name').val()}"

  socket = new WebSocket "ws://#{window.location.host}/vote.js"

  socket.onmessage = (event) ->
    if event.data.length
      vote = JSON.parse(event.data)
      if $("##{vote["voter"]} .vote-value").length
        $("##{vote["voter"]} .vote-value").html vote['vote']
      else
        $(".votes").append "<div id='#{vote["voter"]}' class='voted vote'>#{vote["voter"]}<br/><span class='vote-value' >#{vote['vote']}</span>"

  $('.votable').on 'click', ->
    # window.location.replace("/welcome/vote?n=#{developer_name}&vote=#{ $(@).html() }")
    event.preventDefault()
    $input = $('#voter_name').val() 
    $input = cookie('name') unless $input
    unless $input
      alert 'enter your name!'
      return false
    document.cookie = "name=#{$input}" 
    socket.send JSON.stringify({voter: $input, vote: $(@).html()})
