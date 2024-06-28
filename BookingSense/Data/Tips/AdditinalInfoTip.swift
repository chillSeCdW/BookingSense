// Created for BookingSense on 23.06.24 by kenny
// Using Swift 5.0

import TipKit

struct AdditinalInfoTip: Tip {
  var title: Text {
    Text("Additional information")
  }
  var message: Text? {
    Text("click here for some additional information")
  }

  var image: Image? {
    Image(systemName: "info.circle")
      .symbolRenderingMode(.multicolor)
  }

  var options: [Option] {
    Tips.MaxDisplayCount(3)
  }
}
