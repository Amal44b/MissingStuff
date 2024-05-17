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
    @State private var navigateToMainPage = false
    //@Binding var isFirstLaunch: Bool
    var body: some View {
        ZStack{
            Image("OnBoardingColor")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
            
            
            VStack{
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
                    if pageIndex < 2 {
                        Button("Skip", action: {
                            navigateToMainPage = true // Set the state variable to true
                        })
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.top, 40)
                        .padding(.trailing, 20)
                        .foregroundColor(.ourGreen2)
                        .fullScreenCover(isPresented: $navigateToMainPage) {
                            MainPage()
                        }
                    }
                }
                
                if pageIndex == pages.count - 1 {
                    Button("Start", action: {
                        navigateToMainPage = true // Set the state variable to true
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    //.padding(.bottom, 20)
                    .padding(.horizontal, 150)
                    
                    .padding(.vertical, 14)
                    .foregroundColor(.white)
                    .background(.ourGreen2)
                    .cornerRadius(10)
                    .padding(.bottom,35)
                    .fullScreenCover(isPresented: $navigateToMainPage) {
                        MainPage()
                    }
                } else {
                    Button("Next", action: incrementPage)
                    //.padding(.bottom, 20)
                    // .padding()
                        .padding(.horizontal, 150)
                        .frame(height: 50)
                        //.padding(.vertical, 14)
                        .foregroundColor(.white)
                        .background(.ourGreen2)
                        .cornerRadius(10)
                        .padding(.bottom,35)
                    
                    
                    
                }
                
                
            } }
        .onAppear(perform: {
            UserDefaults.standard.welcomeScreenShown = true
        })
    }
    func incrementPage(){
        pageIndex += 1
    }
    func goToZero() {
        pageIndex = 0
    }
    func goToLast() {
            pageIndex = pages.count - 1
        }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
