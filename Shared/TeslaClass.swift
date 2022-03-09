//
//  TeslaClass.swift
//  Drive
//
//  Created by Nick Molargik on 5/5/21.
//

import Foundation
import TeslaSwift
import Combine
import MapKit

class TeslaComponents: ObservableObject {
    let objectWillChange: ObservableObjectPublisher = ObservableObjectPublisher()
    
    @Published var teslaAPI = TeslaSwift()
    @Published var vehicles = [Vehicle]()
    @Published var chosenCar: VehicleExtended? = nil
    @Published var nearbyChargingSites: NearbyChargingSites?
    @Published var busy: Bool = false
    @Published var driveView: Bool = false
    @Published var mediaView: Bool = false
    @Published var timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect() //"every" indicates time between data calls
    @Published var demoMode: Bool = false
    @Published var locationManager: CLLocationManager = CLLocationManager()
    @Published var initialdone: Bool = false
    @Published var superchargers: [NearbyChargingSites.Supercharger] = []
    @Published var regularchargers: [NearbyChargingSites.DestinationCharger] = []
    @Published var networkConnected: Bool = true
    @Published var selectedTab: Int = 2
    
    let userDefaults = UserDefaults.standard
    
    func getData(override: Bool?, completion: @escaping () -> Void) {
        self.objectWillChange.send()
        if (!self.busy || override ?? false) {
            self.busy = true
            if (self.chosenCar?.idInt != nil) {
                self.teslaAPI.getAllData(self.chosenCar!) { response in
                    switch response {
                    case .success(let data):
                        print("Data Grab Success")
                        if (data.vehicleState?.odometer != 0) {
                            self.chosenCar = data
                            self.busy = false
                            completion()
                        }
                    case .failure(let error):
                        print("Error getting data: \(error)")
                        self.busy = false
                        completion()
                    }
                }
            } else {
                self.busy = false
            }
        }
    }
    
    func getVehicles() {
        print("Collecting Vehicles")
        self.teslaAPI.getVehicles() { response in
            switch response {
            case .failure(let data):
                print("Failed To Collect Vehicles")
                print("Collection Error \(data)")
                return
            case .success(let data):
                if (!data.isEmpty) {
                    self.vehicles = data
                    print("\(self.vehicles.first?.vin)")
                }
            }
        }
    }
    
    func sendCommand(command: VehicleCommand, completion: @escaping () -> Void) {
        if (!(self.chosenCar?.inService ?? true) && !self.demoMode) {
            var commandResponse = false
            self.busy = true  //Don't let unexpected data in when sending a command
            
            self.teslaAPI.sendCommandToVehicle(self.chosenCar!, command: command) { response in
                commandResponse = true
                while (!commandResponse) {
                    //Wait for command response
                }
                switch response {
                case .success(let data):
                    print("Send Command: Success")
                    print("Command Response: \(data)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.getData(override: true, completion: {
                            //After data is finally received back, run completion
                            completion()
                        })
                    }
                case .failure(let data):
                    print("Send Command: Failure")
                    print("Command Error: \(data)")
                }
            }
        } else {
            completion()
        }
    }

    func logOut() {
        //let generator = UINotificationFeedbackGenerator()
        //generator.notificationOccurred(.success)
        print("Logging Out")
        //userDefaults.accessToken = "" //Delete access token
        self.vehicles = [] //Clear vehicles
        self.initialdone = false
        //userDefaults.loggedIn = false
        //userDefaults.lockLifterTested = false
        //userDefaults.accessToken = nil
        self.teslaAPI.revoke(completion: { _ in
            print("Token revoked")
            self.userDefaults.synchronize()
        })
        self.teslaAPI.logout()
        
    }
    
    func getNearbyChargingSites() {
        self.teslaAPI.getNearbyChargingSites(self.chosenCar!) { result in
            switch result {
            case .failure(let data):
                print("Charging Site Grab Error: \(data)")
                
            case .success(let data):
                self.nearbyChargingSites = data
                print("Successfully Grabbed Chargers")
                print(data.jsonString!)
                self.superchargers = self.nearbyChargingSites?.superchargers ?? []
                
            }
            return
        }
    }
}
