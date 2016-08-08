class Btn extends ImageView
  init: (opts) ->
    options = merge opts,
      autoSize: true
      image: "resources/images/arcadeParts/"+opts.name+".png"
    super options
    @name = opts.name

    @on 'InputStart', ->
      @[@name] = true
      @style.opacity = 0
    @on 'InputSelect', ->
      @[@name] = false
      @style.opacity = 1
    @on 'InputOut', ->
      @[@name] = false
      @style.opacity = 1
    @

initBtns = ->
  @_btn_attack_view = new Btn
    superview: @
    name: 'btn_attack'
    x: 830
    y: 1030
  @_btn_turbo_view = new Btn
    superview: @
    name: 'btn_turbo'
    x: 650
    y: 1090
  @_btn_rotate_left_view = new Btn
    superview: @
    name: 'btn_rotate_left'
    x: 90
    y: 1030
  @_btn_rotate_right_view = new Btn
    superview: @
    name: 'btn_rotate_right'
    x: 270
    y: 1090
