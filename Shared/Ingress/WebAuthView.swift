//
//  WebAuthView.swift
//  Drive
//
//  Created by Nick Molargik on 5/5/21.
//

import Foundation
import SwiftUI
import UIKit
import TeslaSwift

struct WebAuthView: UIViewControllerRepresentable {
    @EnvironmentObject var connection: TeslaComponents
    //@Binding var failedLogin: Bool
    //@Binding var loggingIn: Bool
    @Binding var webPresented: Bool
    let userDefaults = UserDefaults.standard
    
    func makeUIViewController(context: Context) -> UIViewController {
        let auth = connection.teslaAPI.authenticateWeb { authResult in
            switch authResult {
            case .success(let token):
                print("Login Succeeded")
                print("Access Token: \(token.accessToken ?? "")")
                userDefaults.set(connection.teslaAPI.token?.jsonString, forKey: "accessToken")
                print("Access Token Saved")
                //print("Confirm User Default Auth Token Save:\(userDefaults.accessToken ?? "")")
                print("Fully Authenticated, Proceed")
                webPresented = false
                userDefaults.set(true, forKey: "loggedIn")
                connection.getVehicles()
                return
                
            case .failure(let error):
                //Failure Receiving Token
                print("Login Failed")
                print("Failure: \(error)")
                return
            }
        }
        guard let teslaAuthController = auth else { return UIViewController() }
        return teslaAuthController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update ViewController in response to SwiftUI state changes...
    }
}
