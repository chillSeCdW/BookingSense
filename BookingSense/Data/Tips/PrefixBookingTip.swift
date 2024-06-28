// Created for BookingSense on 25.06.24 by kenny
// Using Swift 5.0

import TipKit

struct PrefixBookingTip: Tip {
  var title: Text {
    Text("Prefix of booking")
  }
  var message: Text? {
    Text("\(Image(systemName: "plus")) symbol") +
    Text(" stands for income") +
    Text("\n") +
    Text("\(Image(systemName: "minus")) symbol") +
    Text(" stands for deductions") +
    Text("\n") +
    Text("\(Image(systemName: "banknote")) symbol") +
    Text(" stands for savings")
  }

  var image: Image? {
    Image(systemName: "info.circle")
      .symbolRenderingMode(.multicolor)
  }

  var options: [Option] {
    Tips.MaxDisplayCount(3)
  }
}
