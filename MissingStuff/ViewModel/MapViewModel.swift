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
    var mapView = MKMapView()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {}
}



class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    var annotation: MKPointAnnotation?
    
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if annotation == nil {
                annotation = MKPointAnnotation()
                mapView.addAnnotation(annotation!)
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            mapView.addGestureRecognizer(tapGesture)
        }
        
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let context = parent.mapView.superview else {
            return
        }
        
        let location = gestureRecognizer.location(in: context)
        let coordinate = parent.mapView.convert(location, toCoordinateFrom: context)
        annotation?.coordinate = coordinate
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (places, error) in
            if let place = places?.first {
                self.parent.locationName = place.name ?? place.postalCode ?? "None"
            }
        }
    }

    }
