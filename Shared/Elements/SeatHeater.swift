//
//  SeatHeater.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/9/21.
//

import SwiftUI
import TeslaSwift

struct SeatHeater: View {
    @EnvironmentObject var connection: TeslaComponents
    @Binding var level: Int
    @State var mirror: Bool
    var body: some View {
        if (!mirror) {
            ZStack {
                Image("icon_seat")
                    .renderingMode(.template)
                    .foregroundColor(Color("BackgroundInverse"))
                
                Image("seat-heater-\(level)")
                    .frame(width: 50, height: 50, alignment: .topTrailing)
            }.frame(width: 50, height: 50, alignment: .bottomLeading)
        } else {
            ZStack {
                Image("icon_seat")
                    .renderingMode(.template)
                    .foregroundColor(Color("BackgroundInverse"))
                
                Image("seat-heater-\(level)")
                    .frame(width: 50, height: 50, alignment: .topTrailing)
            }.frame(width: 50, height: 50, alignment: .bottomLeading)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
    }
}

struct SeatHeater_Previews: PreviewProvider {
    static var previews: some View {
        SeatHeater(level: .constant(2), mirror: true).environmentObject(TeslaComponents())
    }
}
