define (require) ->
    
    require 'backbone'

    class QuizSession extends Backbone.Model
        defaults:
            timestamp: null         # The time the user began taking the quiz (used as an ID for the session)
                                    # (This will be unique since I am only storing results locally.)
            username: null          # The entered name for the user who took the quiz
            questions: null         # The questions (see QuestionSet collection)
            answers: null           # The user's answers to the questions. (see AnswerSet collection)
            final_score: null       # The user's score on the quiz
            quiz_time: null         # The time the user took to answer all 4 questions

        initialize: (attrs) =>
            @set({
                'timestamp': attrs.timestamp || new Date().getTime()
                'questions': attrs.questions || new QuestionSet()
                'answers': attrs.answers || new AnswerSet()
                'quiz_time': 0
            }, 
            { silent: true })

        # sync: (method, model, options) =>
        #     if method == 'read'
        #     else if method == 'create'
        #     else if method == 'update'
        #     else if method == 'delete'
