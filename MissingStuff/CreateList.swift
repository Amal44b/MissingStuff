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

    var body: some View {
        ZStack{
            Color.darkGray.ignoresSafeArea()
            Text("")
                .navigationTitle("Add List").foregroundColor(.white)
            
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
                    TextField("" , text: $listCreate.name)
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
                                    .frame(width: 95, height: 70)
                                    .foregroundColor(listCreate.items.contains(item) ? .ourGreen : .ourWhite)
                                    .border(Color.ourGreen)
                                    .onTapGesture {
                                        if listCreate.items.contains(item) {
//                                            listCreate.items.remove(item)
                                        } else {
                                            listCreate.items.append(item)
                                        }
                                    }
                                Text(item)
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
                
                MapView(address: self.$listCreate.location, subAddress: self.$listCreate.subLocation).edgesIgnoringSafeArea(.all)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding(.top, 10)
                
                if self.listCreate.location != "" {
                    HStack{
                        Text(self.listCreate.location)
//                            .foregroundColor(.white)
                        
                        Text(self.listCreate.subLocation)
//                            .foregroundColor(.white)
                    }
                }
                Button(action:{
                    
                    if listCreate.name.isEmpty || listCreate.items.isEmpty || listCreate.subLocation.isEmpty {
                                       showIncompleteDataAlert = true
                                       return
                                   }
                    
                    modelContext.insert(listCreate)
                    
                    
                    presentationMode.wrappedValue.dismiss()
                }){
                    ZStack{
                        Rectangle()
                            .frame(width: 360 , height: 58)
                            .cornerRadius(10)
                            .foregroundColor(.ourGreen)
                        
                        Text("Create")
                            .foregroundColor(.white)
                    }
                }
            }.padding()
            .alert(isPresented: $showIncompleteDataAlert) {
                            Alert(title: Text("Incomplete Data"), message: Text("Please complete all data fields."), dismissButton: .default(Text("OK")))
                        }
        }/*.navigationBarBackButtonHidden(true)*/
            .navigationTitle("Add List")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct MapView : UIViewRepresentable{
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent1: self)
    }
    
    
    @Binding var address : String
    @Binding var subAddress : String
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) ->  MKMapView {
        let map = MKMapView()
        
        let coordinate = CLLocationCoordinate2D(latitude:  24.7136, longitude: 46.6753)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        map.delegate = context.coordinator
        
        map.addAnnotation(annotation)
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
}

class Coordinator: NSObject, MKMapViewDelegate {

    var parent: MapView

    init(parent1: MapView) {
        parent = parent1
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {

            return nil
        }

        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.tintColor = .red

            let imageView = UIImageView(image: UIImage(systemName: "mappin"))
            imageView.tintColor = .red
            annotationView!.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 50),
                imageView.heightAnchor.constraint(equalToConstant: 50)
            ])


            annotationView!.isDraggable = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView , annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState){
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)){ (places, err) in
            
            
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            
            self.parent.address = (places?.first?.name ?? places?.first?.postalCode)!
            self.parent.subAddress = (places?.first?.subAdministrativeArea ?? places?.first?.country ?? "None")!
            
        }
    }
}


//#Preview {
//    CreateList()
//        .modelContainer(for: ListModel.self)
//}
