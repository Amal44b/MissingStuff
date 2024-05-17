//
//  OnBoardingPage.swift
//  MissingStuff
//
//  Created by amal on 07/11/1445 AH.
//

import SwiftUI

struct OnBoardingPage: View {
    @State  var mood: String = "Dark"
    var page : Page
    var body: some View {
        
        VStack(spacing:20){
            Image("\(page.imageUrl)")
               // .resizable()
                .scaledToFit()
                .padding(.bottom, 30)
                .cornerRadius(30)
              
              
            
                
            Text(page.description)
                .frame(width:380, height: 100)
                .padding(.bottom, 30)
                .foregroundColor(.white)
               
        }
        
       
    }
}

struct OnBoardingPage_Previews: PreviewProvider {
static var previews: some View {
    OnBoardingPage(page: .samplePage)
}
}
