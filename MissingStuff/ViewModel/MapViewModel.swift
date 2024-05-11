//
//  MapViewModel.swift
//  MissingStuff
//
//  Created by Maryam Mohammad on 01/11/1445 AH.
//

import Foundation
import MapKit
import SwiftData
import UserNotifications
import SwiftUI


struct MapView: UIViewRepresentable {
    @Binding var locationName: String
    @ObservedObject var locationManager = LocationManager()

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent1: self)
    }

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let map = MKMapView()
        let coordinate = CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        map.delegate = context.coordinator
        map.addAnnotation(annotation)

        // Show user's location
//        map.showsUserLocation = true
//        map.userTrackingMode = .follow

        return map
    }

    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {}
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
            self.parent.locationName = places?.first?.name ?? places?.first?.postalCode ?? "None"
        }
    }
}
