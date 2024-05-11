//
//  CheckList.swift
//  MissingStuff
//
//  Created by Maryam Mohammad on 20/10/1445 AH.
//

import SwiftUI
import SwiftData

struct CheckList: View {
    @State var isCompleted:[String: Bool] = [:]
    var listCheck: ListModel
    var completedItemCount: Int {
        // استخدم reduce لحساب العدد
        return isCompleted.reduce(0) { $1.value ? $0 + 1 : $0 }
    }
    @State private var showCompletionAlert = false
    @State private var navLinkActive = false
    @Environment(\.presentationMode) var presentationMode
    @State private var alertTitle = "All items completed"
    var body: some View {
            ZStack{

//                Color.darkGray.ignoresSafeArea()

                VStack/*(alignment: .leading)*/{
                    
                   
                    
                    List {
                        ForEach(listCheck.items, id: \.self) { item in
                            HStack {
                                Button(action: {
                                    self.isCompleted[item, default: false].toggle()
                                    // هنا يمكنك تغيير حالة الانتهاء لهذا العنصر في القائمة
                                    // يمكنك استخدام حلقة ForEach مع index لتحديد العنصر الذي تم النقر عليه
                                    if self.completedItemCount == self.listCheck.items.count {
                                        self.showCompletionAlert = true
                                    }
                                }) {
                                    Image(systemName: self.isCompleted[item, default: false] ? "checkmark.circle.fill" : "circle")
                                        .frame(width: 30 , height: 30)
                                        .foregroundColor(self.isCompleted[item, default: false] ? .ourGreen : .gray)
                                }
                                Text(item)
                            }
//                            .listRowBackground(Color.darkGray)
                        
                        }
                    }.listStyle(PlainListStyle())
                       
                    Text("\(completedItemCount)/\(listCheck.items.count) items") // النص الذي يوضح عدد العناصر المنتهية
                        .frame(alignment: .center)
                        .font(.system(size: 20))
                }
            }
            .navigationTitle(listCheck.name)
                                .navigationBarTitleDisplayMode(.inline)
                .alert(isPresented: $showCompletionAlert) {
                    Alert(title: Text("All items completed") , dismissButton: Alert.Button.default(Text("OK"), action: {
                        presentationMode.wrappedValue.dismiss()
                    }))
                }

        }
    }

struct CheckList_Previews: PreviewProvider {
    static var previews: some View {
        let items = ["Item 1", "Item 2", "Item 3"]
        let listModel = ListModel(name: "List", items: items, latitude: 0.0 , longitude: 0.0 , isCompleted: false)
        return CheckList(listCheck: listModel)
    }
}
