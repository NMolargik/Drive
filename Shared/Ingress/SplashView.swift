//
//  SplashView.swift
//  Drive
//
//  Created by Nick Molargik on 5/5/21.
//

import SwiftUI
import TeslaSwift
import CoreHaptics

struct SplashView: View {
    @State private var webPresented: Bool = false
    @EnvironmentObject var connection: TeslaComponents
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        if (!connection.teslaAPI.isAuthenticated) {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Drive")
                        .font(.custom("Gotham Medium", size: 50))
                        .foregroundColor(Color("BackgroundInverse"))
                    Text("for Tesla")
                        .font(.custom("Gotham Medium", size: 20))
                        .foregroundColor(Color("BackgroundInverse"))
                    
                    Button(action: {
                        generator.notificationOccurred(.success)
                        webPresented = true
                    }, label: {
                        ZStack {
                            Capsule()
                                .frame(width: 175, height: 50, alignment: .center)
                                .foregroundColor(.gray)
                            
                            Text("LOGIN")
                                .font(.custom("Gotham Medium", size: 20))
                                .padding()
                                .foregroundColor(Color("BackgroundInverse"))
                        }
                    }).sheet(isPresented: $webPresented, content: {
                        WebAuthView(webPresented: $webPresented).environmentObject(connection)
                    }).padding(.vertical, 50)
                }
            }
        } else {
            if (connection.vehicles.count == 1) {
                ControlHub(name: connection.vehicles.first?.displayName ?? "Vehicle").environmentObject(connection)
                    .onAppear {
                        getInitialData(vehicle: connection.vehicles.first!, completion: {
                            connection.initialdone = true
                        })
                    }
            } else {
                VehicleSelection().environmentObject(connection)
            }
        }
    
    }
        
    func getInitialData(vehicle: Vehicle, completion: @escaping () -> Void) {
        print("Requesting initial data from \(String(describing: vehicle.displayName))")
        connection.teslaAPI.getAllData(vehicle, completion: { response in
            switch response {
            case .success(let vehicleData):
                connection.chosenCar = vehicleData
                if ((connection.chosenCar?.state) ?? "asleep" == "online") {
                    connection.initialdone = true
                }
            case .failure(let error):
                print("Get Initial Data Error")
                print("Initial Data Error: \(error)")
                completion()
            }
        })
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .preferredColorScheme(.light).environmentObject(TeslaComponents())
    }
}


// NEED TO ADD APP SETTINGS
