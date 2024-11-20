// Created for BookingSense on 04.07.24 by kenny
// Using Swift 5.0

import Foundation

struct BookingsList: Codable {
  let data: [JsonBookingEntry]
  let tags: [JsonTag]
  let timeline: [JsonTimelineEntry]

  init(data: [BookingEntry], tags: [Tag], timeline: [TimelineEntry]) {
    self.data = data.map { JsonBookingEntry($0) }
    self.tags = tags.map { JsonTag($0)}
    self.timeline = timeline.map { JsonTimelineEntry($0) }
  }
}
