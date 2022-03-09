//
//  ChargingSplash.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/6/21.
//

import SwiftUI
import TeslaSwift

struct ChargingSplash: View {
    @EnvironmentObject var connection: TeslaComponents
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack (alignment: .leading){
                    Image("3_car_pinwheel18")
                        .animation(Animation.easeInOut)
                    Rectangle()
                        
                        .foregroundColor(.pink)
                        .frame(width: 1200 * CGFloat(connection.chosenCar?.chargeState?.batteryLevel ?? 80) / 100, height: 100)
                        .mask(Image("3_battery_mask"))
                        .offset(x: 145, y: -42)
                }
                
                Spacer()
            }
            .padding(.top, 62)
        }
    }
}

struct ChargingSplash_Previews: PreviewProvider {
    static var previews: some View {
        ChargingSplash().preferredColorScheme(.dark).environmentObject(TeslaComponents())
    }
}
