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
    
    var body: some View {
        NavigationStack(path: $path){
            
            List{
                ForEach(list, id: \.self) { subList in
                    NavigationLink(destination: CheckList(/*list: subList*/)){
                        VStack{
                            Text(subList.name)
                                .font(.headline)
                            Text("\(subList.items.count) items")
                                .font(.subheadline)
                                
                        }
                    }
                }
            }
            .navigationTitle("My Lists")
            .navigationDestination(for: ListModel.self) { subList in
                CreateList(listCreate: $list)
            }
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
            let list = ListModel(name: "", items: [], location: "", subLocation: "")
            modelContext.insert(list)
            path.append(list)
        
    }
    
}
#Preview {
    MainPage()
}
