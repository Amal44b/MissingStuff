//
//  OnBoardingPage.swift
//  MissingStuff
//
//  Created by amal on 07/11/1445 AH.
//

import SwiftUI

struct OnBoardingPage: View {
    var page : Page
    var body: some View {
        VStack(spacing:20){
            Image("\(page.imageUrl)")
               // .resizable()
                .scaledToFit()
                .padding(.bottom, 30)
                .cornerRadius(30)
                //.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
              //  .offset(x: 1.0, y: -77.0)
              //  .background(.gray.opacity(0.10))
               // .cornerRadius(10)
              
              
            
                
            Text(page.description)
              //  .offset(x: 1.0, y: -60.0)
                .frame(width:380, height: 100)
                .padding(.bottom, 30)
               
        }
        
       
    }
}

struct OnBoardingPage_Previews: PreviewProvider {
static var previews: some View {
    OnBoardingPage(page: .samplePage)
}
}
