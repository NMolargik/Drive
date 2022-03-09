//
//  VehicleSplash.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/6/21.
//

import SwiftUI
import TeslaSwift

struct VehicleSplash: View {
    @EnvironmentObject var connection: TeslaComponents
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer(minLength: 62)
                    
                    HStack {
                        Text(connection.chosenCar?.displayName ?? "Name")
                            .font(.custom("Gotham Medium", size: 30))
                            .foregroundColor(Color("BackgroundInverse"))
                            .shadow(radius: 10)
                    }
                    
                    Spacer()
                        
                    ZStack {
                        BodyShop().environmentObject(connection)

                        TrunkButton(text: (connection.chosenCar?.vehicleState?.frontTrunkOpen ?? false && connection.chosenCar?.vehicleConfig?.canActuateTrunks ?? false) ? "CLOSE" : "OPEN", line: "left", subtext: "FRUNK", trunk: "front").environmentObject(connection)
                            .offset(x: 130, y: -150)
                        
                        LockButton(line: "right").environmentObject(connection)
                            .offset(x: -130, y: -150)
                        
                        TrunkButton(text: (connection.chosenCar?.vehicleState?.frontTrunkOpen ?? false && connection.chosenCar?.vehicleConfig?.canActuateTrunks ?? false) ? "CLOSE" : "OPEN", line: "left", subtext: "TRUNK", trunk: "rear").environmentObject(connection)
                            .offset(x: 130, y: 100)
                        
                        PortButton(line: "right").environmentObject(connection)
                            .offset(x: -130, y: 100)
                    }
                    .aspectRatio(contentMode: .fill)
                    .scaledToFill()
                    .frame(width: geometry.size.width)
                    
                    Spacer()
                    
                    HStack {
                        Text("\(Int(connection.chosenCar?.chargeState?.estimatedBatteryRange?.miles ?? 70)) miles")
                            .padding()
                            .foregroundColor(.gray)
                            .frame(width: 150, alignment: .trailing)
                        
                        SmallBatteries().environmentObject(connection)
                            .onTapGesture {
                                connection.selectedTab = 3;
                            }
                        
                        Text("\(Int(connection.chosenCar?.chargeState?.batteryLevel ?? 70)) %")
                            .padding()
                            .foregroundColor(.gray)
                            .frame(width: 150, alignment: .leading)
                    }
                    
                    Spacer()
                    
                    CardCarousel(card2Offset: CGSize(), card1Offset: CGSize(), card3Offset: CGSize()).environmentObject(connection)
                    
                    Spacer(minLength: 40)
                    
                }
            }.frame(width: geometry.size.width)
        }
    }
}

struct VehicleSplash_Previews: PreviewProvider {
    static var previews: some View {
        VehicleSplash().preferredColorScheme(.light).environmentObject(TeslaComponents())
    }
}
