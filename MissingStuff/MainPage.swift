//
//  MainPage.swift
//  MissingStuff
//
//  Created by Maryam Mohammad on 20/10/1445 AH.
//

import SwiftUI
import SwiftData

struct MainPage: View {
    
    @Query var listQuery: [ListModel]
    @State private var isActive = false
    @State private var searchText = ""
    
    
//    var filteredList: [ListModel] {
//        if searchText.isEmpty{
//            list
//        } else{
//            list.filter{ $0.name.localizedStandardContains(searchText)}
//        }
//    }
    var body: some View {
        NavigationStack{
            
            List{
                ForEach(listQuery) { subList in
                    NavigationLink(destination: CheckList(listCheck: subList)){
                        VStack{
                            Text(subList.name)
                                .font(.headline)
                            Text("\(subList.items.count) items")
                                .font(.subheadline)
                                
                        }
                    }
                }/*.onDelete(perform: delete)*/
            }
            .navigationTitle("My Lists")
            .toolbar {
                              ToolbarItem(placement: .navigationBarTrailing) {
                                  Button(action: {
                                      isActive = true
                                  }) {
                                      Image(systemName: "plus")
                                  }
                              }
                          }
            .background(
                NavigationLink(destination: CreateList(/*listCreate: $list*/), isActive: $isActive) {
                    EmptyView()
                }
            )

        }
    }

//    func delete(indexSet: IndexSet) {
//        list.remove(atOffsets: indexSet)
//}
}
#Preview {
    MainPage()
}
