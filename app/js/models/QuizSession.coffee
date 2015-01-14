define (require) ->
    
    require 'backbone'
    require 'moment'

    # Backbone.localStorage = require 'localstorage'

    QuestionSet = require('collections/QuestionSet')
    AnswerSet = require('collections/AnswerSet')

    Answer = require('models/Answer')

    class QuizSession extends Backbone.Model

        ###
        ATTRIBUTES
        ###
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

        idAttribute: 'timestamp'

        # localStorage: new Backbone.localStorage("QuizSession")

        ###
        DATA HANDLING
        ###
        initialize: (attrs, options) =>
            options = options || {}

            if options.newModel
                @set({
                    'timestamp': attrs.timestamp || new Date().getTime()
                    'questions': new QuestionSet(attrs.questions || [])
                    'answers': new AnswerSet(attrs.answers || [])
                    'user_answers': new AnswerSet(attrs.user_answers || [])
                    'quiz_time': 0
                }, 
                { silent: true })

                # Store the last session id for highlighting in the rankings.
                App.lastSessionId = @get('timestamp');

                @fetchCollections()
                

        sync: (method, model, options) ->
            # If we are fetching, convert the returned collections from JSON arrays to proper Backbone Collections before updating the model.
            if method == 'read'
                options.success = _.wrap(options.success, (wrappedFn, data) ->

                    data.questions = new QuestionSet data.questions
                    data.answers = new AnswerSet data.answers
                    data.user_answers = new AnswerSet data.user_answers

                    return wrappedFn data
                )

            super(method, model, options)
        fetchCollections: ->
            @fetchQuestions()
            @fetchAnswers()

        fetchQuestions: (options) ->
            # Increment the async count.
            @set('async_counter', @get('async_counter') + 1)

            # Use the ajaxSync option to force a "normal" backbone fetch instead of a localStorage fetch.
            @get('questions').fetch({
                ajaxSync: true
                success: ()=>
                    #sync is done, remove from the count.
                    @set('async_counter', @get('async_counter') - 1)
                    @set('current_question', @get('questions').at(0))

                    @startTimer()

                error: (collection, error)=>
                    alert "Error! Could not retrieve the questions: #{error}";

                    #sync is done, remove from the count.
                    @set('async_counter', @get('async_counter') - 1)
            })

        fetchAnswers: ->
            # Increment the async count.
            @set('async_counter', @get('async_counter') + 1)

            # Use the ajaxSync option to force a "normal" backbone fetch instead of a localStorage fetch.
            @get('answers').fetch({
                ajaxSync: true
                success: ()=>
                    #sync is done, remove from the count.
                    @set('async_counter', @get('async_counter') - 1)

                    @startTimer()

                error: (collection, error)=>
                    alert "Error! Could not retrieve the answers: #{error}";

                    #sync is done, remove from the count.
                    @set('async_counter', @get('async_counter') - 1)
            })

        ###
        "CONTROLLER" LOGIC
        ###
        startTimer: ->
            # If the data is ready, start the timer.
            @beginTime = new Date().getTime()

        stopTimer: ->
            @endTime = new Date().getTime()
            this.set('quiz_time', @endTime - @beginTime)

        nextQuestion: ->
            nextQuestionNumber = @getAnswerCount()
            nextQuestion = @get('questions').at nextQuestionNumber

            @set('current_question', nextQuestion)

            # This looks kind of weird, but if we run out of questions, stop the timer and calculate the score
            unless nextQuestion?
                @stopTimer()
                @finalizeSession()

        userAnswered: (trueOrFalse) ->
            question = @getCurrentQuestion()
            q_id = question.get('id')
            answer = new Answer(
                id: q_id,
                selected: trueOrFalse
            )

            @get('user_answers').add answer

            @nextQuestion()

        finalizeSession: ->
            score = @get('user_answers').filter((userAnswer) => 
                    correctAnswer = @get('answers').get(userAnswer.get('id'))
                    userAnswer.get('selected') == correctAnswer.get('selected')
                ).length

            @set('final_score', score)

            App.quizSessions.add(this)

            @save(
                @attributes,
                {
                    success: () =>
                        @trigger 'finalize'

                    error: (model, error)->
                        alert "Unable to save the results:\n#{ error }"
                }
            )

        ###
        GETTERS
        ###
        getAnswerCount: ->
            # Explicit return just for clarity. 
            # (I know CoffeeScript returns the last statement.)
            return @get('user_answers').length

        getCurrentQuestion: ->
            return @get('current_question')

        getPercent: ->
            return Math.round((@get('final_score') / @get('questions').length) * 100)

        getDurationString: ->
            # Return the number of seconds the user took.
            moment.duration(@get('quiz_time'), 'milliseconds').asSeconds()

        getTimeAgoString: ->
            # Display the time as "[X] [seconds/months/etc] ago"
            moment(@get('timestamp')).fromNow()

        getTimestampString: ->
            # Display the time in a readable format.
            moment(@get('timestamp')).format 'YYYY MMM Do h:mm:ss a'

        getUserAnswers: ->
            # Get a list of questions and the user's answers in the format prescribed by the Results page template
            _.map @get('user_answers').models, (answer) =>
                id = answer.get('id')
                question = @get('questions').get(id)
                correctAnswer = @get('answers').get(id)
                isCorrect = correctAnswer.get('selected') == answer.get('selected')
                {
                    question: question.get('text')
                    correct: isCorrect
                    answer: if answer.get('selected') then 'True' else 'False'
                }     