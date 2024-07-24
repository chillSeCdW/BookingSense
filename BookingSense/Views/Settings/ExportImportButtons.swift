// Created for BookingSense on 03.07.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData

struct ExportImportButtons: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var entries: [BookingEntry]

  @State private var showImport = false
  @State private var isLoading = false
  @State private var showErrorAlert = false
  @State private var showSuccessAlert = false
  @State private var importConflict = false
  @State private var thrownError: Error?
  @State private var importedData: BookingsList?

  var body: some View {
    Button {
      isLoading = true
      Task {
        exportJson(BookingsList(entries))
        isLoading = false
      }
    } label: {
      HStack {
        if isLoading {
          Spacer()
          ProgressView()
          Spacer()
        } else {
          Image(systemName: "arrow.up.doc")
          Text("Export as json")
        }
      }
    }
    .disabled(isLoading)
    .onDisappear(perform: {
      importedData = nil
      showSuccessAlert = false
      showErrorAlert = false
    })
    Button {
      showImport = true
    } label: {
      HStack {
        Image(systemName: "arrow.down.doc")
        Text("Import as json")
      }
    }
    .fileImporter(
      isPresented: $showImport,
      allowedContentTypes: [.json]
    ) { result in
      switch result {
      case .success(let file):
        do {
          let data = try Data(contentsOf: file.standardizedFileURL)
          importedData = try JSONDecoder().decode(BookingsList.self, from: data)
          if entries.isEmpty {
            processImportedData(importedData)
            showSuccessAlert = true
            importConflict = false
          } else {
            showSuccessAlert = true
            importConflict = true
          }
        } catch {
          thrownError = error
          showErrorAlert = true
        }
      case .failure(let error):
        thrownError = error
        showErrorAlert = true
      }
    }.alert(
      "Something went wrong",
      isPresented: $showErrorAlert,
      presenting: thrownError
    ) { _ in
    } message: { err in
      Text(err.localizedDescription)
    }
    .alert(
      importConflict ? "Conflict" : "Success",
      isPresented: $showSuccessAlert,
      presenting: importConflict
    ) { isConflict in
      if isConflict {
        Button("Cancel", role: .cancel) {}
        Button("Merge with existing") {
          processImportedData(importedData)
        }
        Button("Clear and insert") {
          cleanData()
          processImportedData(importedData)
        }
      } else {
        Button("Ok") {
        }
      }
    } message: { isConflict in
      if isConflict {
        Text("Entries already found")
      }
    }
  }

  func exportJson(_ entries: BookingsList) {
    let jsonString = encodeJson(entries)
    let filePath = FileManager.default.temporaryDirectory
      .appendingPathComponent("bookingSenseData")
      .appendingPathExtension("json")
    do {
      try jsonString!.write(to: filePath, atomically: true, encoding: .utf8)

      let activityViewController = UIActivityViewController(
        activityItems: [filePath],
        applicationActivities: nil
      )
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
         let rootViewController = windowScene.windows.first?.rootViewController {
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = rootViewController.view // The view from which the popover originates
            popoverController.sourceRect = CGRect(
              x: rootViewController.view.bounds.midX,
              y: rootViewController.view.bounds.midY,
              width: 0,
              height: 0
            )
            popoverController.permittedArrowDirections = []
        }
        rootViewController.present(activityViewController, animated: true, completion: nil)
      }
    } catch {
      print("Failed to write file: \(error)")
    }
  }

  func encodeJson(_ entries: BookingsList) -> String? {
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

  func cleanData() {
    do {
      try modelContext.delete(model: BookingEntry.self)
    } catch {
      print("Failed to delete all Booking entries")
    }
  }

  func processImportedData(_ importList: BookingsList?) {
    importList?.data.forEach { newEntry in
      let oldEntry = entries.filter {$0.id == newEntry.id}.first
      if oldEntry == nil {
        modelContext.insert(newEntry)
      }
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
