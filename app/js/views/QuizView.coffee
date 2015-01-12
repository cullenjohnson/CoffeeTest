define (require) ->

    require 'backbone'
    Mustache = require 'Mustache'

    class QuizView extends Backbone.View
        ###
        DATA HANDLING/INITIALIZATION FUNCTIONS
        ###
        initialize: (options) ->
            @options = options || {}
            @build()
            @render()

            @listenTo @model, 'change:async_counter', @render
            @listenTo @model, 'change:current_question', @render

        ###
        RENDER/BUILD FUNCTIONS
        ###
        build: ->
            template = $('#main_template').html()
            data =
                header: ''
                body: ''
                footer: '' 

            @$el.html Mustache.to_html template, data

        render: ->
            if @model.get('async_counter') == 0 and @model.getCurrentQuestion()?
                @$('#body').animate({opacity: 0}, () =>
                    @renderData()
                    @$('#body').animate({opacity: 1})
                )
            else if @model.get('async_counter') == 0 and not @model.getCurrentQuestion()?
                @$('#body').animate({opacity: 0}, @renderLoading)
            else
                @renderLoading()

        renderLoading: =>
            el = @$ '#header>h1'

            el.addClass 'loading'
            el.html 'Loading...'


        renderData: =>
            questionNumber = @model.getAnswerCount() + 1
            numQuestions = @model.get('questions').length
            headerHtml = "Question #{ questionNumber } of #{ numQuestions }"

            # render the header
            @$('#header>h1').removeClass 'loading'
            @$('#header>h1').html headerHtml

            question = @model.getCurrentQuestion()

            # render the body
            if (question?)
                body_template = $('#quiz_body_template').html()
                data =
                    'question': question.get('text')

                @$('#body').html Mustache.to_html body_template, data
        ###
        EVENTS
        ###
        events:
            'click #btn_true': 'trueClick'
            'click #btn_false': 'falseClick'
        
        trueClick: (e) ->
            @buttonHelper(true)

        falseClick: (e) ->
            @buttonHelper(false)

        buttonHelper: (trueOrFalse) ->
            trueBtn = @$('#btn_true')
            falseBtn = @$('#btn_false')

            unless trueBtn.hasClass('disabled')
                @$('#btn_true').addClass('disabled')
                @$('#btn_false').addClass('disabled')
                @model.userAnswered(trueOrFalse)

