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
    
    @State var items = [NSLocalizedString("Keys", comment: "") , NSLocalizedString("Wallet", comment: "") , NSLocalizedString("Phone", comment: "") , NSLocalizedString("Glasses", comment: "") , NSLocalizedString("HeadPhons", comment: "") , NSLocalizedString("Watchs", comment: "")]
    @State var showAlert = false
    @State var enteredItem = ""

    @State var showIncompleteDataAlert = false
    @Environment(\.presentationMode) var presentationMode

    @State var listCreate = ListModel()
    @Environment(\.modelContext) var modelContext
    @State private var locationName = ""

    @State var isAddingData = true
    @Binding var isEditingData: Bool

    // المتغيرات المؤقتة
    @State private var tempName = ""
    @State private var tempItems = [String]()
    @State private var tempLocationName = ""
    @State private var alertMessage: String = ""
    
    
    
    private enum Field: Int, CaseIterable {
           case listNameKeyboard
       }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        GeometryReader { geometry in
//            ScrollView {
            ZStack {
                Color.ourBackground.ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("List Name")
                        Text("*")
                            .foregroundColor(.red)
                    }
                    ZStack {
                        Rectangle()
                            .frame(maxWidth: geometry.size.width)
                            .frame(height: 35)
                            .cornerRadius(10)
                            .foregroundColor(.midWhite)
                        TextField("", text: $tempName)
                            .focused($focusedField, equals: .listNameKeyboard)
                            .padding()
                    } .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            Button("Done") {
                                focusedField = nil
                            }
                        }
                    }
                    
                    HStack {
                        Text("Pick an item or add it")
                        Text("*")
                            .foregroundColor(.red)
                        VStack {
                            Button(action: {
                                showAlert = true
                            }) {
                                Spacer()
                                HStack {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.ourGreen)
                                    Text("Add Item")
                                        .foregroundColor(.ourGreen)
                                        .font(.system(size: 15))
                                }.padding()
                            }
                            .alert("Add Item", isPresented: $showAlert, actions: {
                                TextField("", text: $enteredItem)
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
                                        .foregroundColor(tempItems.contains(item) ? .ourGreen : .ourWhite)
                                        .onTapGesture {
                                            if let index = tempItems.firstIndex(of: item) {
                                                tempItems.remove(at: index)
                                            } else {
                                                tempItems.append(item)
                                            }
                                        }
                                    Text(item)
                                        .padding()
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    
                    HStack {
                        Text("List Location")
                        Text("*")
                            .foregroundColor(.red)
                    }
                    
                    MapView(locationName: $tempLocationName)
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: geometry.size.height / 2)
                        .cornerRadius(10)
                        .padding(.top, 10)
                    
                    if self.tempLocationName != "" {
                        Text(self.tempLocationName)
                            .frame(maxWidth: geometry.size.width)
                    }
                    
                    Button(action: {
                        if tempName.isEmpty || tempItems.isEmpty {
                            showIncompleteDataAlert = true
                            alertMessage = "Please complete all data fields."
                        } else if tempLocationName.isEmpty {
                            showIncompleteDataAlert = true
                            alertMessage = "Please select a location"
                        } else {
                            let geocoder = CLGeocoder()
                            geocoder.geocodeAddressString(tempLocationName) { (placemarks, error) in
                                guard let placemark = placemarks?.first else { return }
                                let coordinate = placemark.location?.coordinate ?? kCLLocationCoordinate2DInvalid
                                listCreate.latitude = coordinate.latitude
                                listCreate.longitude = coordinate.longitude
                                listCreate.name = tempName
                                listCreate.items = tempItems
                                locationName = tempLocationName
                                modelContext.insert(listCreate)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(maxWidth: geometry.size.width)
                                .frame(height: 60)
                                .cornerRadius(10)
                                .foregroundColor(.ourGreen)
                            Text("Save")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal)
                .alert(isPresented: $showIncompleteDataAlert) {
                    Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }.ignoresSafeArea(.keyboard , edges: .bottom)
            .onAppear {
                // عند التحميل، نسخ القيم الأصلية إلى المتغيرات المؤقتة
                tempName = listCreate.name
                tempItems = listCreate.items
                tempLocationName = locationName
               
            }
            .onDisappear {
                // عند الخروج من الصفحة، إعادة تعيين القيم الأصلية إذا لم يتم الضغط على "Save"
                if !isEditingData {
                    listCreate.name = tempName
                    listCreate.items = tempItems
                    locationName = tempLocationName
                }
            }
            .navigationTitle("Add List")
            .navigationBarTitleDisplayMode(.inline)
            
        }
//        }
        
    }

        }
        



    //#Preview {
    //    CreateList()
    //}

