package models

object DefaultAliases {
  def a = Account.defaultAlias
  def ls = LineStation.defaultAlias
  def l = Line.defaultAlias
  def s = Station.defaultAlias
  def sss = Mission.stationRefAlias
  def ss = StopStation.defaultAlias
  def d = Diagram.defaultAlias
  def f = Fare.defaultAlias
  def g = Game.defaultAlias
  def gp = GameProgress.defaultAlias
  def sc = Score.defaultAlias
  def m = Mission.defaultAlias
  def h = History.defaultAlias
  def si = StationImage.defaultAlias
  def ia = ImageAttribute.defaultAlias
  def gh = GameHistory.defaultAlias
  def sg = StationGeo.defaultAlias
  def pr = PasswordReset.defaultAlias
  def se = Session.defaultAlias
}
