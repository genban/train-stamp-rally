$(document).ready ->
  cl = new Vue
    el: '#createLine'
    data:
      lineName: ""
      stations: [{name: "", km: 0.0, rankValue: 3}]
      csv: ""
    methods:
      addStation: ->
        @stations.push {name: "", km: 0.0, rankValue: 5}
      deleteStation: (idx) ->
        @stations.splice(idx, 1)
      postLine: ->
        postJSON
          url: '/api/line'
          data: {name: @lineName, stations: @stations}
          success: ->
            location.reload(false)
      loadCSV: ->
        lines = @csv.split('\n').map (line) -> line.split('\t')
        @stations = lines.map (line) ->
          {name: line[0], km: parseFloat(line[1] ? "0"), rankValue: parseInt(line[2] ? "5")}

postJSON = (obj) ->
  $.ajax
    type: 'POST'
    url: obj.url
    data: JSON.stringify obj.data
    contentType: 'application/json'
    success: obj.success