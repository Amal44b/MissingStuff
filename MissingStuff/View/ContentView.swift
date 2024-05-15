//
//  ContentView.swift
//  MissingStuff
//
//  Created by amal on 07/11/1445 AH.
//

import SwiftUI
struct splashView: View {

    let images: [Image]
    let durationPerImage: TimeInterval
    let transitionDuration: TimeInterval
    
    @State private var currentIndex = 0
    @State private var isAnimating = false
    @State private var animationFinished = false
    @State var isActive : Bool = false
    var body: some View {
        
        VStack {
            if isActive {
                OnBoardingView()
                   .edgesIgnoringSafeArea(.all)
                    

            }
            else {
                images[currentIndex]
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .animation(.easeInOut(duration: transitionDuration))
                    .opacity(isAnimating ? 1 : 1)
            }
         
            
        }
        
        .onAppear {
            startAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation{
                    self.isActive = true
                }
            }
            
        } .onChange(of: currentIndex) { newValue in
            if newValue == images.count - 1 {
                animationFinished = true
                
            } else {
                animationFinished = false
            }
        }
        
        
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: durationPerImage + transitionDuration, repeats: true) { timer in
            currentIndex = (currentIndex + 1) % images.count
            withAnimation {
                isAnimating.toggle()
            }
            if currentIndex == images.count - 1 {
                timer.invalidate()
            }
        }
        
    }
}

struct ContentView: View {
    var body: some View {
        splashView(images: [Image("splash1"), Image("splash2"), Image("splash3"),Image("splash4")],
                   //يغيرون السرعه
                   durationPerImage: 0.2,
                   transitionDuration: 0.2)
        //يغيرون السرعه
     //   .frame(width: 300, height: 300)
        .containerRelativeFrame([.horizontal, .vertical])
        .background(Gradient(colors: [.ourGreen, .ourGreen, .ourWhite]).opacity(0.6))
        //OnBoardingView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
