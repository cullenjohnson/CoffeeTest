define (require) ->

    require 'backbone'
    Mustache = require 'Mustache'

    class StartView extends Backbone.View
        ###
        DATA HANDLING/INITIALIZATION FUNCTIONS
        ###
        MAX_NAME_LENGTH: 100    # "Constant" defining the maximum name length
        initialize: (options) ->
            @build();

        ###
        RENDER/BUILD FUNCTIONS
        ###
        build: ->
            template = $('#main_template').html()
            bodyHtml = $('#start_body').html()
            footerHtml = $('#restart_link').html()
            data =
                header: 'Please enter your name'
                body: bodyHtml
                footer: footerHtml

            @$el.html Mustache.to_html template, data

        ###
        EVENTS
        ###
        events:
            'click #beginQuiz': 'beginQuizClick'
            'keyup #name_entry': 'nameEntryKeyUp'

        beginQuizClick: (e) ->
            nameData = $('#name_entry').val()
            remainAnonymous = false
            continueOn = true
            
            if nameData?
                nameData = nameData.trim() 
            else
                nameData = ''

            # If there is no name, prompt the user if they wish to remain anonymous
            # TODO gentle popup
            if nameData.length == 0
                remainAnonymous = confirm 'You didn\'t enter anything in the text field. Did you wish to remain anonymous? (We won\'t put your name on the rankings if you remain anonymous.)'

                continueOn = remainAnonymous

            # Check the name length
            else if nameData.length > @MAX_NAME_LENGTH
                continueOn = false
                toast "The name you entered was too long. Please enter a name that is shorter than #{ @MAX_NAME_LENGTH } characters."

            # Send event up to router that a name is ready
            if continueOn
                if remainAnonymous
                    nameData = 'anonymous'

                window.App.router.navigate "quiz/#{ nameData }", trigger: true
                
        nameEntryKeyUp: (e) ->
            if (e.which == 13)
                @beginQuizClick(e)
