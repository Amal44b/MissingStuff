//
//  ListWidjet.swift
//  ListWidjet
//
//  Created by Maryam Mohammad on 06/11/1445 AH.
//

import WidgetKit
import SwiftUI
import CoreLocation
import SwiftData
import AppIntents
import UserNotifications


struct Provider: AppIntentTimelineProvider {
    @ObservedObject var locationManager = LocationManager()
    @Query var WidgetList: [ListModel]
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent() , lat: locationManager.userLocation?.coordinate.latitude ?? 00 , long: locationManager.userLocation?.coordinate.longitude ?? 00)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration , lat: locationManager.userLocation?.coordinate.latitude ?? 00 , long: locationManager.userLocation?.coordinate.longitude ?? 00)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        print("in timeline!!!!!!")

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration , lat: locationManager.userLocation?.coordinate.latitude ?? 00 , long: locationManager.userLocation?.coordinate.longitude ?? 00)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let lat : Double
    let long : Double

}

struct ListWidjetEntryView : View {
    var entry: Provider.Entry
    @ObservedObject var locationManager = LocationManager()
    @Query var WidgetList: [ListModel]
    @Environment(\.modelContext) var modelContext
//    @Query(checkDescriptor, animation: .snappy)  var WidgetList: [ListModel]
    
    @State var BasedOnLocation : [ListModel] = []
    
    @State var isCompleted:[String: Bool] = [:]
    var completedItemCount: Int {
        
        return isCompleted.reduce(0) { $1.value ? $0 + 1 : $0 }
    }
    
    @State var hiddenItems: Set<String> = []
    
    var listName: String = ""
    var itemsCount: Int = 0
    
    
    var body: some View {
      
            HStack{
                VStack{
                Image("Logo").resizable()
                    .frame(width: 50, height: 80)
                if let firstList = BasedOnLocation.first {
                    Text(firstList.name)
                        .font(.headline)
                    Text("\(firstList.items.count) items")
                        .font(.subheadline)
                } 
                }.padding(.trailing, 15)
                
               
                    
//                    Text("\(completedItemCount)")
//                        
//                    
//                }
                // Text("User location: \(locationManager.userLocation?.description ?? "Unknown")")
                
                
                //            Text("User location: \(entry.lat ?? 0.0)")
                //            Text("User location: \(entry.long ?? 0.0)")
                
                
                
                
                VStack{
                    
                    if BasedOnLocation.isEmpty {
                        Text("No items available")
                    } else {
                        
                        
                        ForEach(BasedOnLocation) { item in
                           
                            
                            ForEach(item.items.prefix(3) , id: \.self){ listItem in
                                VStack(alignment: .leading){
                                    HStack {
                                       
                                        Image(systemName:"circle")
                                       
                                        Text(listItem)
                                            .font(.callout)
                                            .lineLimit(1)
                                    }.onTapGesture(){
                                        hideItem(listItem)
                                    }
                                    
                                    
                                    Divider()
                                }
                                .transition(.push(from: .bottom))
                              
                            }
                        }
                        
                       
                    }
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
                
                
                
                
            
            }.onAppear(){
                //            guard let userLocation = locationManager.userLocation else {
                //                return
                //            }
                
                
                let coordinate : CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude: entry.lat, longitude: entry.long)
                
                var location : CLLocation =  CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                
                locationManager.userLocation = location
                
                let newUserLocation = locationManager.userLocation
                
                print(newUserLocation)
                
                checkUserLocation(location:newUserLocation ?? CLLocation(latitude: 0, longitude: 0))
                
            }
            .background(Image("widgetColor").opacity(0.5))
        }
        
        
    static var checkDescriptor: FetchDescriptor<ListModel> {
        let predicate = #Predicate<ListModel> {!$0.isCompleted}
        let sort = [SortDescriptor(\ListModel.name,order: .reverse )]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 3
        return descriptor
    }
        
        
     func checkUserLocation(location: CLLocation) {
            print(location)
//          var insideCount : Int = 0
         print("insidewidget")
            for list in WidgetList {
                let listLocation = CLLocation(latitude: list.latitude, longitude: list.longitude)
                let distance = location.distance(from: listLocation)
                
                
                
                if distance <= 100 {
                    print("InSideInDise")
                    BasedOnLocation.append(list)
                }
//                    insideCount += 1
//                    print(insideCount)
//                    print("inside")
//                } else if (insideCount >= 1) {
//                   
//                     print("outsideW")
//                     print(insideCount)
//         
//                    locationManager.sendNotificationOutside()
//                     
//                     insideCount = 0
//                    
//
//             }
            }
            
        }
    func hideItem(_ item: String) {
         hiddenItems.insert(item)
     }


}

struct ListWidjet: Widget {
    let kind: String = "ListWidjet"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ListWidjetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: ListModel.self)
                
        }
        .supportedFamilies([.systemMedium])
    }
}

//extension ConfigurationAppIntent {
//    fileprivate static var smiley: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
//        return intent
//    }
//    
//    fileprivate static var starEyes: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
//        return intent
//    }
//}
//
//#Preview(as: .systemSmall) {
//    ListWidjet()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}


struct ToggleButton: AppIntent {
   static var title: LocalizedStringResource = .init(stringLiteral: "Toggle's CheckList State")

   @Parameter(title: "Check ID")
   var id: String

   init() {

   }

   init(id: String) {
       self.id = id
   }

   func perform() async throws -> some IntentResult {
       let context = try ModelContext(.init(for: ListModel.self))
       let descriptor = FetchDescriptor(predicate: #Predicate<ListModel> {$0.CheckID == id })
       if let list = try context.fetch(descriptor).first {
           list.isCompleted = !list.isCompleted
           
           try context.save()
       }



       return .result()
   }

}
