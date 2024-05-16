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
    
    
    public var insideCount : Int = 0
    public var timeInterval: TimeInterval = 0
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.requestLocation()
        self.locationManager.startUpdatingLocation()
       
        
        
//        self.locationManager.delegate = self
//        self.locationManager.requestAlwaysAuthorization()
//        self.locationManager.startUpdatingLocation()
        
        
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

        for site in allLocation {
            print(site)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("tessst5")
        guard let location = locations.last else { return }
        self.userLocation = location
        checkIfInsideSite(location: location)
        print("tessst6")
    }


    
    func checkIfInsideSite(location: CLLocation) {
        let currentTime = Date()
       
        
        for site in allLocation {
            let siteLocation = CLLocation(latitude: site[0], longitude: site[1])
            let distance = location.distance(from: siteLocation)
            
           
           
            
            if distance <= 3000 {
                print("inside")
                

                    print("A")

                    insideCount += 1
                    
                timeInterval = currentTime.timeIntervalSince(lastLocationUpdate ?? Date())
                    
                    print(insideCount)

            } else if (timeInterval >= 6 && insideCount >= 1) {
                           print(timeInterval)
                            print("outside")
                            print(insideCount)
                
                            sendNotificationOutside()
                            insideCount = 0
                            lastLocationUpdate = nil
                            currentSite = nil

                    }
                }
            }
   


    
    func sendNotificationOutside() {
        print("test OutSide")
        let content = UNMutableNotificationContent()
        content.title = "OutSide"
        content.body = "Check your stuff before leaving"

        if let soundURL = Bundle.main.url(forResource: "CheckE", withExtension: "wav") {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(soundURL.lastPathComponent))
        } else {
            print("Sound file not found")
        }

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }

//
//    func sendNotificationOutside() {
//           print("test OutSide")
//           let content = UNMutableNotificationContent()
//           content.title = "OutSide"
//           content.body = "Check your stuff before leaving"
//
//           if let soundURL = Bundle.main.url(forResource: "CheckE", withExtension: "wav") {
//               let soundName = UNNotificationSoundName(soundURL.lastPathComponent)
//               content.sound = UNNotificationSound(named: soundName)
//           } else {
//               print("Sound file not found")
//           }
//
//           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//           let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//           UNUserNotificationCenter.current().add(request)
//       }


}



