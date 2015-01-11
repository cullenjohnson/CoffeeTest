define (require) ->
    
    require 'backbone'

    class Question extends Backbone.Model
        defaults:
            id: null    # The ID for the question.
            text: null  # The question's display text

        initialize: =>

        # sync: (method, model, options) =>
        #     if method == 'read'
        #     else if method == 'create'
        #     else if method == 'update'
        #     else if method == 'delete'
