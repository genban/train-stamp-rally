package controllers

import com.github.tototoshi.play2.json4s.Json4s
import com.google.inject.Inject
import models.LineStation
import org.json4s._
import play.api.mvc.{Action, Controller}

class Stations @Inject()(json4s: Json4s) extends Controller {
  import json4s._
  implicit val formats = DefaultFormats

  def list() = Action {
    import LineStation.{lines, stations, defaultAlias}
    val all = LineStation.joins(lines).joins(stations).findAll(Seq(defaultAlias.id))
    Ok(Extraction.decompose(all))
  }
}