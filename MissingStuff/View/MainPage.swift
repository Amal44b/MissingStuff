//
//  MainPage.swift
//  MissingStuff
//
//  Created by Maryam Mohammad on 20/10/1445 AH.
//

import SwiftUI
import SwiftData
import CoreLocation

struct MainPage: View {
    
    @Environment(\.modelContext) var modelContext
   

    @Query var listQuery: [ListModel]
    
    @State var updateIsActive = false
    @State var selectedItem: ListModel? = nil
    
    @State private var isActive = false
    @State private var searchText = ""
    @State private var sortOrder = SortDescriptor(\ListModel.name)
    @State private var isPresented = false
    
    
    @ObservedObject var locationManager = LocationManager()
    @Query var locationQuery: [ListModel]
    
    @State private var isActiveEdit = false
    @State private var isAddingData = false
    @State private var isEditingData = false
    @State var listUpdate = ListModel()
    
    var filteredList: [ListModel] {
        if searchText.isEmpty{
            listQuery
        } else{
            listQuery.filter{ $0.name.localizedStandardContains(searchText)}
        }
    }
    var body: some View {
        GeometryReader{_ in
            NavigationStack{
                ZStack{
                    Color.ourBackground.ignoresSafeArea()
                    
                    List{
                        ForEach(filteredList) { subList in
                            NavigationLink(destination: CheckList(listCheck: subList)){
                                VStack(alignment: .leading){
                                    Text(subList.name)
                                        .font(.headline)
                                        .foregroundStyle(.ourYellow)
                                    Text("\(subList.items.count) items")
                                        .font(.subheadline)
                                        .opacity(5.0)
                                    
                                }.swipeActions(){
                                    Button {
                                        isEditingData = true
                                        isActiveEdit = true
                                        isActive = false
                                        isAddingData = false
                                        selectedItem = subList
                                    } label: {
                                        Text("Edit")
                                            .foregroundColor(.red)
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
                    }
//                    }.sheet(item: $selectedItem){ selectedItem in
//                        NavigationView{
//                            UpdateList(listUpdate: selectedItem)
//                        }
                        
                    }
                    .navigationTitle("My Lists")
                    .searchable(text: $searchText)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isAddingData = true
                                isEditingData = false
                                isActive = true
                                isActiveEdit = false
                                selectedItem = ListModel()
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.ourGreen)
                            }
                        }
                    }
                    .background(
                        NavigationLink(destination: CreateList(listCreate: ListModel() ,isEditingData: $isEditingData), isActive: $isActive) {
                            EmptyView()
                        }
                    )
                NavigationLink(destination: CreateList(listCreate: selectedItem ?? ListModel() , isEditingData : $isEditingData ), isActive: $isActiveEdit) {
                          EmptyView()
                              
                      }
//                    LocationTracker()
                    
                    
                }.navigationBarBackButtonHidden(true)
//                    .navigationTitle("Main Page")
                
            }  .accentColor(.ourGreen)
                .onAppear {
                    let locationManager1 = CLLocationManager()
                    locationManager1.requestWhenInUseAuthorization()
//                    locationManager1.requestAlwaysAuthorization()
                    
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
                        
                    }
                    locationManager.sortLocations(listQuery: locationQuery)
                }.ignoresSafeArea(.keyboard)
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
        .modelContainer(for: ListModel.self)
}
