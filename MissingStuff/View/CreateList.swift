//
//  CreateList.swift
//  MissingStuff
//
//  Created by Maryam Mohammad on 20/10/1445 AH.
//

import SwiftUI
import MapKit
import SwiftData





struct CreateList: View {
    
    @State var items = ["Keys" , "Wallet" , "Phone" , "Glasses" , "HeadPhons" , "Watchs"]
    @State var showAlert = false
    @State var enteredItem = ""
    
    @State var showIncompleteDataAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    @State var listCreate = ListModel()
    @Environment(\.modelContext) var modelContext
    
    
    @State private var locationName = ""
    
    var body: some View {
       
            GeometryReader{geometry in
               
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
                                    .frame(maxWidth: geometry.size.width)
                                    .frame(height: 35)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                TextField("" , text: $listCreate.name)
                                
                                
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
                                        Spacer()
                                        HStack{
                                            
                                            Image(systemName: "plus")
                                                .resizable()
                                                .frame(width: 15 , height: 15)
                                                .foregroundColor(.ourGreen)
                                           
                                            Text("Add Item")
                                                .foregroundColor(.ourGreen)
                                                .font(.system(size: 15))
                                        }.padding()
                                       
                                    }
                                    .alert("Add Item" , isPresented: $showAlert , actions: {
                                        TextField("" , text: $enteredItem)
                                        
                                        Button("Add", action: {
                                            if !self.enteredItem.isEmpty {
                                                self.items.append(self.enteredItem)
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
                                    ForEach(items, id: \.self) { item in
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(maxWidth: geometry.size.width)
                                                .frame(height: 60)
                                                .foregroundColor(listCreate.items.contains(item) ? .ourGreen : .ourWhite)
                                                
                                                .onTapGesture {
                                                    if let index = listCreate.items.firstIndex(of: item) {
                                                        listCreate.items.remove(at: index)
                                                    } else {
                                                        listCreate.items.append(item)
                                                    }
                                                }
                                            Text(item)
                                                .padding()
                                            
                                        }
                                    }
                                }
//                                .padding()
                            }
                            .scrollIndicators(.hidden)
                            
                            HStack{
                                Text("List Location")
                                
                                Text("*")
                                    .foregroundColor(.red)
                            }
                            
                            
                            MapView(locationName: $locationName)
                                .edgesIgnoringSafeArea(.all)
                                .frame(height: geometry.size.height / 2)
                                .cornerRadius(10)
                                .padding(.top, 10)
                            
                            if self.locationName != "" {
                                
                                    Text(self.locationName)
                                        .frame(maxWidth: geometry.size.width)
                                                                        
                            }
                            
                            Button(action:{
                                if listCreate.name.isEmpty || listCreate.items.isEmpty || locationName.isEmpty {
                                    showIncompleteDataAlert = true
                                    return
                                }
                                
                                let geocoder = CLGeocoder()
                                geocoder.geocodeAddressString(locationName) { (placemarks, error) in
                                    guard let placemark = placemarks?.first else { return }
                                    let coordinate = placemark.location?.coordinate ?? kCLLocationCoordinate2DInvalid
                                    listCreate.latitude = coordinate.latitude
                                    listCreate.longitude = coordinate.longitude
                                    modelContext.insert(listCreate)
                                    
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }){
                                ZStack{
                                    Rectangle()
                                        .frame(maxWidth: geometry.size.width)
                                        .frame(height: 60)
                                        .cornerRadius(10)
                                        .foregroundColor(.ourGreen)
                                    
                                    Text("Create")
                                        .foregroundColor(.white)
                                }
                            }
                            
                        }.padding(.horizontal)
                            .alert(isPresented: $showIncompleteDataAlert) {
                                Alert(title: Text("Incomplete Data"), message: Text("Please complete all data fields."), dismissButton: .default(Text("OK")))
                                
                            }
                        
                    }
                    .navigationTitle("Add List")
                    .navigationBarTitleDisplayMode(.inline)
                
            }.ignoresSafeArea(.keyboard)
        }
    }
    



#Preview {
    CreateList()
}

