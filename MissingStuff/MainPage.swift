//
//  MainPage.swift
//  MissingStuff
//
//  Created by Maryam Mohammad on 20/10/1445 AH.
//

import SwiftUI
import SwiftData

struct MainPage: View {
    @Environment(\.modelContext) var modelContext
    @State var path = [ListModel]()
    @State var list: [ListModel] = []
    @Query var listQuery: [ListModel]
    @State private var searchText = ""
    
    
    var filteredList: [ListModel] {
        if searchText.isEmpty{
            list
        } else{
            list.filter{ $0.name.localizedStandardContains(searchText)}
        }
    }
    var body: some View {
        NavigationStack(path: $path){
            
            List{
                ForEach(filteredList, id: \.self) { subList in
                    NavigationLink(destination: CheckList(/*list: subList*/ listModel: subList)){
                        VStack{
                            Text(subList.name)
                                .font(.headline)
                            Text("\(subList.items.count) items")
                                .font(.subheadline)
                                
                        }
                    }
                }.onDelete(perform: delete)
            }
            .navigationTitle("My Lists")
            .navigationDestination(for: ListModel.self) { subList in
                CreateList(listCreate: $list)
            }.searchable(text: $searchText , prompt: "Search")
            .toolbar{
                Button(action: {
                    addList()
                }) {
                    Image(systemName: "plus")
                        
                        
                }
            }
        }
    }
        func addList(){
            let list = ListModel(name: "", items: [], location: "", subLocation: "", isCompleted: false)
            modelContext.insert(list)
            path.append(list)
        
    }
    func delete(indexSet: IndexSet) {
        list.remove(atOffsets: indexSet)
}
}
#Preview {
    MainPage()
}
