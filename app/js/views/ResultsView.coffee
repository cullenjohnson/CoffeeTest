define (require) ->
    require 'backbone'
    require 'moment'
    QuizSession = require 'models/QuizSession'
    Mustache = require 'Mustache'

    class ResultsView extends Backbone.View
        initialize: (options) ->
            @options = options
            @build()

        build: ->
            App.quizSessions.sort()

            mainTemplate = $('#main_template').html()
            bodyTemplate = $('#results_body_template').html()

            time = "<span title=\'#{@model.getTimestampString()}\'>#{@model.getTimeAgoString()}</span>"

            username = @model.get 'username'
            if username == 'anonymous'

                username = 'Anonymous User '

            userRef = if @model.get('timestamp') == App.lastSessionId then 'You' else "#{username}"
            
            bodyData =
                user: userRef 
                percent: @model.getPercent() + '%'
                duration: @model.getDurationString() + ' seconds'
                question_answers: @model.getUserAnswers()
                rank: App.quizSessions.indexOf(@model) + 1
                contestants: App.quizSessions.length

            data = 
                header: 'Results from a quiz taken ' + time
                body: Mustache.to_html(bodyTemplate, bodyData)      
                footer: $('#restart_link').html()

            @$el.html Mustache.to_html mainTemplate, data