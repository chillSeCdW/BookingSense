// Created for BookingSense on 03.07.24 by kenny
// Using Swift 5.0

import SwiftUI
import MessageUI

struct ContactButtons: View {
  @State var result: Result<MFMailComposeResult, Error>?
  @State var isShowingMailView = false

  let mailTo = Constants.mailTo
  let subject = Constants.mailSubject

  var body: some View {
    if MFMailComposeViewController.canSendMail() {
      VStack {
        Button {
          self.isShowingMailView.toggle()
        } label: {
          HStack {
            Image(systemName: "envelope")
            Text("Give feedback")
          }
        }
      }
      .sheet(isPresented: $isShowingMailView) {
        MailView(isShowing: self.$isShowingMailView,
                 result: self.$result,
                 subject: subject,
                 recipients: [mailTo],
                 body: generateMessageBody()
        )
      }
    } else {
      Button {
        UIApplication.shared.open(
          // swiftlint:disable:next line_length
          URL(string: "mailto:\(mailTo)?subject=\(subject)&body=\(generateMessageBody().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")")!,
          options: [:], completionHandler: nil)
      } label: {
        HStack {
          Image(systemName: "envelope")
          Text("Give feedback with default mail app")
        }
      }
      Button {
        let url = URL(string: "App-prefs:MAIL&path=ACCOUNTS/ADD_ACCOUNT")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } label: {
        HStack {
          Image(systemName: "arrow.right.circle")
          Text("No mail account found. Open settings.")
        }
      }
    }
    Button {
      let url = URL(string: "https://chillturtle.de/bookingsense")!
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } label: {
      HStack {
        Image(systemName: "link")
        Text("Open homepage")
      }
    }
  }

  func generateMessageBody() -> String {
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    let systemVersion = UIDevice.current.systemVersion
    let deviceName = UIDevice.current.name

    var body = "\n---------------\n"
    body.append("App version: \(version ?? "") | build \(build ?? "")\n")
    body.append("iOS version: \(systemVersion)\n")
    body.append("device: \(deviceName)\n")

    return body
  }
}

#Preview {
  ContactButtons()
}
