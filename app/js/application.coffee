define (require) ->
    require 'backbone'

    AppRouter = require './AppRouter'
    QuizSessionSet = require 'collections/QuizSessionSet'

    initialize: ->
        window.App = {}

        window.App.quizSessions = new QuizSessionSet
        window.App.quizSessionsLoaded = false

        window.toast = (msg) ->
            $("<div class='toast-notification'>#{msg}</div>")
            .appendTo( $('body') ).delay( 1500 )
            .fadeOut( 400, ->
                $ this .remove()
            )
            

        # Keyboard focus support hack
        $(window).keyup((e) ->
            # If the key pressed was Enter or Space, and the target is a link or a button, simulate a click on that element.
            if (e.which == 13  || e.which == 32) and $(e.target).is('a, .button') 
                $(e.target).get(0).click()
        )

        window.App.quizSessions.fetch(
            success: () ->
                window.App.quizSessionsLoaded = true
            error: (collection, error) ->
                alert "Could not load previous quiz sessions because of an error:\n#{ error }"
        )

        window.App.router = new AppRouter

        Backbone.history.start()