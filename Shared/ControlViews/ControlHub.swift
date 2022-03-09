//
//  ControlHub.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/6/21.
//

import SwiftUI
import TeslaSwift

struct ControlHub: View {
    @EnvironmentObject var connection: TeslaComponents
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var connectionAnimating = true
    @State var connectionOverride = false
    @State var infoShown = false
    @State var name = "Vehicle"
    
    var body: some View {
        if (connection.driveView || connection.chosenCar?.driveState?.shiftState ?? DriveState.ShiftState.park != DriveState.ShiftState.park) {
            DriveView().environmentObject(connection)
        } else {
        
            if (connection.initialdone || connectionOverride) {
                ScrollView {
                    TabView(selection: $connection.selectedTab) {
                        ClimateSplash().environmentObject(connection)
                            .tabItem {
                                Label("Climate", systemImage: "thermometer")
                            }
                            .tag(1)
                        ZStack {
                            VehicleSplash().environmentObject(connection)
                                .tabItem {
                                    Label("Vehicle", systemImage: "car")
                                }
                            
                            VStack {
                                HStack {
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "list.bullet")
                                            .foregroundColor(Color("BackgroundInverse"))
                                            .scaleEffect(1.5)
                                            .padding()
                                    })
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        connection.driveView = true
                                        
                                    }, label: {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(Color("BackgroundInverse"))
                                            .padding()
                                            .scaleEffect(1.8)
                                    })
                                }.padding(.top, 50)
                                .padding(.horizontal)
                                
                                Spacer()
                            }
                        }
                        .tag(2)
                        
                        ChargingSplash().environmentObject(connection)
                            .tabItem {
                                Label("Charging", systemImage: "bolt")
                            }
                            .tag(3)
                    }
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                }
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: {
                   setupAppearance()
                   UIScrollView.appearance().bounces = false
                
                 })
            } else {
                //Car is not connected
                //if (connection.chosenCar?.inService ?? true)
                
                
                ZStack {
                    Color("Background").edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Connecting To")
                            .font(.custom("Gotham Medium", size: 40))
                        
                        Text("\(name)")
                            .navigationBarHidden(true)
                            .font(.custom("Gotham Medium", size: 40))
                            .multilineTextAlignment(.center)
                    }
                }.navigationBarHidden(true)
                
            }
        }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("BackgroundInverse"))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color("BackgroundInverse")).withAlphaComponent(0.2)
    }
}

struct ControlHub_Previews: PreviewProvider {
    static var previews: some View {
        ControlHub(connectionOverride: true).preferredColorScheme(.dark).environmentObject(TeslaComponents())
    }
}
