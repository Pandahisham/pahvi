
views = NS "Pahvi.views"


class views.Info extends Backbone.View

  constructor: ({@msg, @classes}) ->
    super
    @$el = $ @el

  render: ->
    @$el.html """
      <div class='msgbox #{ @classes }'>#{ @msg }</div>
    """


views.showMessage = (msg, hideCancel) ->
  lb = new views.LightBox
    hideCancel: hideCancel
    views: new views.Info
      msg: msg

  lb.renderToBody()


class views.LightBox extends Backbone.View

  className: "lightbox"

  constructor: ({@views, @alwaysOnTop, @hideCancel}) ->
    super
    @$el = $ @el

    if not _.isArray @views
      @views = [ @views ]



  events:
    "click": "_onBackgroundClick"
    "click .ok": "_onOkButtonClick"
    "click .cancel": "_onCancelButtonClick"

  _onBackgroundClick: (e) ->
    if e.target is @el and not @alwaysOnTop
      @close false

  _onOkButtonClick: (e) ->
    e.preventDefault()
    @close true

  _onCancelButtonClick: (e) ->
    e.preventDefault()
    @close false


  close: (ok) ->
    for view in @views
      view.remove ok

    @remove()

    @trigger "close", this, ok


  render: ->
    @$el.html @renderTemplate "lightbox", this

    viewContainer = @$(".views")
    for view in @views
      view.render()
      viewContainer.append view.el

  renderToBody: ->
    @render()
    $("body").append @el

