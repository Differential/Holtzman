class Apollos.Controls.NumberKeyboard extends Apollos.Component
  @register "Apollos.Controls.NumberKeyboard"


  onRendered: ->
    self = @

    $(document).off("keyup").on "keyup", (event) ->
      if event.which >= 48 and event.which <= 57
        numPressed = event.which - 48

      else if event.which >= 96 and event.which <= 105
        numPressed = event.which - 96

      else if event.which is 46
        numPressed = -1

      else if event.which is 190 or event.which is 110
        numPressed = "."

      if typeof numPressed isnt "undefined"
        self.doPressAnimation $("[data-key=\"#{numPressed}\"]")
        self.processTypedText numPressed
        self.parent().updateFund self.typedText.get()


  vars: -> [
    typedText: ""
  ]

  events: -> [
    "touchstart [data-key]": @.touchstartedDataKey

    "click [data-key]": @.clickedDataKey
  ]

  touchstartedDataKey: (event, template) ->
    @.doPressAnimation event.currentTarget

  clickedDataKey: (event, template) ->
    @.doPressAnimation event.currentTarget
    keyPressed = event.currentTarget.getAttribute "data-key"
    @.processTypedText keyPressed
    @.parent().updateFund @.typedText.get()

  onCreated: ->
    fundAmount = @.parent().getFundAmount()
    if fundAmount and fundAmount.amount isnt "0"
      @.typedText.set fundAmount.amount

  doPressAnimation: (element) ->
    jQueryElement = $ element
    jQueryElement.addClass "touched"
    Meteor.setTimeout ->
      jQueryElement.removeClass "touched"
    , 150

  processTypedText: (keyValue) ->
    keyValue = String keyValue
    currentText = @.typedText.get()
    isEmpty = currentText.length is 0
    decimalIndex = currentText.indexOf "."
    hasDecimal = decimalIndex isnt -1

    if keyValue is "-1"
      @.parent().checkForIncrease()
      @.typedText.set(currentText.slice 0, -1)
      return

    if keyValue is "." and (hasDecimal or isEmpty)
      return

    if keyValue is "0" and isEmpty
      return

    if hasDecimal and currentText.length - decimalIndex > 2
      return

    @.typedText.set(currentText + keyValue)

  output: ->
    typedText = @.typedText.get()
    return typedText.replace /\B(?=(\d{3})+(?!\d))/g, ","

  keys: ->
    keys = [1..9].map (v) ->
      return {
        value: v
        display: v
        css: "key"
      }
    keys.push
      value: "."
      display: "&middot;"
    keys.push
      value: 0
      display: 0
    keys.push
      value: -1
      display: '<span class="icon-backspace"></span>'
    return keys
