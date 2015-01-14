define (require) ->
    require 'backbone'

    IndexView = require 'views/IndexView'
    StartView = require 'views/StartView'
    QuizView = require 'views/QuizView'
    ResultsView = require 'views/ResultsView'
    RankingsView = require 'views/RankingsView'

    QuizSession = require 'models/QuizSession'

    class AppRouter extends Backbone.Router

        initialize: ->

        # Call this before EVERY new route, otherwise Backbone won't know when to clean up the views.
        cleanUpView: (route, name, callback) -> 
            if @view
                @view.remove() if  @view.remove?
                @view = null

            if $('#main').length <= 0
                $('body').prepend '<div id="main"></div>'


        routes:
            'start':                'startRoute'
            'quiz/:name':           'quizRoute'
            'results/:sesionId':    'resultsRoute' 
            'rankings':             'rankingsRoute' 
            '*catch_all':           'indexRoute'


        indexRoute: (catch_all) ->
            @cleanUpView()

            # Since the index route uses a splat to catch any strange hashes, clear out any unrecognized hashes.
            if catch_all? 
                @navigate '', replace: true, trigger: false

            @view = new IndexView el: $ '#main'

        startRoute: ->
            @cleanUpView()

            @view = new StartView el: $ '#main'

        quizRoute: (name) ->
            @cleanUpView() 

            model = new QuizSession { username: name }, { newModel: true }

            @view = new QuizView 
                el: $ '#main'
                model: model 

        resultsRoute: (sessionId) ->
            @cleanUpView()

            sessionFetchCallback = (session) =>
                if session? and session.has('user_answers')
                    App.quizSessions.add(session)
                    @view = new ResultsView 
                        el: $ '#main' 
                        model: session
                else
                    @indexRoute 'error'
                    toast 'Sorry; the result you were trying to view no longer exists.'
            
            session = App.quizSessions.get(parseInt(sessionId)) || App.quizSessions.add( new QuizSession({timestamp: sessionId}) )

            session.fetch({
                success: sessionFetchCallback
                error: sessionFetchCallback
            })

        rankingsRoute: () ->
            @cleanUpView()

            App.quizSessions.fetch(
                success: =>
                    @view = new RankingsView el: $ '#main'
                error: (error) =>
                    @indexRoute 'error'
                    toast "Sorry; an error prevented us from loading the rankings for you. <br> #{error}"
            )
