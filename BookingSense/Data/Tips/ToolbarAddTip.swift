// Created for BookingSense on 22.06.24 by kenny
// Using Swift 5.0

import TipKit

struct ToolbarAddTip: Tip {
  var title: Text {
    Text("Adding a booking")
  }

  var message: Text? {
    Text("click here to add a booking")
  }

  var image: Image? {
    Image(systemName: "info.circle")
      .symbolRenderingMode(.multicolor)
  }

  var options: [Option] {
    Tips.MaxDisplayCount(3)
  }
}
