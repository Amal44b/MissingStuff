//
//  UpdateList.swift
//  MissingStuff
//
//  Created by shaden  on 26/10/1445 AH.
//


import SwiftUI
import SwiftData
import MapKit

struct UpdateList: View {
    
//    @State var items2 = ["Keys" , "Wallet" , "Phone" , "Glasses" , "HeadPhons" , "Watchs"]
//    @State var showAlert = false
//    @State var enteredItem = ""
//    
//    @State var selectedItems: Set<String> = []
//    @State var listName = ""
//    @State var address = ""
//    @State var subAddress = ""
//    
//    @State var showConfirmationAlert = false
//    @State var showIncompleteDataAlert = false
//    @State var listUpdate: ListModel
//    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.modelContext) var modelContext

    @State var items = ["Keys" , "Wallet" , "Phone" , "Glasses" , "HeadPhons" , "Watchs"]
    @State var showAlert = false
    @State var enteredItem = ""
    
    @State var showIncompleteDataAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    @State var listCreate = ListModel()
    @Environment(\.modelContext) var modelContext

    // Binding for location name
    @State private var locationName = ""
    
    
    
    var body: some View {
        ZStack{
            Color.darkGray.ignoresSafeArea()
            
            VStack(alignment:.leading){
                
                HStack{
                    Text("List Name")
//                        .foregroundColor(.white)
                    Text("*")
                        .foregroundColor(.red)
                }
                ZStack{
                    Rectangle()
                        .frame(width: 360 , height: 32.19)
                        .cornerRadius(10)
                        .foregroundColor(.lightGray)
                    TextField("", text: $listUpdate.name)
//                        .foregroundColor(.white)
                        .padding()
                       
                }
                
                HStack{
                    Text("Pick an item or add it")
//                        .foregroundColor(.white)
                    Text("*")
                        .foregroundColor(.red)
                    
                    VStack {
                        Button(action: {
                            showAlert = true
                        }) {
                            Image(systemName: "plus.app.fill")
                                .resizable()
                                .frame(width: 22 , height: 22)
                                .foregroundColor(.ourGreen)
                                .padding(.leading, 150.0)
                        }
                        .alert("Add Item" , isPresented: $showAlert , actions: {
                            TextField("", text: $enteredItem)
                            
                            Button("Add", action: {
                                if !self.enteredItem.isEmpty {
                                    self.items2.append(enteredItem)
                                    self.enteredItem = ""
                                }
                            })
                            Button("Cancel", role: .cancel, action: {})
                        }, message: {
                            Text("Please enter your item.")
                        })
                    }
                }
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(items2.indices, id: \.self) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 95, height: 70)
                                    .foregroundColor(listUpdate.items.contains(items2[index]) ? .ourGreen : .ourWhite)
                                    .border(Color.ourGreen)
                                    .onTapGesture {
                                        if listUpdate.items.contains(items2[index]) {
                                            listUpdate.items.removeAll(where: { $0 == items2[index] })
                                        } else {
                                            listUpdate.items.append(items2[index])
                                        }
                                    }
                                Text(items2[index])
//                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
                
                HStack{
                    Text("List Location")
//                        .foregroundColor(.white)
                    Text("*")
                        .foregroundColor(.red)
                }
                
                MapView(locationName: $locationName)
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding(.top, 10)
                
                if self.listUpdate.location != "" {
                    HStack{
                        Text(self.listUpdate.location)
//                            .foregroundColor(.white)
                        
                        Text(self.listUpdate.subLocation)
//                            .foregroundColor(.white)
                    }
                }
                
                Button(action:{
                        showConfirmationAlert = true
                    
                }){
                    ZStack{
                        Rectangle()
                            .frame(width: 360 , height: 58)
                            .cornerRadius(10)
                            .foregroundColor(.ourGreen)
                        
                        Text("Update")
                            .foregroundColor(.white) // تغيير اللون إلى اللون الذي تفضله
                    }
                }
            }.padding()
            .alert(isPresented:  $showConfirmationAlert) {
                Alert(title: Text(""),
                      message: Text("Are you sure you want to update?"),
                      primaryButton: .default(Text("Yes"), action: {
                                modelContext.insert(listUpdate)
                                presentationMode.wrappedValue.dismiss()
                }),
                      secondaryButton: .destructive(Text("No"), action: {
                    presentationMode.wrappedValue.dismiss()
                }))
            }
        }
        .navigationTitle("Edit List") // تغيير عنوان الصفحة
        .navigationBarTitleDisplayMode(.inline)
    }
}

