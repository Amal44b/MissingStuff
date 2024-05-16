//
//  OnBoardingView.swift
//  MissingStuff
//
//  Created by amal on 07/11/1445 AH.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()
    @State private var showMainPage = false
    var body: some View {
        VStack{
            NavigationStack{
                ZStack(alignment: .topTrailing) {
                    TabView(selection: $pageIndex){
                        ForEach(pages) { page in
                            VStack{
                                Spacer()
                                OnBoardingPage(page: page)
                                
                                Spacer()
                            }.tag(page.tag)
                        }
                    }
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                    // .padding()
                    .animation(.easeInOut, value: pageIndex)
                    //هذا الداتس تبع السوتش
                    .tabViewStyle(.page)
                    //.offset(x: 1.0, y: -30.0)
                    .padding(.bottom, 15)
                    .ignoresSafeArea()
                    .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                    .onAppear{
                        dotAppearance.currentPageIndicatorTintColor = .black
                        dotAppearance.pageIndicatorTintColor = .gray
                        
                    }
                    if pageIndex < 2 { // Show skip button only on the first and second image
                        /*Button("Skip", action: goToLast)*/ // Replace "Skip" with the desired text
                        //                    Button(action: {
                        //
                        //                        showMainPage = true
                        //                                    }) {
                        //                                        Text("Skip")
                        //                                    }
                        NavigationLink(destination: MainPage()) {
                            Text("Skip")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.top, 40)
                        .padding(.trailing, 20)
                    }
                    
                    
                }
                
                if pageIndex == pages.count - 1 {
                    NavigationLink(destination: MainPage()) {
                        Text("Start")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.bottom, 20)
                } else {
                    Button("Next", action: incrementPage)
                        .padding(.bottom, 20)
                }
                
                
                
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
            //                .sheet(isPresented: $showMainPage) {
            //                    MainPage()
            //                }
        }
    }
        func incrementPage(){
            pageIndex += 1
        }
        func goToLast() {
            pageIndex = pages.count - 1
        }
    
}

#Preview {
    OnBoardingView()
}
