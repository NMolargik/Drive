//
//  SelectableVehicle.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/5/21.
//

import SwiftUI
import TeslaSwift

struct SelectableVehicle: View {
    @Environment(\.colorScheme) var colorScheme
    @State var vehicle: Vehicle
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(colorScheme == .dark ? "card_bg_plain" : "dark_card_bg_plain")
                    .resizable()
                    .frame(width: 400, height: 170)
                    
                HStack {
                    Text(vehicle.displayName ?? "Name")
                        .font(.custom("Gotham Medium", size: 40))
                        .foregroundColor(Color("Background"))
                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    SelectableCarPhoto(options: vehicle.optionCodes?.components(separatedBy: ",") ?? [])
                        .scaleEffect(0.8)
                        .padding(.trailing, 3)
                }
            }
        }
    }
}

//struct SelectableVehicle_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectableVehicle(vehicle: Vehicle).environmentObject(TeslaComponents())
//            .previewLayout(.fixed(width: 200, height: 60))
//    }
//}
