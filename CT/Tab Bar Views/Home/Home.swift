//
//  Home.swift
//  Countries
//
//  Created by Osman Balci on 3/20/23.
//  Modified by Kewei Zhan one 4/3/23
//  Copyright © 2023 Kewei Zhan. All rights reserved.
//
//RRR1S
import SwiftUI

fileprivate let imageNames = ["photo1", "photo2", "photo3", "photo4", "photo5", "photo6", "photo7", "photo8", "photo9"]
fileprivate let numberOfImages = 9

struct Home: View {
    
    @State private var index = 0
    /*
     Create a timer publisher that fires 'every' 3 seconds and updates the view.
     It runs 'on' the '.main' runloop so that it can update the view.
     It runs 'in' the '.common' mode so that it can run alongside other
     common events such as when the ScrollView is being scrolled.
     */
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Image("Welcome")
                    .padding()
                
                Image(imageNames[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                    .padding()
                
                // Subscribe to the timer publisher
                    .onReceive(timer) { _ in
                        index += 1
                        if index > numberOfImages - 1 {
                            index = 0
                        }
                    }
                
                Text("Powered By")
                    .font(.system(size: 18, weight: .light, design: .serif))
                    .italic()
                    .padding(.top, 30)
                    .padding(.bottom, 20)
//RRR1E
                Link(destination: URL(string: "https://www.climatiq.io")!) {
                    HStack {
                        Image("climatiqlogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                        Text("Climatiq API")
                    }
                }
                Spacer()
                Link(destination: URL(string: "https://www.eia.gov/opendata/")!) {
                    HStack {
                        Image("eialogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                        Text("Eia API")
                    }
                }
                
//RRR2S
            }   // End of VStack
            
        }   // End of ScrollView
        .onAppear() {
            startTimer()
        }
        .onDisappear() {
            stopTimer()
        }

    }   // End of body var
    
    func startTimer() {
        timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
//RRR2E
