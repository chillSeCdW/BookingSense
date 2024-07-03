// Created for BookingSense on 03.07.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData

struct ExportImportButtons: View {
  @Query private var entries: [BookingEntry]

  @State private var isSharePresented: Bool = false
  @State private var importing = false

  var body: some View {
    ShareLink(item: exportJson(entries)!) {
      HStack {
        Image(systemName: "arrow.up.doc")
        Text("Export as json")
      }
    }
    Button {
      importing = true
    } label: {
      HStack {
        Image(systemName: "arrow.down.doc")
        Text("Import as json")
      }
    }
    .fileImporter(
      isPresented: $importing,
      allowedContentTypes: [.json]
    ) { result in
    // TODO: implement import
      switch result {
      case .success(let file):
        print(file.absoluteString)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  func exportJson(_ entries: [BookingEntry]) -> URL? {
    let jsonString = encodeJson(entries)

    if let json = jsonString {
      return json.createJsonFile("bookingSenseData")
    }
    return nil
  }

  func encodeJson(_ entries: [BookingEntry]) -> String? {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    do {
      let jsonData = try encoder.encode(entries)
      return String(data: jsonData, encoding: .utf8)
    } catch {
      print("Error encoding BookingEntry: \(error)")
    }
    return nil
  }

  func decodeJson(from jsonString: String) -> BookingEntry? {
    let decoder = JSONDecoder()

    guard let jsonData = jsonString.data(using: .utf8) else {
      print("Error converting string to data")
      return nil
    }

    do {
      let bEntry = try decoder.decode(BookingEntry.self, from: jsonData)
      return bEntry
    } catch {
      print("Error decoding JSON: \(error)")
      return nil
    }
  }
}

extension String {
  func createJsonFile(_ withName: String = "temp") -> URL {
    let url = FileManager.default.temporaryDirectory
      .appendingPathComponent(withName)
      .appendingPathExtension("json")
    let string = self
    try? string.write(to: url, atomically: true, encoding: .utf8)
    return url
  }
}

#Preview {
  ExportImportButtons()
}
