//
//  DriveView.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/11/21.
//

import SwiftUI
import TeslaSwift
import Network
import Combine
import MapKit
import TeslaSwiftStreaming

struct DriveView: View {
    @EnvironmentObject var connection: TeslaComponents
    
    @State fileprivate var centerCoordinate = CLLocationCoordinate2D()
    @State var trackCar: Bool = false
    @State var trackUser: Bool = true
    @State var satellite: Bool = false
    @State var forceRefreshAnnotations: Bool = false
    @State var locations = [MKPointAnnotation]()
    @State var spinning = false
    @State var spinAmount: Int = 0
    @State var mapShown = false
    @State var showDriveOnDrive: Bool = false
    @State var shiftState: String = "P"
    
    
    //Streaming Data
    @State var stream: TeslaStreaming!
    @State var streaming = false
    @State var vehicle: Vehicle?
    @State var streamingText: String = ""
    @State var speed: Float = 0.0
    @State var power: Int = 0
    
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            HStack {
                if (connection.chosenCar?.driveState?.shiftState ?? DriveState.ShiftState.park != DriveState.ShiftState.park) {
                    MapView().environmentObject(connection)
                        .edgesIgnoringSafeArea(.all)
                        .onAppear {
                            UIApplication.shared.isIdleTimerDisabled = true
                        }
                        .onDisappear {
                            UIApplication.shared.isIdleTimerDisabled = false
                        }
                }
                    
                VStack {
                    PowerMeter(value: .constant(Float(power))).environmentObject(connection)
                
                    VStack {
                        Text("\((speed), specifier: "%0.0f")")
                            .foregroundColor(Color("BackgroundInverse"))
                            .font(.custom("Gotham Medium", size: 100))
                            .transition(.opacity)
                            .id("MySpeed" + String(speed))
                        Text(connection.chosenCar?.guiSettings?.distanceUnits ?? "mi/hr" == "mi/hr" ? "MPH" : "KPH")
                            .foregroundColor(Color("Inactive"))
                            .font(.custom("Gotham Medium", size: 30))
                    }
                    
                    HStack (alignment: .top){
                        Spacer()
                        Group {
                            Text("P")
                                .foregroundColor((shiftState == "P" || shiftState == "") ? Color("Active") : Color("Inactive"))
                                .font(.custom("Gotham Medium", size: 40))
                                .bold()
                                .padding()
                            
                            Text("R")
                                .foregroundColor(shiftState == "R" ? Color("Active") : Color("Inactive"))
                                .font(.custom("Gotham Medium", size: 40))
                                .bold()
                                .padding()
                            
                            Text("N")
                                .foregroundColor(shiftState == "N" ? Color("Active") : Color("Inactive"))
                                .font(.custom("Gotham Medium", size: 40))
                                .bold()
                                .padding()
                            
                            Text("D")
                                .foregroundColor(shiftState == "D" ? Color("Active") : Color("Inactive"))
                                .font(.custom("Gotham Medium", size: 40))
                                .bold()
                                .padding()
                        }
                        
                        Spacer()
                    }
                    
                    SmallBatteries().environmentObject(connection)
                        .scaleEffect(x: 2, y: 1)
                }
                
            }
        }
        .onAppear {
            connection.busy = true
//            connection.driveView = true
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation") // Forcing the rotation to portrait
            AppDelegate.orientationLock = .landscapeRight // And making sure it stays that way
                
            //STREAM
            stream = TeslaStreaming(teslaSwift: connection.teslaAPI)
            
            if !streaming {
                guard let vehicle = connection.chosenCar else { return }
                stream.openStream(vehicle: vehicle, dataReceived: {
                    (event: TeslaStreamingEvent) in
                    self.processEvent(event: event)
                })
            }
            
            
        }.onDisappear {
            connection.busy = false
            AppDelegate.orientationLock = .portrait // Unlocking the rotation when leaving the view
        }
//        .onChange(of: connection.chosenCar?.vehicleState?.isUserPresent, perform: { value in
//            connection.driveView = false
//        })
        
        .onChange(of: streaming, perform: { value in
            if !streaming {
                guard let vehicle = connection.chosenCar else { return }
                stream.openStream(vehicle: vehicle, dataReceived: {
                    (event: TeslaStreamingEvent) in
                    self.processEvent(event: event)
                })
            }
        })
    }
    
    func processEvent(event: TeslaStreamingEvent) {
        switch event {
        case .error(let error):
            streamingText = error.localizedDescription
            print(error.localizedDescription)
            stream.closeStream()
            streaming = false
            
            
        case .event(let event):
            streamingText = event.description
            shiftState = event.shiftState ?? "P"
            speed = Float(event.speed ?? 0.0)
            power = event.power ?? 0
        case .disconnected:
            streamingText = "Disconnected"
            break
        case .open:
            streamingText = "Stream Open"
            streaming = true
            print("Open Streaming")
        }
    }
}

struct DriveView_Previews: PreviewProvider {
    static var previews: some View {
        DriveView().preferredColorScheme(.dark).environmentObject(TeslaComponents())
            .previewLayout(.fixed(width: 2778, height: 1284))
    }
}
