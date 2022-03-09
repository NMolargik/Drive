//
//  TrunkButton.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/7/21.
//

import SwiftUI
import TeslaSwift
import CoreHaptics

struct TrunkButton: View {
    @EnvironmentObject var connection: TeslaComponents
    @State var text: String
    @State var line: String
    @State var subtext: String
    @State var trunk: String
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            Button(action: {
                //Ignore
            }, label: {
                if (line == "left") {
                    HStack (){
                        VStack {
                            Text("")
                                .foregroundColor(.gray)
                                .font(.footnote)
                            Rectangle()
                                .frame(width: 40, height: 2)
                                .foregroundColor(.gray)
                        }
                        
                        VStack (alignment: .leading) {
                            Text(subtext)
                                .foregroundColor(.gray)
                                .font(.custom("Gotham Medium", size: 15))
                                

                            
                            Text(text)
                                .foregroundColor(Color("BackgroundInverse"))
                                .font(.custom("Gotham Medium", size: 20))
                                .bold()
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
                
                if (line == "right") {
                    HStack {
                        VStack (alignment: .trailing){
                            Text(subtext)
                                .foregroundColor(.gray)
                                .font(.custom("Gotham Medium", size: 15))
                            
                            Text(text)
                                .foregroundColor(Color("BackgroundInverse"))
                                .font(.custom("Gotham Medium", size: 20))
                                .bold()
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            
                        }
                        
                        VStack {
                            Text("")
                                .foregroundColor(.gray)
                                .font(.footnote)

                            Rectangle()
                                .frame(width: 40, height: 2)
                                .foregroundColor(.gray)
                        }
                    }
                }
            })
            .simultaneousGesture(LongPressGesture().onEnded() { _ in
                print("Long Pressed")
                generator.notificationOccurred(.success)
                if (trunk == "front") {
                    connection.sendCommand(command: .openTrunk(options: .front), completion: {
                        print("Command Sent")
                        connection.busy = false
                    })
                } else if (trunk == "rear") {
                    connection.sendCommand(command: .openTrunk(options: .rear), completion: {
                        print("Command Sent")
                        connection.busy = false
                    })
                } else {
                    if (connection.chosenCar?.chargeState?.chargePortDoorOpen ?? true) {
                        connection.sendCommand(command: .closeChargeDoor, completion: {
                            print("Command Sent")
                            connection.busy = false
                        })
                    } else {
                        connection.sendCommand(command: .openChargeDoor, completion: {
                            print("Command Sent")
                            connection.busy = false
                        })
                    }
                }
            })
            .simultaneousGesture(TapGesture().onEnded() { _ in
                print("Tapped")
            })
        }
    }
}

struct LockButton: View {
    @EnvironmentObject var connection: TeslaComponents
    @State var line: String
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        Button(action: {
            //Ignore
        }, label: {
            HStack {
                VStack {
                    if (connection.chosenCar?.vehicleState?.locked ?? true) {
                        Image("locked")
                            .renderingMode(.template)
                            .foregroundColor(Color("BackgroundInverse"))
                            .scaleEffect(1.5)
                            .shadow(radius: 7)
                    } else {
                        Image("unlocked")
                            .renderingMode(.template)
                            .foregroundColor(Color("BackgroundInverse"))
                            .scaleEffect(1.5)
                            .shadow(radius: 7)
                    }
                }.offset(y: 4)
                
                VStack {
                    Text("")
                        .foregroundColor(.gray)
                        .font(.footnote)

                    Rectangle()
                        .frame(width: 40, height: 2)
                        .foregroundColor(.gray)
                }
            }
        })
        .simultaneousGesture(LongPressGesture().onEnded() { _ in
            print("Long Pressed")
            generator.notificationOccurred(.success)
            connection.sendCommand(command: (connection.chosenCar?.vehicleState?.locked ?? true) ? .unlockDoors : .lockDoors, completion: {
                connection.busy = false
            })
        })
        .simultaneousGesture(TapGesture().onEnded() { _ in
            print("Tapped")
        })
    }
}

struct PortButton: View {
    @EnvironmentObject var connection: TeslaComponents
    @State var line: String
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            if (connection.chosenCar?.chargeState?.chargingState ?? .disconnected != .disconnected) {
            //Green Lightning Bolt
                HStack {
                    Image("icon_charging")
                        .renderingMode(.template)
                        .foregroundColor((connection.chosenCar?.chargeState?.chargingState ?? .stopped == .stopped ? .gray : .green))
                    
                    if (line == "left") {
                        VStack {
                            Text("")
                                .foregroundColor(.gray)
                                .font(.footnote)
                            Rectangle()
                                .frame(width: 40, height: 2)
                                .foregroundColor(.gray)
                        }
                    } else {
                        VStack {
                            Rectangle()
                                .frame(width: 40, height: 2)
                                .foregroundColor(.gray)
                            
                            Text("")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                    }
                }.onTapGesture {
                    generator.notificationOccurred(.success)
                    connection.selectedTab = 3
                }
            } else {
                Button(action: {
                    //Ignore
                }, label: {
                    if (line == "left") {
                        HStack (){
                            VStack {
                                Text("")
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                                Rectangle()
                                    .frame(width: 40, height: 2)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack (alignment: .leading) {
                                Text("PORT")
                                    .foregroundColor(.gray)
                                    .font(.custom("Gotham Medium", size: 15))
                                    

                                
                                Text("OPEN")
                                    .foregroundColor(Color("BackgroundInverse"))
                                    .font(.custom("Gotham Medium", size: 20))
                                    .bold()
                                    .shadow(radius: 10)
                            }
                        }
                    }
                    
                    if (line == "right") {
                        HStack {
                            VStack (alignment: .trailing) {
                                Text("PORT")
                                    .foregroundColor(.gray)
                                    .font(.custom("Gotham Medium", size: 15))
                                    

                                
                                Text("OPEN")
                                    .foregroundColor(Color("BackgroundInverse"))
                                    .font(.custom("Gotham Medium", size: 20))
                                    .bold()
                                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            }
                            
                            VStack {
                                Text("")
                                    .foregroundColor(.gray)
                                    .font(.footnote)

                                Rectangle()
                                    .frame(width: 40, height: 2)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                })
            }
        }
    }
}

struct SpecialButtons_Previews: PreviewProvider {
    static var previews: some View {
        //TrunkButton(text: "OPEN", line: "right", subtext: "Frunk", trunk: "front").environmentObject(TeslaComponents())
        
        PortButton(line: "left").environmentObject(TeslaComponents())
    }
}
