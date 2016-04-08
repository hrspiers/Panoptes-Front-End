React = require 'react'

HidePreviousMarksToggle = React.createClass
  getDefaultProps: ->
    taskTypes: null
    workflow: null
    classification: null
    onChange: ->

  componentDidMount: ->
    @_lastKnownAnnotationCount = @props.classification.annotations.length

  componentWillReceiveProps: (nextProps) ->
    # Automatically un-hide previous marks.
    if nextProps.classification.annotations.length isnt @_lastKnownAnnotationCount
      @setPreviousMarks 0

  setPreviousMarks: (count) ->
    @_lastKnownAnnotationCount = @props.classification.annotations.length
    @props.classification._hideMarksBefore = count
    @props.onChange @props.classification

  render: ->
    DrawingTaskComponent = require '.' # Circular

    currentlyHidingMarks = @props.classification._hideMarksBefore > 0

    marksCount = 0
    @props.classification.annotations.forEach (annotation) =>
      taskDescription = @props.workflow.tasks[annotation.task]
      TaskComponent = @props.taskTypes[taskDescription.type]
      if TaskComponent is DrawingTaskComponent
        marksCount += annotation.value.length

    nextValueToSet = if currentlyHidingMarks
      0
    else
      marksCount

    checkedStyle =
      background: 'rgba(255, 0, 0, 0.7)'
      color: 'white'

    <div>
      <label style={checkedStyle if currentlyHidingMarks}>
        <input type="checkbox" checked={currentlyHidingMarks} disabled={marksCount is 0} onChange={@setPreviousMarks.bind this, nextValueToSet} />{' '}
        Hide previous marks
      </label>
    </div>

module.exports = HidePreviousMarksToggle
