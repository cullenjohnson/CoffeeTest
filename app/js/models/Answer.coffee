define (require) ->
    
    require 'backbone'

    class Question extends Backbone.Model
        defaults:
            id: null        # The ID for the answer.
            selected: null  # The answerr value

        initialize: =>

        # sync: (method, model, options) =>
        #     if method == 'read'
        #     else if method == 'create'
        #     else if method == 'update'
        #     else if method == 'delete'
