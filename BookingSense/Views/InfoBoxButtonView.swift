// Created for BookingSense on 13.06.24 by kenny
// Using Swift 5.0

import SwiftUI

struct InfoBoxButtonView: View {
  let headline: String
  let infoText: String?

  @State private var showInfo = false
  @State var textHeight: CGFloat = 0

  var body: some View {
    Button {
      showInfo.toggle()
    } label: {
      Image(systemName: "info.circle")
    }
    .buttonStyle(.borderless)
    .popover(isPresented: $showInfo,
             content: {
      VStack {
        Text(LocalizedStringKey(headline))
          .font(.headline)
        if infoText != nil {
          Text(LocalizedStringKey(infoText!))
            .font(.body)
        }
      }.overlay(
        GeometryReader { proxy in
            Color
                .clear
                .preference(key: ContentLengthPreference.self,
                            value: proxy.size.height)
        }
    )
    .onPreferenceChange(ContentLengthPreference.self) { value in
        DispatchQueue.main.async {
            self.textHeight = value
        }
    }
    .fixedSize(horizontal: false, vertical: true)
    .frame(height: textHeight)
    .padding()
    .presentationCompactAdaptation(.none)
    })
  }
}

struct ContentLengthPreference: PreferenceKey {
    static var defaultValue: CGFloat { 0 }

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
  VStack {
    InfoBoxButtonView(headline: "How it's calculated", infoText: nil)
    InfoBoxButtonView(headline: "How it's calculated",
                      infoText: "calculated total monthly costs"
    )
  }
}
