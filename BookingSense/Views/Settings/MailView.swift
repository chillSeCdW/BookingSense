// Created for BookingSense on 02.07.24 by kenny
// Using Swift 5.0

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {

  @Binding var isShowing: Bool
  @Binding var result: Result<MFMailComposeResult, Error>?
  let subject: String
  let recipients: [String]
  let body: String

  class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?

    init(isShowing: Binding<Bool>,
         result: Binding<Result<MFMailComposeResult, Error>?>) {
      _isShowing = isShowing
      _result = result
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
      defer {
        isShowing = false
      }
      guard error == nil else {
        self.result = .failure(error!)
        return
      }
      self.result = .success(result)
    }
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(isShowing: $isShowing,
                       result: $result)
  }

  func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
    let mailView = MFMailComposeViewController()
    mailView.mailComposeDelegate = context.coordinator
    mailView.setSubject(subject)
    mailView.setToRecipients(recipients)
    mailView.setMessageBody(body, isHTML: false)
    return mailView
  }

  func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                              context: UIViewControllerRepresentableContext<MailView>) {

  }
}
