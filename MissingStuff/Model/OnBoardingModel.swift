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
    Page(description: "No more forgetting your essentials again", imageUrl: "itme", tag: 0),
    Page(description: "Receive timely reminders to ensure you never leave your belongings behind", imageUrl: "itme2", tag: 1),
    Page(description: "Track your stuff easily! Select items to see what you've missed from your belongings", imageUrl: "itme3", tag: 2),]
    
}
