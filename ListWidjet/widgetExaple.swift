////
////  widgetExaple.swift
////  MissingStuff
////
////  Created by Maryam Mohammad on 06/11/1445 AH.
////
//
//import Foundation
//import WidgetKit
//import SwiftUI
//import CoreLocation
//
//struct Provider: AppIntentTimelineProvider {
//    func placeholder(in context: Context) -> ListInWidget {
//        ListInWidget()
//    }
//
//    func getSnapshot(in context: Context , completion: @escaping (ListInWidget) -> ()) {
//        let entry = ListInWidget()
//        completion(entry)
//    }
//    
//    func getTimeline(in context: Context, completion: @escaping (Timeline<entry>) -> ()) {
//        let timeline = Timeline(entries: [ListInWidget()], policy: .atEnd)
//    }
//}
//
//struct ListInWidget: TimelineEntry {
//    let date = .now
//   
//}
//
//struct ListWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        VStack {
//           
//        }
//        .containerBackground(.fill.tertiary, for: .widget)
//    }
//}
//
//struct ListWidget: Widget {
//    let kind: String = "ListWidjet"
//
//    var body: some WidgetConfiguration {
//       StaticConfiguration(kind: kind, provider: Provider()){ entry in
//           ListWidgetEntryView(entry: entry)
//       }
//       .configurationDisplayName("My Widget")
//       .description("Example Widget")
//    }
//}
//
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
//    ListInWidget()
//}



//import WidgetKit
//import SwiftUI
//import CoreLocation
//import SwiftData
////import SharedModule
//
//struct Provider: AppIntentTimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date()/*, configuration: ConfigurationAppIntent()*/)
//    }
//
//    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
//        SimpleEntry(date: Date()/*, configuration: configuration*/)
//    }
//    
//    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
//        var entries: [SimpleEntry] = []
//        
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate/*, configuration: configuration*/)
//            entries.append(entry)
//        }
//
//        return Timeline(entries: entries, policy: .atEnd)
//    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//   
//  //  let configuration: ConfigurationAppIntent
//}
//
//struct ListWidjetEntryView : View {
//    @ObservedObject var locationManager = LocationManager()
//    @Query var WidgetList: [ListModel]
//    
//    @State var BasedOnLocation : [ListModel] = []
//    
//    @State var isCompleted:[String: Bool] = [:]
//    
//    var completedItemCount: Int {
//        
//        return isCompleted.reduce(0) { $1.value ? $0 + 1 : $0 }
//    }
//    
//    
//    var entry: Provider.Entry
//    
//    
//    
//    var body: some View {
//        VStack {
//            List {
//                ForEach(BasedOnLocation, id: \.self) { item in
//                    ForEach(item.items , id: \.self){ listItem in
//                        HStack {
//                            
//                            Button(action: {
//                                self.isCompleted[listItem, default: false].toggle()
//                                
//                                //                        if self.completedItemCount == self.BasedOnLocation.items.count {
//                                //                            Text("All items completed")
//                                //                        }
//                            }) {
//                                Image(systemName: self.isCompleted[listItem, default: false] ? "checkmark.circle.fill" : "circle")
//                                    .frame(width: 30 , height: 30)
//                                    .foregroundColor(self.isCompleted[listItem, default: false] ? .ourGreen : .gray)
//                            }
//                            Text(listItem)
//                        }
//                    }
//                }
//            }
//            
//            
//        }.onAppear(){
//            guard let userLocation = locationManager.userLocation else {
//                return // Exit early if userLocation is nil
//            }
//            checkUserLocation(location:userLocation)
//        }
//        
//        
//    }
//    
//    
//    func checkUserLocation(location: CLLocation) {
//       
//        
//        for list in WidgetList {
//            let listLocation = CLLocation(latitude: list.latitude, longitude: list.longitude) // Assuming ListModel has latitude and longitude properties
//            let distance = location.distance(from: listLocation)
//            
//            if distance <= 100 {
//                BasedOnLocation.append(list)
//            }
//        }
//    }
//    
//}
//
//struct ListWidjet: Widget {
//    let kind: String = "ListWidjet"
//
//    var body: some WidgetConfiguration {
//        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
//            ListWidjetEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
////                .modelContainer(for: ListModel.self)
//        }
//    }
//}
//
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
//    SimpleEntry(date: .now/*, configuration: .smiley)*/)
////    SimpleEntry(date: .now, configuration: .starEyes)
//}


