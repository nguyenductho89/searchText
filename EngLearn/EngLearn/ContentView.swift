import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var searchResults = [SearchResult]()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchText, onCommit: performSearch)
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button("Clear") {
                    searchText = ""
                    searchResults.removeAll()
                }
                .padding(.vertical)
                
                List(searchResults, id: \.id) { result in
                    HStack {
                        Text(result.name)
                        Spacer()
                        Image(systemName: result.image)
                    }
                }
            }
            .navigationTitle("Search Example")
        }
    }
    
    private func performSearch() {
        if searchText.isEmpty {
            searchResults = []
        } else {
            searchResults = allItems.filter { item in
                item.name.lowercased().contains(searchText.lowercased())
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
