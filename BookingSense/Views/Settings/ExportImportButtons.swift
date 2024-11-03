// Created for BookingSense on 03.07.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData
import OSLog

struct ExportImportButtons: View {
  private let logger = Logger(subsystem: "BookingSense", category: "ExportImportButtons")
  @Environment(\.modelContext) private var modelContext
  @Query private var entries: [BookingEntry]
  @Query private var tags: [Tag]
  @Query private var timeline: [TimelineEntry]

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
        exportJson(BookingsList(data: entries, tags: tags, timeline: timeline))
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
          let access = file.startAccessingSecurityScopedResource()
          defer {
             if access {
               file.stopAccessingSecurityScopedResource()
             }
          }
          let data = try Data(contentsOf: file)
          importedData = try JSONDecoder().decode(BookingsList.self, from: data)
          if entries.isEmpty && tags.isEmpty {
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
        Button("Clear and insert", role: .destructive) {
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
      try modelContext.delete(model: Tag.self)
      try modelContext.delete(model: TimelineEntry.self)
    } catch {
      logger.error("Failed to delete all Booking entries: \(error)")
    }
  }

  // swiftlint:disable function_body_length
  func processImportedData(_ importList: BookingsList?) {
    var importTags: [String: Tag] = [:]
    var importTimelineEntries: [String: TimelineEntry] = [:]
    importList?.tags.forEach { importEntry in
      let entry = importTags.contains { $0.key == importEntry.uuid }
        if !entry {
          let newTag = Tag(uuid: importEntry.uuid, name: importEntry.name)
          importTags[newTag.uuid] = newTag
        }
    }
    importList?.timeline.forEach { newTimelineEntry in
      let entry = importTimelineEntries.contains { $0.key == newTimelineEntry.uuid }
        if !entry {
          let newTimelineEntry = TimelineEntry(
            uuid: newTimelineEntry.uuid,
            state: newTimelineEntry.state,
            name: newTimelineEntry.name,
            amount: newTimelineEntry.amount,
            amountPrefix: newTimelineEntry.amountPrefix,
            isDue: newTimelineEntry.isDue,
            tag: nil,
            completedAt: newTimelineEntry.completedAt,
            bookingEntry: nil
          )
          importTimelineEntries[newTimelineEntry.uuid] = newTimelineEntry
      }
    }
    try? modelContext.transaction {
      importList?.data.forEach { importBookingEntry in
        modelContext.insert(
          BookingEntry(
            uuid: importBookingEntry.uuid,
            name: importBookingEntry.name,
            state: importBookingEntry.state,
            amount: importBookingEntry.amount,
            amountPrefix: importBookingEntry.amountPrefix,
            interval: Interval(rawValue: importBookingEntry.interval)!,
            tag: nil,
            timelineEntries: nil
          )
        )
      }
      do {
          try modelContext.save()
      } catch {
        logger.error("error saving modelContext: \(error)")
      }
    }
    importList?.tags.forEach { importTag in
      if let bookingEntryIDs = importTag.bookingEntries {
        let filteredBookEntries = entries.filter {
          return bookingEntryIDs.contains($0.uuid)
        }
        let newTag = Tag(uuid: importTag.uuid, name: importTag.name)

        filteredBookEntries.forEach { entry in
          entry.tag = newTag
        }
      }
    }
    importList?.timeline.forEach { importTimelineEntry in
      if let bookingEntryIDs = importTimelineEntry.bookingEntry {
        let filteredBookEntries = entries.filter { bookingEntryIDs.contains($0.uuid) }

        let timelineEntry = TimelineEntry(
          state: importTimelineEntry.state,
          name: importTimelineEntry.name,
          amount: importTimelineEntry.amount,
          amountPrefix: importTimelineEntry.amountPrefix,
          isDue: importTimelineEntry.isDue,
          tag: nil,
          completedAt: importTimelineEntry.completedAt,
          bookingEntry: nil
        )

        filteredBookEntries.forEach { entry in
          if entry.timelineEntries == nil {
            entry.timelineEntries = []
          }
          entry.timelineEntries?.append(timelineEntry)
        }
      }
    }
    try? modelContext.save()
  }
}
// swiftlint:enable function_body_length

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
