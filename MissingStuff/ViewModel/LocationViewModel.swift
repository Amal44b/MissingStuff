//
//  LocationViewModel.swift
//  MissingStuff
//
//  Created by Maryam Mohammad on 01/11/1445 AH.
//

import Foundation
import SwiftUI
import CoreLocation
import UserNotifications
import SwiftData

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
   
    var allLocation: [[CLLocationDegrees]] = []

    private var lastLocationUpdate: Date? = Date()
    private var currentSite: ListModel?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }

    func sortLocations(listQuery:[ListModel]) {
        allLocation = []
        print("tessst7")
        
        // Check if listQuery is not empty
        guard !listQuery.isEmpty else {
            print("listQuery is empty")
            return
        }
        
        for model in listQuery {
            let location: [CLLocationDegrees] = [model.latitude, model.longitude]
            allLocation.append(location)
            
        }
//        sendNotification()
        for site in allLocation {
            print(site)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("tessst5")
        guard let location = locations.last else { return }
        self.userLocation = location
//        lastLocationUpdate = Date()
        checkIfInsideSite(location: location)
        print("tessst6")
    }

//    func checkIfInsideSite(location: CLLocation) {
//        let currentTime = Date()
//        
//        for site in allLocation {
//            let siteLocation = CLLocation(latitude: site[0], longitude: site[1])
//            let distance = location.distance(from: siteLocation)
//            
//            if distance <= 20 {
//                print("inside")
//                
//                let timeInterval = currentTime.timeIntervalSince(lastLocationUpdate!)
//                print(currentTime.timeIntervalSince(lastLocationUpdate!))
//                
//                if let lastLocation = userLocation {
//                    let lastDistance = lastLocation.distance(from: siteLocation)
//                    print("A")
//                    sendNotificationInside()
//                    if lastDistance > 20 {
//                        if timeInterval >= 6 {
//                            print("outside")
//                            sendNotificationOutside()
//                            lastLocationUpdate = nil
//                            currentSite = nil
//                        }
//                    }
//                    }
//                }
//            }
//        }
    
    func checkIfInsideSite(location: CLLocation) {
        let currentTime = Date()
        
        for site in allLocation {
            let siteLocation = CLLocation(latitude: site[0], longitude: site[1])
            let distance = location.distance(from: siteLocation)
            
            if distance <= 20 {
                print("inside")
                
                if let lastLocation = userLocation {
                    let lastDistance = lastLocation.distance(from: siteLocation)
                    print("A")
                    sendNotificationInside()
                    
                    let timeInterval = currentTime.timeIntervalSince(lastLocationUpdate!)
                    print(timeInterval)
                    
                    if (timeInterval >= 60 && lastDistance >= 20) {
//                        if lastDistance >= 20 {
                            print("outside")
                            sendNotificationOutside()
                            lastLocationUpdate = nil
                            currentSite = nil
//                        }
                    }
                }
            }
        }
    }
    
//    var lastInsideSite: CLLocation?
//    var isCheckingExit = false
//
//    func checkIfInsideSite(location: CLLocation) {
//        let currentTime = Date()
//        
//        // Check if the user is inside any site
//        var insideSite = false
//        for site in allLocation {
//            let siteLocation = CLLocation(latitude: site[0], longitude: site[1])
//            let distance = location.distance(from: siteLocation)
//            if distance <= 20 {
//                insideSite = true
//                break
//            }
//        }
//        
//        if insideSite {
//            // User is inside a site
//            if let lastLocation = userLocation {
//                let lastDistance = lastLocation.distance(from: lastInsideSite ?? CLLocation())
//                if lastDistance >= 20 && !isCheckingExit {
//                    isCheckingExit = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
//                        if let lastLocationUpdate = self.lastLocationUpdate,
//                           lastLocationUpdate == currentTime {
//                            print("outside")
//                            self.sendNotificationOutside()
//                            self.lastLocationUpdate = nil
//                            self.currentSite = nil
//                        }
//                        self.isCheckingExit = false
//                    }
//                }
//            }
//            lastInsideSite = location
//        } else {
//            // User is not inside any site
//            lastInsideSite = nil
//        }
//    }


  
    
//    func checkIfInsideSite(location: CLLocation) {
//        let currentTime = Date()
//        
//        for site in allLocation {
//            let siteLocation = CLLocation(latitude: site[0], longitude: site[1])
//            let distance = location.distance(from: siteLocation)
//            
//            if distance >= 20 {
//                print("inside")
//                
//                if let lastLocation = userLocation {
//                    let lastDistance = lastLocation.distance(from: siteLocation)
//                    print("A")
//                    sendNotificationInside()
//                    
//                    let timeInterval = currentTime.timeIntervalSince(lastLocationUpdate!)
//                    print(timeInterval)
//                    
//                    if lastDistance < 20 {
//                        if timeInterval >= 6 {
//                            print("outside")
//                            sendNotificationOutside()
//                            lastLocationUpdate = nil
//                            currentSite = nil
//                        }
//                    }
//                }
//            }
//        }
//    }


//    func checkIfInsideSite(location: CLLocation) {
//        let currentTime = Date()
//        var insideSite = false
//        
//        for site in allLocation {
//            let siteLocation = CLLocation(latitude: site[0], longitude: site[1])
//            let distance = location.distance(from: siteLocation)
//            
//            if distance <= 20 {
//                insideSite = true
//                break
//            }
//        }
//        
//        if insideSite {
//            print("inside")
//            sendNotificationInside()
//        } else {
//            print("outside")
//            sendNotificationOutside()
//        }
//    }



    func sendNotificationInside() {
        print("test inside")

        let content = UNMutableNotificationContent()
        content.title = "Inside"
        content.body = "Please check your stuff before leaving."
        content.sound = .default
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "SiteNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func sendNotificationOutside() {
        print("test OutSide")

        let content = UNMutableNotificationContent()
        content.title = "OutSide"
        content.body = "Please check your stuff before leaving."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "SiteNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    

}



//func checkIfInsideSite(location: CLLocation) {
//    
//    for site in allLocation {
//        let siteLocation = CLLocation(latitude: site[0], longitude: site[1])
//        let distance = location.distance(from: siteLocation)
//        
//        if distance <= 20 { // User is within 20 meters of the site
//            if currentSite == nil {
////                    currentSite = listQuery[allLocation.firstIndex(of: site)!]
//                lastLocationUpdate = Date()
//                print("User is inside the site.")
//                sendNotification()
//            }
//
////                let currentTime = Date()
////                let timeInterval = currentTime.timeIntervalSince(lastLocationUpdate!)
////
////                if timeInterval >= 6 { // User has been inside the site for more than 10 minutes (600 seconds)
////                    sendNotification()
////                    lastLocationUpdate = nil // Reset lastLocationUpdate
////                    currentSite = nil // Reset currentSite
////                }
//        } else {
//            if let lastLocation = userLocation {
//                let lastDistance = lastLocation.distance(from: siteLocation)
//                if lastDistance <= 20 { // User just left the site
//                    print("User left the site.")
//                    lastLocationUpdate = nil // Reset lastLocationUpdate if user leaves the site
//                    currentSite = nil // Reset currentSite
//                }
//            }
//        }
//    }
//}


//24.72416167840026, 46.624830333397085 king

//24.70535420335509, 46.65288084027813

//24.963831483392436, 46.70221476736078 airport


//func sendNotificationInside() {
//    print("test inside")
//
//    let content = UNMutableNotificationContent()
//    content.title = "Inside"
//    content.body = "Please check your stuff before leaving."
//    
//    if let soundURL = Bundle.main.url(forResource: "CheckEnglish", withExtension: "wav") {
//        content.sound = UNNotificationSound(named: UNNotificationSoundName(soundURL.path))
//    } else {
//        print("Sound file not found")
//    }
//
//    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//    let request = UNNotificationRequest(identifier: "SiteNotification", content: content, trigger: trigger)
//    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//}
