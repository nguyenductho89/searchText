import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var searchResults = [SearchResult]()
    @State private var searchHistory = ["Apple", "Cat", "Dog"] // Example search history
    @State private var showSuggestions = false // Track whether to show suggestions
    @State private var suggestionListHeight: CGFloat? = nil // Track suggestion list height

    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $searchText, onCommit: {
                    // Hide suggestions when the user commits a search
                    showSuggestions = false
                    performSearch()
                })

                if showSuggestions {
                    GeometryReader { geometry in
                        ScrollView {
                            SuggestionListView(searchText: $searchText, searchHistory: $searchHistory)
                                .frame(width: geometry.size.width, height: suggestionListHeight)
                                .background(Color.pink.opacity(0.5)) // Pink background for suggestions
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.top, 10)
                        }
                    }
                    .onAppear {
                        // Calculate the suggestion list height based on content size
                        suggestionListHeight = CGFloat(searchHistory.filter { $0.contains(searchText) }.count * 44)
                    }
                }

                List(searchResults, id: \.id) { result in
                    HStack {
                        Text(result.name)
                        Spacer()
                        Image(systemName: result.image)
                    }
                }
                .background(Color.yellow.opacity(0.5)) // Yellow background for search results
            }
            .navigationTitle("Search Example")
        }
        .onChange(of: searchText) { newValue in
            // Perform search on text change
            performSearch()
            // Show suggestions when there's text in the search bar
            showSuggestions = !searchText.isEmpty
        }
    }

    private func performSearch() {
        if searchText.isEmpty {
            searchResults = []
        } else {
            searchResults = allItems.filter { item in
                item.name.lowercased().contains(searchText.lowercased())
            }

            // Add the current search text to the search history if it's not already there
            if !searchHistory.contains(searchText) {
                searchHistory.append(searchText)
            }
        }
    }
}

struct SearchResult: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}

let allItems = [
    SearchResult(name: "Apple", image: "apple"),
    SearchResult(name: "Balloon", image: "balloon"),
    SearchResult(name: "Cat", image: "cat"),
    SearchResult(name: "Dog", image: "dog"),
]

struct SearchBarView: View {
    @Binding var searchText: String
    var onCommit: () -> Void

    var body: some View {
        HStack {
            TextField("Search", text: $searchText, onCommit: onCommit)
                .padding()
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)

            Button(action: {
                searchText = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing)
            }
        }
        .padding(.horizontal)
    }
}

struct SuggestionListView: View {
    @Binding var searchText: String
    @Binding var searchHistory: [String]

    var body: some View {
        ForEach(searchHistory.filter { $0.contains(searchText) }, id: \.self) { suggestion in
            Button(action: {
                searchText = suggestion
            }) {
                Text(suggestion)
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
