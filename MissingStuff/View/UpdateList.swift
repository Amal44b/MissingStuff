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
    
    @State var showConfirmationAlert = false
    
    @State var listUpdate: ListModel
    
    
    @State var items2 = ["Keys" , "Wallet" , "Phone" , "Glasses" , "HeadPhons" , "Watchs"]
    @State var showAlert = false
    @State var enteredItem = ""
    
    @State var showIncompleteDataAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    @State var listCreate = ListModel()
    @Environment(\.modelContext) var modelContext
    
    
    @State private var locationName = ""
    
    
    
    var body: some View {
        GeometryReader{_ in 
            ZStack{
                            Color.ourBackground.ignoresSafeArea()
                
                VStack(alignment:.leading){
                    
                    HStack{
                        Text("List Name")
                        
                        Text("*")
                            .foregroundColor(.red)
                    }
                    ZStack{
                        Rectangle()
                            .frame(width: 360 , height: 32.19)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        TextField("", text: $listUpdate.name)
                       
                            .padding()
                        
                    }
                    
                    HStack{
                        Text("Pick an item or add it")
                        
                        Text("*")
                            .foregroundColor(.red)
                        
                        VStack {
                            Button(action: {
                                showAlert = true
                            }) {
                                HStack{
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 15 , height: 15)
                                        .foregroundColor(.ourGreen)
                                    
                                    Text("Add Item")
                                        .foregroundColor(.ourGreen)
                                        .font(.system(size: 15))
                                }.padding(.leading, 80)
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
                                        .onTapGesture {
                                            if listUpdate.items.contains(items2[index]) {
                                                listUpdate.items.removeAll(where: { $0 == items2[index] })
                                            } else {
                                                listUpdate.items.append(items2[index])
                                            }
                                        }
                                    Text(items2[index])
                                   
                                }
                            }
                        }
                        .padding()
                    }
                    .scrollIndicators(.hidden)
                    
                    HStack{
                        Text("List Location")
                        
                        Text("*")
                            .foregroundColor(.red)
                    }
                    
                    MapView(locationName: $locationName)
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 300)
                        .cornerRadius(10)
                        .padding(.top, 10)
                    
                    if self.locationName != "" {
                        HStack{
                            Text(self.locationName)
                            
                        }
                    }
                    
                    //                if self.listUpdate.location != "" {
                    //                    HStack{
                    //                        Text(self.listUpdate.location)
                    ////                            .foregroundColor(.white)
                    //
                    //                        Text(self.listUpdate.subLocation)
                    ////                            .foregroundColor(.white)
                    //                    }
                    //                }
                    
                    Button(action:{
                        showConfirmationAlert = true
                        
                    }){
                        ZStack{
                            Rectangle()
                                .frame(width: 360 , height: 58)
                                .cornerRadius(10)
                                .foregroundColor(.ourGreen)
                            
                            Text("Save")
                                .foregroundColor(.white)
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
        }.ignoresSafeArea(.keyboard)
    }
    
}
