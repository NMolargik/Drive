//
//  VehicleSelection.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/5/21.
//

import SwiftUI
import TeslaSwift
import CoreHaptics

struct VehicleSelection: View {
    @EnvironmentObject var connection: TeslaComponents
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    Color("Background").edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        ForEach(connection.vehicles, id: \.id) { vehicle in
                            NavigationLink(
                                destination: ControlHub(name: vehicle.displayName ?? "Vehicle").environmentObject(connection),
                                label: {
                                    SelectableVehicle(vehicle: vehicle).padding()
                            }).onDisappear(perform: {
                                generator.notificationOccurred(.success)
                                getInitialData(vehicle: vehicle, completion: {
                                    connection.initialdone = true
                                })
                            })
                        }
                    }
                }
                .navigationTitle(Text("Vehicles"))
                .navigationBarTitleDisplayMode(.automatic)
                .navigationBarTitle(Text("Vehicles"))
                .accentColor(.white)
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

struct VehicleSelection_Previews: PreviewProvider {
    static var previews: some View {
        VehicleSelection().preferredColorScheme(.dark).environmentObject(TeslaComponents())
    }
}
