//
//  Batteries.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/9/21.
//

import SwiftUI

struct SmallBatteries: View {
    @EnvironmentObject var connection: TeslaComponents
    var body: some View {
        ZStack (alignment: .leading){
            Rectangle()
                .foregroundColor(.green)
                .frame(width: 35 * CGFloat(connection.chosenCar?.chargeState?.batteryLevel ?? 80) / 100, height: 15, alignment: .leading)
            
            Image("small_battery")
                .renderingMode(.template)
                .foregroundColor(Color("BackgroundInverse"))
                .onTapGesture {
                    connection.selectedTab = 3;
                }
        }
    }
}

struct LargeBatteries: View {
    @EnvironmentObject var connection: TeslaComponents
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Batteries_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SmallBatteries().environmentObject(TeslaComponents())
            
            
            LargeBatteries().environmentObject(TeslaComponents())
        }
    }
}
