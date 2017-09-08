# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

last_n_averages = (n, x, buffer) ->
    i = undefined
    sum_x = undefined
    average_x = x
    buffer.push x
    sum_x = 0
    i = 0
    while i < buffer.length
      sum_x += buffer[i]
      i++
    average_x = sum_x / buffer.length
    if buffer.length > n
        buffer.shift()
    average_x

# detects if moving past a buffer
changing_lots = (x, buffer_num = 10) ->
    x > buffer_num

post_n_sec = (q, tag, message) ->
    setTimeout (->
        $("#gesture").html(message)
    ), (q * 1000)

buffer_alpha = []
buffer_beta = []
buffer_gamma = []
buffer_x = []
buffer_y = []
buffer_z = []

n = 10

orientationStill = true
motionStill = true

average_alpha = []
average_beta = []
average_gamma = []

window.addEventListener 'deviceorientation', (event) ->
    alpha = event.alpha
    beta = event.beta
    gamma = event.gamma
    
    a = last_n_averages(n, alpha, buffer_alpha).toFixed()
    b = last_n_averages(n, beta, buffer_beta).toFixed()
    g = last_n_averages(n, gamma, buffer_gamma).toFixed()
    # console.log "alpha: " + event.alpha + ' beta: ' + event.beta + ' gamma: ' + event.gamma

    $("#orientation").html(a + "," + b + "," + g)

    average_alpha.push a
    average_beta.push b
    average_gamma.push g

    #last_n_averages(n, gamma, buffer_gamma)

    if average_alpha.length > 2
        average_alpha.shift()
    if average_beta.length > 2
        average_beta.shift()
    if average_gamma.length > 2
        average_gamma.shift()

    # $("#gesture").html("average_alpha: " + (Math.abs average_alpha[0] - average_alpha[1])

    tilt = 25

    if average_beta[0] > tilt
        $("#gesture").html("PITCH++")
        $("#event").html("play")
        orientationStill = false
    else if average_beta[0] < -tilt
        $("#gesture").html("PITCH--")
        $("#event").html("pause")
        orientationStill = false
    else if average_gamma[0] > tilt
        $("#gesture").html("ROLL++")
        $("#event").html("forward")
        orientationStill = false
    else if average_gamma[0] < -tilt
        $("#gesture").html("ROLL--")
        $("#event").html("rewind")
        orientationStill = false
    else if average_alpha[0] > 300
        $("#gesture").html("YAW--")
        $("#event").html("pause")
        orientationStill = false
    else if average_alpha[0] < 250
            $("#gesture").html("YAW++")
            $("#event").html("play")
            orientationStill = false
    else
        if motionStill
            $("#gesture").html("STILL")
        orientationStill = true

window.addEventListener 'devicemotion', (event) ->
    x_acc = event.acceleration.x * 100
    y_acc = event.acceleration.y * 100
    z_acc = event.acceleration.z * 100

    average_x = last_n_averages(30, x_acc, buffer_x)
    average_y = last_n_averages(30, y_acc, buffer_y)
    average_z = last_n_averages(30, z_acc, buffer_z)

    $("#acceleration").html(average_x.toFixed() + "," + average_y.toFixed() + "," + average_z.toFixed())
    
    m = 20
    # time = 5

    if average_x > m || average_y > m || average_z > m
        motionStill = false
        
        max = Math.max average_x, average_y, average_z
        # console.log "*******max: " + max.to_s
        
        if max == average_x
            # post_n_sec time, 'gesture', "Right Gesture"
            $("#gesture").html("Right Gesture")
        if max == average_y
            $("#gesture").html("Forward Gesture")
            $("#event").html("play")
        if max == average_z
            $("#gesture").html("Up Gesture")

    else if average_x < -m || average_y < -m || average_z < -m
        motionStill = false
        
        min = Math.min average_x, average_y, average_z
        # console.log "*******min: " + min.to_s
        
        if min == average_x
            $("#gesture").html("Left Gesture")
        if min == average_y
            $("#gesture").html("Backwards Gesture")
        if min == average_z
            $("#gesture").html("Down Gesture")

    else
        if orientationStill
            $("#gesture").html("STILL")
            $("#event").html("still")
        motionStill = true

    
    # if average_x > n
    #     $("#gesture").html("Right Gesture"
    #     motionStill = false
    # else if average_x < -n
    #     $("#gesture").html("Left Gesture"
    #     motionStill = false
    # else if average_y > n
    #     $("#gesture").html("Forward Gesture"
    #     motionStill = false
    # else if average_y < -n
    #     $("#gesture").html("Backwards Gesture"
    #     motionStill = false
    # else if average_z > n
    #     $("#gesture").html("Up Gesture"
    #     motionStill = false
    # else if average_z < -n
    #     $("#gesture").html("Down Gesture"
    #     motionStill = false
    # else
    #     if orientationStill
    #         $("#gesture").html("STILL"
    #     motionStill = true
        
