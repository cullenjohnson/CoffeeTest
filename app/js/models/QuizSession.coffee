define (require) ->
    
    require 'backbone'
    QuestionSet = require('collections/QuestionSet')
    AnswerSet = require('collections/AnswerSet')

    Answer = require('models/Answer')

    class QuizSession extends Backbone.Model
        defaults:
            questions: null         # The questions (see QuestionSet collection)
            answers: null           # The correct answers to the questions. (see AnswerSet collection)
            timestamp: null         # The time the user began taking the quiz (used as an ID for the session)
                                    # (This will be unique since I am only storing results locally.)
            current_question: null  # The current question the user is answering, or null if the user is not answering a question.
            username: null          # The entered name for the user who took the quiz
            user_answers: null      # The user's answers to the questions. (see AnswerSet collection)
            final_score: null       # The user's score on the quiz
            quiz_time: null         # The time the user took to answer all 4 questions
            async_counter: 0        # Number to keep track of how many asynchronous calls are currently running.

        initialize: (attrs) =>
            @set({
                'timestamp': attrs.timestamp || new Date().getTime()
                'questions': attrs.questions || new QuestionSet()
                'answers': attrs.answers || new AnswerSet()
                'user_answers': new AnswerSet()
                'quiz_time': 0
            }, 
            { silent: true })

            @fetchQuestions()
            @fetchAnswers()

        fetchQuestions: ->
            # Add this sync to the async count.
            @set('async_counter', @get('async_counter') + 1)

            @get('questions').fetch({
                success: ()=>
                    #sync is done, remove from the count.
                    @set('async_counter', @get('async_counter') - 1)
                    @set('current_question', @get('questions').at(0))

                error: (collection, error)=>
                    alert "Error! Could not retrieve the questions: #{error}";

                    #sync is done, remove from the count.
                    @set('async_counter', @get('async_counter') - 1)
            })

        fetchAnswers: ->
            # Add this sync to the async count.
            @set('async_counter', @get('async_counter') + 1)

            @get('answers').fetch({
                success: ()=>
                    #sync is done, remove from the count.
                    @set('async_counter', @get('async_counter') - 1)

                error: (collection, error)=>
                    alert "Error! Could not retrieve the answers: #{error}";

                    #sync is done, remove from the count.
                    @set('async_counter', @get('async_counter') - 1)
            })

        getAnswerCount: ->
            # Explicit return just for clarity. 
            # (I know CoffeeScript returns the last statement.)
            return @get('user_answers').length

        nextQuestion: ->
            nextQuestionNumber = @getAnswerCount()

            @set('current_question', @get('questions').at(nextQuestionNumber))

        getCurrentQuestion: ->
            return @get('current_question')

        userAnswered: (trueOrFalse) ->
            question = @getCurrentQuestion()
            q_id = question.get('id')
            answer = new Answer(
                id: q_id,
                selected: trueOrFalse
            )

            @get('user_answers').add answer

            @nextQuestion()


        # sync: (method, model, options) =>
        #     if method == 'read'
        #     else if method == 'create'
        #     else if method == 'update'
        #     else if method == 'delete'
