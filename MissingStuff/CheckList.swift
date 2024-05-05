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
    
    var body: some View {
        ZStack{
//            Color.darkGray.ignoresSafeArea()
            VStack/*(alignment: .leading)*/{
               
                Text(listCheck.name)
                    .frame(alignment: .center)
                    .font(.title)
                
                List {
                    ForEach(listCheck.items, id: \.self) { item in
                        HStack {
                            
                            
                            Button(action: {
                                self.isCompleted[item, default: false].toggle()
                                // هنا يمكنك تغيير حالة الانتهاء لهذا العنصر في القائمة
                                // يمكنك استخدام حلقة ForEach مع index لتحديد العنصر الذي تم النقر عليه
                            }) {
                                Image(systemName: self.isCompleted[item, default: false] ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(self.isCompleted[item, default: false] ? .green : .gray)
                            }
                            Text(item)
                        }
                    }
                }.listStyle(PlainListStyle())
                
            }
        }
    }
}

struct CheckList_Previews: PreviewProvider {
    static var previews: some View {
        let items = ["Item 1", "Item 2", "Item 3"]
        let listModel = ListModel(name: "List", items: items, location: "Location", subLocation: "SubLocation", isCompleted: false)
        return CheckList(listCheck: listModel)
    }
}
