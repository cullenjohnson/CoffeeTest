define (require) ->
    require 'backbone'
    Backbone.localStorage = require 'localstorage'
    QuizSession = require 'models/QuizSession'

    class QuizSessionSet extends Backbone.Collection

        model: QuizSession

        # Save quiz sessions under the 'QuizSessionSet' namespace.
        localStorage: new Backbone.localStorage 'QuizSessionSet'

        # Sorts by highest score, then lowest time
        comparator: (a, b) ->
            if a.get('final_score') > b.get('final_score')
                return -1

            else if a.get('final_score') == b.get('final_score')

                if a.get('quiz_time') < b.get('quiz_time')
                    return -1

                else if a.get('quiz_time') == b.get('quiz_time')
                    return 0

                else
                    return 1

            else
                return 1

        getTemplateJSON: ->
            scores: _.map @models, (quizSession) =>
                rank: (@indexOf(quizSession) + 1)
                highlight: quizSession.get('timestamp') == App.lastSessionId
                sessionId: quizSession.get 'timestamp'
                username: quizSession.get 'username'
                timeString: quizSession.getTimestampString()
                timeAgo: quizSession.getTimeAgoString()
                percent: quizSession.getPercent()
                duration: quizSession.getDurationString()
        