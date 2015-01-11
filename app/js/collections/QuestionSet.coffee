define (require) ->
    require 'backbone'

    Question = require 'models/Question'

    class QuestionSet extends Backbone.Collection
        model: Question

        # sync: (method, collection, options) =>
        #     options = options || {};
        #     options.fileName = options.fileName || 'data/questions1.json';

        #     if (method == 'read')
        #         $.ajax(
        #             cache: false,
        #             success: (data) =>
        #
        #             error: () =>
        #
        #         )