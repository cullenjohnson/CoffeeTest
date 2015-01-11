class App.Views.TestView extends Backbone.View
    initialize: (options) =>
        console.log('test');
        @render();

    render: =>
        this.$el.html('Hello World');
        return this;