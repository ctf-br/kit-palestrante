window.coffeeTerm =

    update: ()->
        codeCoffee = @textarea.val()
        return if codeCoffee is @lastCodeCoffee
        @lastCodeCoffee = codeCoffee
        $('pre.code.coffee').html hljs.highlight('coffeescript', codeCoffee).value
        boxJs = $('pre.code.js').addClass 'highlight'
        setTimeout (-> $('pre.code.js').removeClass 'highlight'), 100
        try
            @lastCodeJs = CoffeeScript.compile codeCoffee, bare: on
            boxJs
                .removeClass('error')
                .html hljs.highlight('javascript', @lastCodeJs).value
        catch err
            @lastCodeJs = ''
            boxJs.addClass('error').text err.message

    editMode: (show)->
        do @update if not show
        $('pre.code.coffee').toggle not show
        @iframe.toggle show

    run: ()->
        try
            eval @lastCodeJs
        catch err
            log err

log = (values...)->
    console.log values...
    li = $('<li/>').appendTo log.list
    for val,i in values
        values[i] = $('<span/>').text val
        if val.constructor.toString().search(/^[^{]*Error/) > -1
            values[i].addClass 'error'
        values[i] = values[i][0].outerHTML
    li.html values.join ' &mdash; '
    ul = log.list[0];
    log.list.animate scrollTop: ul.scrollHeight, 500
    log.list.show 200
    $('#close-log').show 200
    setTimeout (-> log.box.show 500, -> ul.scrollTop = ul.scrollHeight), 100

$ ->
    log.box = $('<div id="log"/>').hide().appendTo '#term'
    log.list = $('<ul/>').appendTo log.box
    $('<div id="close-log">&times;</div>')
        .appendTo(log.box)
        .on 'click', ->
            log.list.hide 500
            $(@).hide 100
            setTimeout (-> log.box.hide 500), 400

    window.coffeeTerm.iframe = iframe = $('<div><iframe/></div>')
        .addClass('code coffee edit-box')
        .prependTo('#term')
    setTimeout (->
        iframeBody = iframe.children()[0].contentDocument.body
        iframeBody.style.padding = iframeBody.style.margin = 0
        window.coffeeTerm.textarea = $('<textarea wrap="off"/>')
            .css(
                'font-size' : '18px'
                'background': 'transparent'
                'border'    : '2px solid #FD0'
                'border-radius': '15px'
                'margin'    : '0px'
                'padding'   : '10px'
                'width'     : '100%'
                'height'    : '100%')
            .val('quadrado = (num)-> num*num\n\nlog quadrado 4')
            .appendTo(iframeBody)
            .on('mouseout', -> coffeeTerm.editMode off)
            .on('change', -> do coffeeTerm.update)
        coffeeTerm.editMode off
    ), 100

