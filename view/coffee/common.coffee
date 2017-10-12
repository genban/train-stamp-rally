
@API =
  get: (url, a, b) ->
    $.get(url, a, b)
      .fail(failure)
  getJSON: (url, a, b) ->
    $.getJSON(url, a, b)
      .fail(failure)
  postJSON: (obj) ->
    @json('POST', obj)
  putJSON: (obj) ->
    @json('PUT', obj)
  json: (type, obj) ->
    $.ajax
      type: type
      url: obj.url
      data: JSON.stringify obj.data
      contentType: 'application/json'
      success: obj.success
      error: obj.error ? failure
  post: (url, data, success) ->
    $.post(url, data, success)
      .fail(failure)
  put: (url, data, success) ->
    $.ajax
      type: 'PUT'
      url: url
      data: data
      success: success
      error: failure
  delete: (url, a, b) ->
    data = if b? then a else null
    success = if b? then b else a
    $.ajax
      type: 'DELETE'
      url: url
      data: data
      success: success
      error: failure
  deleteJSON: (obj) ->
    @json('DELETE', obj)

failure = (jqXHR) ->
  redirect = location.pathname
  if jqXHR.status == 403
    location.href = "/auth/session.html?redirect=#{redirect}"

@fromURLParameter = (str) ->
  obj = {}
  for kv in str.split('&')
    ary = kv.split('=')
    key = ary.shift()
    obj[key] = ary.join('=')
  obj

@formatter =
  methods:
    dateFormat: (date) ->
      if date?
        "#{date.day}日目 #{@twoDigit(date.hour)}:#{@twoDigit(date.minutes)}"
    timeFormat: (time) ->
      if time?
        "#{if time?.day == 1 then '翌' else ''}#{@twoDigit(time.hour)}:#{@twoDigit(time.minutes)}"
    timeFormatAPI: (time) ->
      @twoDigit(time.hour) + @twoDigit(time.minutes)
    twoDigit: (int) ->
      int.toLocaleString('en-IN', {minimumIntegerDigits: 2})

@urlParams =
  data:
    params: {}
  methods:
    setParams: ->
      @params = fromURLParameter(location.search.slice(1))
  mounted: ->
    @setParams()

# Game commons
@missionParam =
  data:
    missionId: 0
  mixins: [urlParams]
  methods:
    setMission: (failed)->
      @missionId = parseInt(@params.mission)
      if !@missionId
        failed()

@vueMessage = (el) ->
  new Vue
    el: el
    data:
      message: undefined
      type: undefined
    methods:
      danger: (mes) ->
        @message = mes
        @type = "alert-danger"
      clear: ->
        @message = undefined
        @type = undefined

@companySelector =
  data:
    companies: [{id: 1, name: 'JR'}]
    company: 1
  methods:
    getCompanies: ->
      API.getJSON '/api/companies', (json) =>
        @companies = json
  mounted: ->
    @.$nextTick =>
      @getCompanies()

@trainTypeSelector =
  data:
    trainTypes: [{value: 1, name: '普通'}]
    trainType: 1
  methods:
    getTypes: ->
      API.getJSON '/api/train_types', (json) =>
        @trainTypes = json
    findTypeFromValue: (n) ->
      _.find @trainTypes, (t) -> t.value == n
  mounted: ->
    @.$nextTick =>
      @getTypes()

@copyObject = (src) ->
  $.extend(true, {}, src)

# Require getPageData methods
# args (page, done)
# page.current: 0 padding page number
# done args (obj)
# obj.total: total count of data
# obj.last: last page of data
@pagination =
  data:
    pagination:
      current: 0
      last: 1
  methods:
    getData: ->
      @getPageData @pagination, (page) =>
        @pagination.total = page.total
        @pagination.last = page.last
    parsePageHash: ->
      page = fromURLParameter(location.hash.slice(1))?.page ? 1
      @pagination.current = page - 1
    next: (page) ->
      next = page ? @pagination.current + 1
      to =
        if next < 0 or @pagination.last <= 0
          0
        else if @pagination.last <= next
          @pagination.last - 1
        else
          next
      @pagination.current = to
  mounted: ->
    @.$nextTick =>
      @parsePageHash()
      @getData()
  watch:
    'pagination.current': (current)->
      @getData()
      location.hash = "#page=#{parseInt(current) + 1}"

# f: (element) -> testing string
@regexMatcherBy = (f) ->
  (xs) ->
    (q, cb) ->
      substrRegex = new RegExp(q, 'i')
      matches = _.filter xs, (x) -> substrRegex.test(f(x))
      cb(matches)

@defaultTypeaheadDesign = {hint: true, highlight: true}

@trainTypeColorClass =
  methods:
    trainColor: (value) ->
      switch value
        when 2 then 'text-success'
        when 3 then 'text-danger'
        when 4 then 'text-primary'
        else ''

@momentFormat =
  methods:
    format: (millis) ->
      moment(millis).format('YYYY-MM-DD')
