//
//  CardCarousel.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/9/21.
//

import SwiftUI
import TeslaSwift
import CoreHaptics

struct CardCarousel: View {
    @EnvironmentObject var connection: TeslaComponents
    @State private var activeCard = 2
    @State var card2Offset: CGSize
    @State var card1Offset: CGSize
    @State var card3Offset: CGSize
    
    var body: some View {
        VStack {
            switch (activeCard) {
            case 1:
                CardLeft(activeCard: $activeCard, offset: $card1Offset).environmentObject(connection)
                    .transition(AnyTransition.slide)
                    .animation(.default)
                    .onDisappear {
                        card1Offset = .zero
                    }
                
            case 2:
                if (connection.chosenCar?.vehicleState?.isUserPresent ?? false) {
                    CardAlternate(activeCard: $activeCard, offset: $card2Offset).environmentObject(connection)
                        .transition(AnyTransition.asymmetric(insertion: (card3Offset.width != 0) ? AnyTransition.move(edge: .leading) : AnyTransition.move(edge: .trailing), removal: (card2Offset.width > 0) ? AnyTransition.move(edge: .trailing) : AnyTransition.move(edge: .leading)))
                        .animation(.default)
                        .onDisappear {
                            card2Offset = .zero
                        }
                } else {
                    CardMain(activeCard: $activeCard, offset: $card2Offset).environmentObject(connection)
                        .transition(AnyTransition.asymmetric(insertion: (card3Offset.width != 0) ? AnyTransition.move(edge: .leading) : AnyTransition.move(edge: .trailing), removal: (card2Offset.width > 0) ? AnyTransition.move(edge: .trailing) : AnyTransition.move(edge: .leading)))
                        .animation(.default)
                        .onDisappear {
                            card2Offset = .zero
                        }
                }
            
            case 3:
                CardRight(activeCard: $activeCard, offset: $card3Offset).environmentObject(connection)
                    .transition(AnyTransition.asymmetric(insertion: AnyTransition.move(edge: .trailing), removal: AnyTransition.slide))
                    .animation(.default)
                    .onDisappear {
                        card3Offset = .zero
                    }
                
            default:
                CardMain(activeCard: $activeCard, offset: $card1Offset).environmentObject(connection)
                    .transition(AnyTransition.slide)
                    .animation(.default)
            }
            
            //Dots
            HStack (alignment: .center){
                Text(".")
                    .bold()
                    .scaleEffect(2)
                    .foregroundColor(activeCard == 1 ? Color("BackgroundInverse") : .gray)
                    .animation(.default)
                
                Text(".")
                    .bold()
                    .scaleEffect(2)
                    .foregroundColor(activeCard == 2 ? Color("BackgroundInverse") : .gray)
                    .animation(.default)
                
                Text(".")
                    .bold()
                    .scaleEffect(2)
                    .foregroundColor(activeCard == 3 ? Color("BackgroundInverse") : .gray)
                    .animation(.default)
            }.offset(x: 0, y: -25)
            
        }
    }
}

struct CardMain: View {
    @EnvironmentObject var connection: TeslaComponents
    @Environment(\.colorScheme) var colorScheme
    @Binding var activeCard: Int
    @Binding var offset: CGSize
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        
        //Flash, Remote Start, Honk
        
        
        ZStack {
            Image(colorScheme == .dark ? "dark_card_bg_plain" : "card_bg_plain")
                .resizable()
                .frame(width: 400, height: 170)
            
            VStack {
                HStack {
                    Button (action: {
                        generator.notificationOccurred(.success)
                        connection.sendCommand(command: .flashLights, completion: {
                            connection.busy = false
                        })
                    }, label: {
                        VStack {
                            Text("FLASH")
                                .font(.custom("Gotham Medium", size: 15))
                                .foregroundColor(.gray)
                            
                            Image("controls-flash-icon")
                                .renderingMode(.template)
                                .foregroundColor(Color("BackgroundInverse"))
                                .scaleEffect(1.5)
                                .shadow(radius: 5)
                                .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offset = gesture.translation
                                }

                                .onEnded { _ in
                                    if (self.offset.width) > 100 {
                                        activeCard = 1
                                    } else if (self.offset.width) < 100 {
                                        activeCard = 3
                                    }
                                    else {
                                        self.offset.width = 0
                                    }
                                }
                        )
                    })
                    
                    Spacer()
                    
                    Button (action: {
                        generator.notificationOccurred(.success)
                        connection.sendCommand(command: (connection.chosenCar?.vehicleState?.driverWindowOpen ?? false || connection.chosenCar?.vehicleState?.passengerWindowOpen ?? false || connection.chosenCar?.vehicleState?.driverRearDoorOpen ?? false || connection.chosenCar?.vehicleState?.passengerRearWindowOpen ?? false) ? .windowControl(state: .close) : .windowControl(state: .vent), completion: {
                            connection.busy = false
                        })
                    }, label: {
                        VStack {
                            Text((connection.chosenCar?.vehicleState?.driverWindowOpen ?? false || connection.chosenCar?.vehicleState?.passengerWindowOpen ?? false || connection.chosenCar?.vehicleState?.driverRearDoorOpen ?? false || connection.chosenCar?.vehicleState?.passengerRearWindowOpen ?? false) ?
                                "CLOSE" : "VENT")
                                .font(.custom("Gotham Medium", size: 15))
                                .foregroundColor(.gray)
                            
                            Image((connection.chosenCar?.vehicleState?.driverWindowOpen ?? false || connection.chosenCar?.vehicleState?.passengerWindowOpen ?? false || connection.chosenCar?.vehicleState?.driverRearDoorOpen ?? false || connection.chosenCar?.vehicleState?.passengerRearWindowOpen ?? false) ? "window-vent" : "window-close")
                                .renderingMode(.template)
                                .foregroundColor(Color("BackgroundInverse"))
                                .scaleEffect(1.5)
                                .shadow(radius: 5)
                                .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }.gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offset = gesture.translation
                                }

                                .onEnded { _ in
                                    if (self.offset.width) > 100 {
                                        activeCard = 1
                                    } else if (self.offset.width) < 100 {
                                        activeCard = 3
                                    }
                                    else {
                                        self.offset.width = 0
                                    }
                                }
                        )
                    })
                    
                    Spacer()
                    
                    Button (action: {
                        generator.notificationOccurred(.success)
                        connection.sendCommand(command: .honkHorn, completion: {
                            connection.busy = false
                        })
                    }, label: {
                        VStack {
                            Text("HONK")
                                .font(.custom("Gotham Medium", size: 15))
                                .foregroundColor(.gray)
                            
                            Image("controls-honk-icon")
                                .renderingMode(.template)
                                .foregroundColor(Color("BackgroundInverse"))
                                .scaleEffect(1.5)
                                .shadow(radius: 5)
                                .frame(width: 50, height: 50, alignment: .center)
                        }.gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offset = gesture.translation
                                }

                                .onEnded { _ in
                                    if (self.offset.width) > 100 {
                                        activeCard = 1
                                    } else if (self.offset.width) < 100 {
                                        activeCard = 3
                                    }
                                    else {
                                        self.offset.width = 0
                                    }
                                }
                        )
                    })
                }.padding(.horizontal, 70)
            }
        }
        .offset(x: offset.width, y: 0)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }

                .onEnded { _ in
                    if (self.offset.width) > 100 {
                        activeCard = 1
                    } else if (self.offset.width) < 100 {
                        activeCard = 3
                    }
                    else {
                        self.offset.width = 0
                    }
                }
        )
    }
}

struct CardLeft: View {
    @EnvironmentObject var connection: TeslaComponents
    @Environment(\.colorScheme) var colorScheme
    @Binding var activeCard: Int
    @Binding var offset: CGSize
    @State var level: Int = 2
    @State var setting = HeatLevel.off
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        
        // Windows, Climate Fan Toggle, Seat Heater
        
        ZStack {
            Image(colorScheme == .dark ? "dark_card_bg_plain" : "card_bg_plain")
                .resizable()
                .frame(width: 400, height: 170)
            
            VStack {
                HStack {
                    Button (action: {
                        generator.notificationOccurred(.success)
                        connection.sendCommand(command: .startVehicle(password: ""), completion: {
                            connection.busy = false
                        })
                    }, label: {
                        VStack {
                            Text("START")
                                .font(.custom("Gotham Medium", size: 15))
                                .foregroundColor(.gray)
                            
                            Image("home-start-car-icon")
                                .renderingMode(.template)
                                .foregroundColor(Color("BackgroundInverse"))
                                .scaleEffect(1.5)
                                .shadow(radius: 5)
                                .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offset = gesture.translation
                                }

                                .onEnded { _ in
                                    if (self.offset.width) < 100 {
                                        activeCard = 2
                                    } else {
                                        self.offset.width = 0
                                    }
                                }
                        )
                    })
                    
                    Spacer()
                    
                    Button (action: {
                        generator.notificationOccurred(.success)
                        if (level < 3) {
                            level = level + 1
                        } else {
                            level = 0
                        }
                        
                        switch (level) {
                        case 0:
                            setting = HeatLevel.off
                        case 1:
                            setting = HeatLevel.low
                        case 2:
                            setting = HeatLevel.mid
                        case 3:
                            setting = HeatLevel.high
                        default:
                            setting = HeatLevel.off
                        }
                        
                        connection.sendCommand(command: .setSeatHeater(seat: .driver, level: setting), completion: {
                            connection.busy = false
                        })
                    }, label: {
                        VStack {
                            Text("DRIVER")
                                .font(.custom("Gotham Medium", size: 15))
                                .foregroundColor(.gray)
                            
                            SeatHeater(level: $level, mirror: false).environmentObject(connection)
                                .padding(.trailing, 2)
                        }.gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offset = gesture.translation
                                }

                                .onEnded { _ in
                                    if (self.offset.width) < 100 {
                                        activeCard = 2
                                    } else {
                                        self.offset.width = 0
                                    }
                                }
                        )
                    })
                    
                    Spacer()
                    
                    Button (action: {
                        generator.notificationOccurred(.success)
                        connection.sendCommand(command: connection.chosenCar?.climateState?.isClimateOn ?? false ? .stopAutoConditioning : .startAutoConditioning, completion: {
                            connection.busy = false
                        })
                    }, label: {
                        VStack {
                            Text(connection.chosenCar?.climateState?.isClimateOn ?? false ? "DISABLE" : "ENABLE")
                                .font(.custom("Gotham Medium", size: 15))
                                .foregroundColor(.gray)
                            
                            Image(connection.chosenCar?.climateState?.isClimateOn ?? false ? "climate-active" : "climate-inactive")
                                .renderingMode(.template)
                                .foregroundColor(Color("BackgroundInverse"))
                                .scaleEffect(1.5)
                                .shadow(radius: 5)
                                .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offset = gesture.translation
                                }

                                .onEnded { _ in
                                    if (self.offset.width) < 100 {
                                        activeCard = 2
                                    } else {
                                        self.offset.width = 0
                                    }
                                }
                        )
                    })
                }.padding(.horizontal, 70)
            }
        }
        .offset(x: offset.width, y: 0)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }

                .onEnded { _ in
                    if (self.offset.width) < 100 {
                        activeCard = 2
                    } else {
                        self.offset.width = 0
                    }
                }
        )
        .onAppear(perform: {
            level = connection.chosenCar?.climateState?.seatHeaterLeft ?? 0
        })
        .onChange(of: connection.chosenCar?.climateState?.seatHeaterLeft, perform: { value in
            level = value ?? 0
        })
    }
}

struct CardRight: View {
    @EnvironmentObject var connection: TeslaComponents
    @Environment(\.colorScheme) var colorScheme
    @Binding var activeCard: Int
    @Binding var offset: CGSize
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        
        // Sentry Mode, Valet Mode, Speed Limit Mode
        
        ZStack {
            Image(colorScheme == .dark ? "dark_card_bg_plain" : "card_bg_plain")
                .resizable()
                .frame(width: 400, height: 170)
            
            VStack {
                HStack {
                    Button (action: {
                        generator.notificationOccurred(.success)
                        connection.sendCommand(command: connection.chosenCar?.vehicleState?.sentryMode ?? false ? .sentryMode(activated: false) : .sentryMode(activated: true), completion: {
                            connection.busy = false
                        })
                    }, label: {
                        VStack {
                            Text("SENTRY")
                                .font(.custom("Gotham Medium", size: 15))
                                .foregroundColor(.gray)
                            
                            Image(systemName: "eye.circle")
                                .foregroundColor(connection.chosenCar?.vehicleState?.sentryMode ?? true ? .red : Color("BackgroundInverse"))
                                .scaleEffect(2.5)
                                .shadow(radius: 5)
                                .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .padding(.vertical, 2)
                            
                            Text(connection.chosenCar?.vehicleState?.sentryMode ?? true ? "DISABLE" : "ENABLE")
                                .font(.custom("Gotham Medium", size: 15))
                                .padding(.bottom, 2)
                                .foregroundColor(.gray)
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offset = gesture.translation
                                }

                                .onEnded { _ in
                                    if (self.offset.width) > 100 {
                                        activeCard = 2
                                    } else {
                                        self.offset.width = 0
                                    }
                                }
                        )
                    })
                    
                    Spacer()
                    
                    Button (action: {
                        generator.notificationOccurred(.success)
                        print("Needs Fixed")
//                        connection.sendCommand(command: .startVehicle(password: ""), completion: {
//                            connection.busy = false
//                        })
                    }, label: {
                        VStack {
                            Text("VALET")
                                .font(.custom("Gotham Medium", size: 15))
                                .foregroundColor(.gray)
                            
                            Image(systemName: "figure.wave.circle")
                                .renderingMode(.template)
                                .foregroundColor(connection.chosenCar?.vehicleState?.valetMode ?? true ? .green : Color("BackgroundInverse"))
                                .scaleEffect(2.5)
                                .shadow(radius: 5)
                                .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .padding(.vertical, 2)
                            
                            Text(connection.chosenCar?.vehicleState?.valetMode ?? true ? "DISABLE" : "ENABLE")
                                .font(.custom("Gotham Medium", size: 15))
                                .padding(.bottom, 2)
                                .foregroundColor(.gray)
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offset = gesture.translation
                                }

                                .onEnded { _ in
                                    if (self.offset.width) > 100 {
                                        activeCard = 2
                                    } else {
                                        self.offset.width = 0
                                    }
                                }
                        )
                    })
                    
                    Spacer()
                    
                    Button (action: {
                        generator.notificationOccurred(.success)
                        print("Needs fixed")
//                        connection.sendCommand(command: .honkHorn, completion: {
//                            connection.busy = false
//                        })
                    }, label: {
                        VStack {
                            Text("LIMIT")
                                .font(.custom("Gotham Medium", size: 15))
                                .foregroundColor(.gray)
                            
                            Image(systemName: "speedometer")
                                .renderingMode(.template)
                                .foregroundColor(connection.chosenCar?.vehicleState?.speedLimitMode?.active ?? true ? .yellow : Color("BackgroundInverse"))
                                .scaleEffect(2.5)
                                .shadow(radius: 5)
                                .frame(width: 50, height: 50, alignment: .center)
                                .padding(.vertical, 2)
                            
                            Text(connection.chosenCar?.vehicleState?.speedLimitMode?.active ?? true ? "DISABLE" : "ENABLE")
                                .font(.custom("Gotham Medium", size: 15))
                                .padding(.bottom, 2)
                                .foregroundColor(.gray)
                        }.gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offset = gesture.translation
                                }

                                .onEnded { _ in
                                    if (self.offset.width) > 100 {
                                        activeCard = 2
                                    } else {
                                        self.offset.width = 0
                                    }
                                }
                        )
                    })
                }.padding(.horizontal, 70)
            }
        }
        .offset(x: offset.width, y: 0)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }

                .onEnded { _ in
                    if (self.offset.width) > 100 {
                        activeCard = 2
                    } else {
                        self.offset.width = 0
                    }
                }
        )
    }
}

struct CardAlternate: View {
    @EnvironmentObject var connection: TeslaComponents
    @Environment(\.colorScheme) var colorScheme
    @Binding var activeCard: Int
    @Binding var offset: CGSize
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        
        //Drive Button, Media Button
        ZStack {
            Image(colorScheme == .dark ? "dark_card_bg_plain" : "card_bg_plain")
                .resizable()
                .frame(width: 400, height: 170)

            
            VStack {
                HStack {
                    Button (action: {
                        generator.notificationOccurred(.success)
                        connection.driveView = true
                    }, label: {
                        VStack {
                            Text("DRIVE VIEW")
                                .font(.custom("Gotham Medium", size: 15))
                                .foregroundColor(.gray)
                            
                            Image("home-location-icon")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color("BackgroundInverse"))
                                .scaleEffect(1)
                                .shadow(radius: 5)
                                .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offset = gesture.translation
                                }

                                .onEnded { _ in
                                    if (self.offset.width) > 100 {
                                        activeCard = 1
                                    } else if (self.offset.width) < 100 {
                                        activeCard = 3
                                    }
                                    else {
                                        self.offset.width = 0
                                    }
                                }
                        )
                    })
                    
                    Spacer()
                    
                    Button (action: {
                        generator.notificationOccurred(.success)
                        connection.mediaView.toggle()
                    }, label: {
                        VStack {
                            Text("MEDIA VIEW")
                                .font(.custom("Gotham Medium", size: 15))
                                .foregroundColor(.gray)
                            
                            Image("icon_media")
                                .renderingMode(.template)
                                .foregroundColor(Color("BackgroundInverse"))
                                .scaleEffect(1)
                                .shadow(radius: 5)
                                .frame(width: 50, height: 50, alignment: .center)
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offset = gesture.translation
                                }

                                .onEnded { _ in
                                    if (self.offset.width) > 100 {
                                        activeCard = 1
                                    } else if (self.offset.width) < 100 {
                                        activeCard = 3
                                    }
                                    else {
                                        self.offset.width = 0
                                    }
                                }
                        )
                    })
                }.padding(.horizontal, 70)
            }
        }
        .offset(x: offset.width, y: 0)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }

                .onEnded { _ in
                    if (self.offset.width) > 100 {
                        activeCard = 1
                    } else if (self.offset.width) < 100 {
                        activeCard = 3
                    }
                    else {
                        self.offset.width = 0
                    }
                }
        )
    }
}

struct CardCarousel_Previews: PreviewProvider {
    static var previews: some View {
        CardCarousel(card2Offset: CGSize(), card1Offset: CGSize(), card3Offset: CGSize()).preferredColorScheme(.dark).environmentObject(TeslaComponents())
        
        CardAlternate(activeCard: .constant(2), offset: .constant(.zero)).environmentObject(TeslaComponents())
    }
}
