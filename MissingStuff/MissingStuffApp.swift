//
//  MissingStuffApp.swift
//  MissingStuff
//
//  Created by amal on 12/10/1445 AH.
//

import SwiftUI

@main
struct MissingStuffApp: App {
    var body: some Scene {
        WindowGroup {
            MainPage()
        }
        .modelContainer(for: ListModel.self)
    }
}
