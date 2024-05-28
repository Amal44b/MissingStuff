//
//  OnBoardingModel.swift
//  MissingStuff
//
//  Created by amal on 07/11/1445 AH.
//

import Foundation
struct Page: Identifiable, Equatable {
    let id = UUID()
    var description: String
    var imageUrl : String
    var tag: Int
    
    static var samplePage = Page(description: "test", imageUrl: "itme", tag: 0)
    
    static var samplePages : [Page] = [
    Page(description: NSLocalizedString("No more forgetting your essentials again", comment: ""), imageUrl: "itme", tag: 0),
    Page(description: NSLocalizedString("Receive timely reminders to ensure you never leave your belongings behind", comment: ""), imageUrl: "itme2", tag: 1),
    Page(description: NSLocalizedString("Track your stuff easily! Select items to see what you've missed from your belongings", comment: ""), imageUrl: "itme3", tag: 2),]
    
}
