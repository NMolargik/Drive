//
//  ClimateSplash.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/6/21.
//

import SwiftUI
import TeslaSwift
import CoreHaptics

struct ClimateSplash: View {
    @EnvironmentObject var connection: TeslaComponents
    @State var driverLevel = HeatLevel.off
    @State var passengerLevel = HeatLevel.off
    @State var rearDriverLevel = HeatLevel.off
    @State var rearMiddleLevel = HeatLevel.off
    @State var rearPassengerLevel = HeatLevel.off
    @State var thirdDriverLevel = HeatLevel.off
    @State var thirdPassengerLevel = HeatLevel.off
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            
            Image("M3-climate-interior")
                .scaleEffect(2.5)
            
            VStack {
                Spacer(minLength: 250)
                
                HStack {
                    Spacer()
                    
                    StandaloneHeater(level: $driverLevel)
                        .onTapGesture(perform: {
                            switch (driverLevel) {
                            case .off: driverLevel = .low
                            case .low: driverLevel = .mid
                            case .mid: driverLevel = .high
                            case .high: driverLevel = .off
                            }
                            
                            connection.sendCommand(command: .setSeatHeater(seat: .driver, level: driverLevel), completion: {
                                connection.busy = false
                            })
                        })
                        .scaleEffect(2.5)
                    
                    Spacer(minLength: 220)
                    
                    StandaloneHeater(level: $passengerLevel)
                        .onTapGesture(perform: {
                            switch (passengerLevel) {
                            case .off: passengerLevel = .low
                            case .low: passengerLevel = .mid
                            case .mid: passengerLevel = .high
                            case .high: passengerLevel = .off
                            }
                            
                            connection.sendCommand(command: .setSeatHeater(seat: .passenger, level: passengerLevel), completion: {
                                connection.busy = false
                            })
                        })
                        .scaleEffect(2.5)
                    
                    Spacer()
                }
                
                Spacer(minLength: 280)
                
                
                //Row 2
                HStack {
                    Spacer()
                    
                    StandaloneHeater(level: $rearDriverLevel)
                        .onTapGesture(perform: {
                            switch (driverLevel) {
                            case .off: rearDriverLevel = .low
                            case .low: rearDriverLevel = .mid
                            case .mid: rearDriverLevel = .high
                            case .high: rearDriverLevel = .off
                            }
                            
                            connection.sendCommand(command: .setSeatHeater(seat: .rearLeft, level: rearDriverLevel), completion: {
                                connection.busy = false
                            })
                        })
                        .scaleEffect(2.5)
                    
                    Spacer()
                    
                    StandaloneHeater(level: $rearMiddleLevel)
                        .onTapGesture(perform: {
                            switch (rearMiddleLevel) {
                            case .off: rearMiddleLevel = .low
                            case .low: rearMiddleLevel = .mid
                            case .mid: rearMiddleLevel = .high
                            case .high: rearMiddleLevel = .off
                            }
                            
                            connection.sendCommand(command: .setSeatHeater(seat: .rearCenter, level: rearMiddleLevel), completion: {
                                connection.busy = false
                            })
                        })
                        .scaleEffect(2.5)
                    
                    Spacer()
                    
                    StandaloneHeater(level: $rearPassengerLevel)
                        .onTapGesture(perform: {
                            switch (rearPassengerLevel) {
                            case .off: rearPassengerLevel = .low
                            case .low: rearPassengerLevel = .mid
                            case .mid: rearPassengerLevel = .high
                            case .high: rearPassengerLevel = .off
                            }
                            
                            connection.sendCommand(command: .setSeatHeater(seat: .rearRight, level: rearPassengerLevel), completion: {
                                connection.busy = false
                            })
                        })
                        .scaleEffect(2.5)
                    
                    Spacer()
                }
                
                Spacer()
                
                Temperature().environmentObject(connection)
                    .padding()
            }
            .padding(.bottom, 40)
        }
    }
}

struct ClimateSplash_Previews: PreviewProvider {
    static var previews: some View {
        ClimateSplash().preferredColorScheme(.dark).environmentObject(TeslaComponents())
    }
}
