package queries

import models.{Line, Station, StationRank}

case class CreateLine(name: String, stations: Seq[CreateStation], companyId: Long) {
  def line = Line(id = 0L, name = name, companyId = companyId)
}

case class CreateStation(name: String, km: Double, rankValue: Int) {
  def rank: Option[StationRank] = StationRank.find(rankValue)
  def station: Option[Station] = rank.map { r =>
    Station(id = 0L, name = name, rank = r)
  }
}
