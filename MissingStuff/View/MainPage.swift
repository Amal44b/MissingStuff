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
//    @Environment(\.presentationMode) var presentationMode

    @Query var listQuery: [ListModel]
    
    @State var updateIsActive = false
    @State var selectedItem: ListModel? = nil
    
    @State private var isActive = false
    @State private var searchText = ""
    @State private var sortOrder = SortDescriptor(\ListModel.name)
    @State private var isPresented = false
    
    var filteredList: [ListModel] {
        if searchText.isEmpty{
            listQuery
        } else{
            listQuery.filter{ $0.name.localizedStandardContains(searchText)}
        }
    }
    var body: some View {
        NavigationStack{
            ZStack{
                Color.darkGray.ignoresSafeArea()
                List{
                    ForEach(filteredList) { subList in
                        NavigationLink(destination: CheckList(listCheck: subList)){
                            VStack{
                                Text(subList.name)
                                    .font(.headline)
                                    .foregroundStyle(.ourYellow)
                                Text("\(subList.items.count) items")
                                    .font(.subheadline)
                                
                            }.swipeActions(){
                                Button {
                                    selectedItem = subList
                                } label: {
                                    Text("Edit")
                                }
                                Button(role: .destructive) {
                                    if let index = listQuery.firstIndex(of: subList) {
                                        deleteItem(at: IndexSet([index]))
                                    }
                                } label: {
                                    Text("Delete")
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteItem)
                    
                }.sheet(item: $selectedItem){ selectedItem in
                    NavigationView{
                        UpdateList(listUpdate: selectedItem)
                    }
                    
                }
                .navigationTitle("My Lists")
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isActive = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.ourGreen)
                        }
                    }
                }
                .background(
                    NavigationLink(destination: CreateList(), isActive: $isActive) {
                        EmptyView()
                    }
                )
                LocationTracker()

                
            }.navigationBarBackButtonHidden(true)
            
        }.onAppear {
            let locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
                
            }
        }
    }
    func deleteItem(at offsets: IndexSet) {
        for offset in offsets {
            let listitem = listQuery[offset]
            modelContext.delete(listitem)
        }
        }
   

    
}
#Preview {
    MainPage()
}
