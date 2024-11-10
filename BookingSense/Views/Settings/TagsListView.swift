// Created for BookingSense on 10.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TagsListView: View {
  @Query(sort: [SortDescriptor<Tag>(\.name, comparator: .localized)]) var tags: [Tag]

  @State private var selectedTag: Tag?

  var body: some View {
    List(tags) { tag in
      HStack {
        Text(tag.name)
        Spacer()
        Button("Edit") {
          selectedTag = tag
        }
      }
    }
    .sheet(item: $selectedTag, onDismiss: {
      selectedTag = nil
    }) { tag in
      TagFormView(tag: tag)
    }
  }
}
