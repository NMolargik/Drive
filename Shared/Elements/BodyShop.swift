//
//  BodyShop.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/7/21.
//
//  Where the magic happens @_@

import SwiftUI
import TeslaSwift

struct BodyShop: View {
    @EnvironmentObject var connection: TeslaComponents
    
    var body: some View {
        ZStack {
            Group {
                switch (connection.chosenCar?.vehicleConfig?.carType) {
                case "model3":
                    Image("3_shadow")
                    
                    Image("3_body")

                    Image("3_body_paint")
                        .colorMultiply(Color((connection.chosenCar?.vehicleConfig?.exteriorColor)!))
                    
                case "modely":
                    
                    Image("y_shadow")
                    
                    Image("y_body")
                    
                    Image("y_body_paint")
                        .colorMultiply(Color((connection.chosenCar?.vehicleConfig?.exteriorColor)!))
                    
                case "models":
                    Image("s_shadow")
                    
                    Image("s_body")
                    
                case "modelx":
                    Image("x_body")
                
                default :
                    Image("3_shadow")
                    
                    Image("3_body")
                    
                    Image("3_body_paint")
                        .colorMultiply(Color("DeepBlue"))
                }
            }
            
            Doors().environmentObject(connection)
            
            Trunks().environmentObject(connection)
            
            Accessories().environmentObject(connection)
        }
    }
}

struct Doors: View {
    @EnvironmentObject var connection: TeslaComponents
    
    var body: some View {
        ZStack {
            switch (connection.chosenCar?.vehicleConfig?.carType) {
            case "model3":
                Image((connection.chosenCar?.vehicleState?.driverDoorOpen ?? true) ? "3_left_front_open" : "3_left_front_closed")
                
                Image((connection.chosenCar?.vehicleState?.passengerDoorOpen ?? true) ? "3_right_front_open" : "3_right_front_closed")
                
                Image((connection.chosenCar?.vehicleState?.driverRearDoorOpen ?? true) ? "3_left_rear_open" : "3_left_rear_closed")
                
                Image((connection.chosenCar?.vehicleState?.passengerRearDoorOpen ?? true) ? "3_right_rear_open" : "3_right_rear_closed")
                
                Image((connection.chosenCar?.vehicleState?.driverDoorOpen ?? true) ? "3_left_front_open_paint" : "3_left_front_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
                
                Image((connection.chosenCar?.vehicleState?.passengerDoorOpen ?? true) ? "3_right_front_open_paint" : "3_right_front_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
                
                Image((connection.chosenCar?.vehicleState?.driverRearDoorOpen ?? true) ? "3_left_rear_open_paint" : "3_left_rear_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
                
                Image((connection.chosenCar?.vehicleState?.passengerRearDoorOpen ?? true) ? "3_right_rear_open_paint" : "3_right_rear_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
                
            case "modely":
                Image((connection.chosenCar?.vehicleState?.driverDoorOpen ?? true) ? "y_left_front_open" : "y_left_front_closed")
                
                Image((connection.chosenCar?.vehicleState?.passengerDoorOpen ?? true) ? "y_right_front_open" : "y_right_front_closed")
                
                Image((connection.chosenCar?.vehicleState?.driverRearDoorOpen ?? true) ? "y_left_rear_open" : "y_left_rear_closed")
                
                Image((connection.chosenCar?.vehicleState?.passengerRearDoorOpen ?? true) ? "y_right_rear_open" : "y_right_rear_closed")
                
                Image((connection.chosenCar?.vehicleState?.driverDoorOpen ?? true) ? "y_left_front_open_paint" : "y_left_front_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
                
                Image((connection.chosenCar?.vehicleState?.passengerDoorOpen ?? true) ? "y_right_front_open_paint" : "y_right_front_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
                
                Image((connection.chosenCar?.vehicleState?.driverRearDoorOpen ?? true) ? "y_left_rear_open_paint" : "y_left_rear_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
                
                Image((connection.chosenCar?.vehicleState?.passengerRearDoorOpen ?? true) ? "y_right_rear_open_paint" : "y_right_rear_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))

            default:
                Image((connection.chosenCar?.vehicleState?.driverDoorOpen ?? true) ? "3_left_front_open" : "3_left_front_closed")
                
                Image((connection.chosenCar?.vehicleState?.passengerDoorOpen ?? true) ? "3_right_front_open" : "3_right_front_closed")
                
                Image((connection.chosenCar?.vehicleState?.driverRearDoorOpen ?? true) ? "3_left_rear_open" : "3_left_rear_closed")
                
                Image((connection.chosenCar?.vehicleState?.passengerRearDoorOpen ?? true) ? "3_right_rear_open" : "3_right_rear_closed")
                
                Image((connection.chosenCar?.vehicleState?.driverDoorOpen ?? true) ? "3_left_front_open_paint" : "3_left_front_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
                
                Image((connection.chosenCar?.vehicleState?.passengerDoorOpen ?? true) ? "3_right_front_open_paint" : "3_right_front_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
                
                Image((connection.chosenCar?.vehicleState?.driverRearDoorOpen ?? true) ? "3_left_rear_open_paint" : "3_left_rear_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
                
                Image((connection.chosenCar?.vehicleState?.passengerRearDoorOpen ?? true) ? "3_right_rear_open_paint" : "3_right_rear_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
            }
        }
    }
}

struct Trunks: View {
    @EnvironmentObject var connection: TeslaComponents
    
    var body: some View {
        ZStack {
            switch (connection.chosenCar?.vehicleConfig?.carType) {
            case "model3":
                //Frunk
                Image((connection.chosenCar?.vehicleState?.frontTrunkOpen ?? true) ? "3_frunk_open" : "3_frunk_closed")
                
                if (connection.chosenCar?.vehicleState?.frontTrunkOpen ?? true) {
                    Image("3_frunk_open_emblem")
                }
                
                Image((connection.chosenCar?.vehicleState?.frontTrunkOpen ?? true) ? "3_frunk_open_paint" : "3_frunk_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
                
                //Trunk
                Image((connection.chosenCar?.vehicleState?.rearTrunkOpen ?? true) ? "3_trunk_open" : "3_trunk_closed")
                
                if (connection.chosenCar?.vehicleState?.rearTrunkOpen ?? true) {
                    Image("3_trunk_open_emblem")
                }
                
                Image((connection.chosenCar?.vehicleState?.rearTrunkOpen ?? true) ? "3_trunk_open_paint" : "3_trunk_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
                
                
            default:
                //Frunk
                Image((connection.chosenCar?.vehicleState?.frontTrunkOpen ?? true) ? "3_frunk_open" : "3_frunk_closed")
                
                if (connection.chosenCar?.vehicleState?.frontTrunkOpen ?? true) {
                    Image("3_frunk_open_emblem")
                }
                
                Image((connection.chosenCar?.vehicleState?.frontTrunkOpen ?? true) ? "3_frunk_open_paint" : "3_frunk_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
                
                //Trunk
                Image((connection.chosenCar?.vehicleState?.rearTrunkOpen ?? true) ? "3_trunk_open" : "3_trunk_closed")
                
                if (connection.chosenCar?.vehicleState?.rearTrunkOpen ?? true) {
                    Image("3_trunk_open_emblem")
                }
                
                Image((connection.chosenCar?.vehicleState?.rearTrunkOpen ?? true) ? "3_trunk_open_paint" : "3_trunk_closed_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor ?? "DeepBlue"))
            }
        }
    }
}

struct Accessories: View {
    @EnvironmentObject var connection: TeslaComponents
    
    var body: some View {
        ZStack {
            //Charge Port
            switch (connection.chosenCar?.vehicleConfig?.carType) {
            case "model3":
                if ((connection.chosenCar?.chargeState?.chargePortDoorOpen) == true) {
                    Image("3_charge_port_open_paint")
                        .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor! ?? "DeepBlue"))
                } else {
                    Image("3_charge_port_closed")
                }
            default:
                Image("3_charge_port_open_paint")
                    .colorMultiply(Color(connection.chosenCar?.vehicleConfig?.exteriorColor! ?? "DeepBlue"))
            }
            
            
            
            if ((connection.chosenCar?.vehicleConfig?.spoilerType! ?? "Passive") == "Passive") {
                switch (connection.chosenCar?.vehicleConfig?.carType) {
                case "model3":
                    //Spoiler
                    Image((connection.chosenCar?.vehicleState?.rearTrunkOpen ?? false) ? "3_spoiler_open" : "3_spoiler_closed")
                        .offset(y: (connection.chosenCar?.vehicleState?.rearTrunkOpen ?? true) ? 155 : 160)
                    
                default:
                    //Spoiler
                    Image((connection.chosenCar?.vehicleState?.rearTrunkOpen ?? true) ? "3_spoiler_open" : "3_spoiler_closed")
                        .offset(y: (connection.chosenCar?.vehicleState?.rearTrunkOpen ?? true) ? 155 : 160)
                }
            }
        }
    }
}

struct BodyShop_Previews: PreviewProvider {
    static var previews: some View {
        BodyShop().preferredColorScheme(.dark).environmentObject(TeslaComponents())
    }
}
