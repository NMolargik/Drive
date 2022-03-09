//
//  ClimateShop.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/12/21.
//

import SwiftUI
import TeslaSwift

struct ClimateShop: View {
    @EnvironmentObject var connection: TeslaComponents
    var body: some View {
        ZStack {
            BodyShop().environmentObject(connection)
                .scaleEffect(2.5)
            
            Image("M3-climate-interior").environmentObject(connection)
                .scaleEffect(x: 1.3, y: 1.2)
                .offset(y: 40)
        }
    }
}

struct ClimateShop_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background")
            
            ClimateShop().environmentObject(TeslaComponents())
        }
    }
}
