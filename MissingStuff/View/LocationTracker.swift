//
//  LocationTracker.swift
//  MissingStuff
//
//  Created by Maryam Mohammad on 01/11/1445 AH.
//

import SwiftUI
import CoreLocation
import UserNotifications
import SwiftData

struct LocationTracker: View {
    @ObservedObject var locationManager = LocationManager()
    @Query var locationQuery: [ListModel]
    
    var body: some View {
        Text("User location: \(locationManager.userLocation?.description ?? "Unknown")")
            .onAppear {
                           // Call sortLocations() here or in a suitable place
                           locationManager.sortLocations(listQuery: locationQuery)
                       }
    }
}

#Preview {
    LocationTracker()
        
}
