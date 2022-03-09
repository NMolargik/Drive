//
//  DriveApp.swift
//  Shared
//
//  Created by Nick Molargik on 5/5/21.
//

import SwiftUI
import TeslaSwift
import Network
import Combine

@main


struct DriveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @ObservedObject var connection = TeslaComponents()
    let monitor = NWPathMonitor()
    var body: some Scene {
        WindowGroup {
            SplashView().environmentObject(connection).onReceive(connection.timer) { _ in
                //Only grab data for vehicle if connection is not already busy sending a command
                monitor.pathUpdateHandler = { path in
                    if path.status == .satisfied {
                        connection.networkConnected = true
                    } else {
                        print("Network Disconnected")
                        connection.networkConnected = false
                    }
                }
                
                if (connection.chosenCar?.id != nil) {
                    if ((connection.chosenCar?.state)! == "asleep") {
                        connection.getData(override: true, completion: {
                            connection.busy = false
                        })
                    }
                }
                if (connection.teslaAPI.isAuthenticated) {
                    //print("Busy Connection: ")
                    //print(connection.busy)
                    if (!connection.busy) {
                        connection.getData(override: false) {
                            connection.busy = false
                            print("Data stored - Closure")
                        }
                    }
                }
            }.environmentObject(connection)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait //By default you want all your views to rotate freely

        func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return AppDelegate.orientationLock
        }
}
