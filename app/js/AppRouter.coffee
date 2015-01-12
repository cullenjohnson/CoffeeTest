define (require) ->
    require 'backbone'

    IndexView = require 'views/IndexView'
    StartView = require 'views/StartView'
    QuizView = require 'views/QuizView'

    QuizSession = require 'models/QuizSession'

    class AppRouter extends Backbone.Router

        initialize: ->
            @listenTo this, 'route', (route) => 
                @view.close() if @view? and @view.close
                @view = null


        routes:
            'start':        'startRoute'
            'quiz/:name':   'quizRoute'
            '*catch_all':   'indexRoute'

        indexRoute: (catch_all) ->

            # Since the index route uses a splat to catch any strange hashes, clear out any unrecognized hashes.
            if catch_all? 
                @navigate '', replace: true, trigger: false

            @view = new IndexView el: $ '#main'

        startRoute: ->
            @view = new StartView el: $ '#main'

        quizRoute: (name) ->
            model = new QuizSession({username: name})
            @view = new QuizView el: $('#main'), model: model 