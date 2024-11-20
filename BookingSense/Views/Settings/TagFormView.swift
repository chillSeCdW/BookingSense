// Created for BookingSense on 10.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TagFormView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppStates.self) var appStates
  @Environment(\.dismiss) var dismiss

  @State var showingConfirmation: Bool = false
  @State var tagName: String = ""

  var tag: Tag?

  private var isCreate: Bool {
    tag == nil ? true : false
  }

  var body: some View {
    NavigationStack {
      Form {
        TextField("Tag name", text: $tagName)
        if !isCreate {
          Section(content: {
            HStack {
              Button("Delete tag", systemImage: "trash", role: .destructive, action: showDeleteConfirm)
                .foregroundStyle(.red)
            }
          }, footer: {
            Text("Tag will be removed from associated bookings/timeline entries")
          })
        }
      }
      .navigationTitle(isCreate ? "Create tag": "Edit tag")
      .toolbar {
        ToolbarTagEntry(save: save,
                        isCreate: isCreate,
                        didValuesChange: didValuesChange
        )
      }
      .presentationDetents([.medium, .large])
    }
    .onAppear {
      if let tag = tag {
        tagName = tag.name
      }
    }
    .confirmationDialog("Are you sure?", isPresented: $showingConfirmation) {
      Button("Delete tag \(tag?.name ?? "tag")", role: .destructive) {
        modelContext.delete(tag!)
        cleanExistingTagFilter()
        dismiss()
      }
    } message: {
      Text("Sure delete tag \(tag?.name ?? "")? will remove tags from bookings/timeline entries")
    }
  }

  func cleanExistingTagFilter() {
    appStates.activeTimeTagFilters.removeAll()
    appStates.activeBookingTagFilters.removeAll()
  }

  func showDeleteConfirm() {
    withAnimation {
      showingConfirmation = true
    }
  }

  func save() {
    if tagName.isEmpty {
      return
    }
    if isCreate {
      let newTag = Tag(name: tagName)
      modelContext.insert(newTag)
    } else {
      tag!.name = tagName
    }
    dismiss()
  }

  func didValuesChange() -> Bool {
    if let tag {
      if tagName != tag.name {
        return true
      }
    }
    return false
  }
}
