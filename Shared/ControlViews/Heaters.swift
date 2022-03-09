//
//  Heaters.swift
//  iTesla
//
//  Created by Nick Molargik on 12/29/20.
//

import SwiftUI
import TeslaSwift

struct Heaters: View {
    @EnvironmentObject var connection: TeslaComponents
    
    var body: some View {
        VStack {
            HStack {
                SeatHeater(seat: "frontLeft", buttonValue: .constant((connection.chosenCar?.climateState?.seatHeaterLeft) ?? 2), mirror: false, middle: false).environmentObject(connection)
                    .frame(width: 100, height: 100)
                
                HeaterIncrementer(seat: "frontRight", buttonValue: .constant((connection.chosenCar?.climateState?.seatHeaterRight) ?? 2), mirror: true, middle: false).environmentObject(connection)
                    .frame(width: 100, height: 100)
            }
            
            //If the car has rear seat heaters
            if ((connection.chosenCar?.vehicleConfig?.rearSeatHeaters) ?? 0 > 0) {
                
                //If the car does NOT have third row seats / DOES have second row center seat
                if ((connection.chosenCar?.vehicleConfig?.thirdRowSeats) ?? "<invalid>" == "<invalid>") {
                    HStack {
                        HeaterIncrementer(seat: "rearLeft", buttonValue: .constant((connection.chosenCar?.climateState?.seatHeaterRearLeft) ?? 2), mirror: false, middle: false).environmentObject(connection)
                            .frame(width: 100, height: 100)
                        
                        HeaterIncrementer(seat: "rearCenter", buttonValue: .constant((connection.chosenCar?.climateState?.seatHeaterRearCenter) ?? 2), mirror: false, middle: true).environmentObject(connection)
                            .frame(width: 100, height: 100)
                        
                        HeaterIncrementer(seat: "rearRight", buttonValue: .constant((connection.chosenCar?.climateState?.seatHeaterRearRight) ?? 2), mirror: true, middle: false).environmentObject(connection)
                            .frame(width: 100, height: 100)
                    }
                }
                else { //Car does have third row seats
                    if (connection.chosenCar?.vehicleConfig?.carType ?? "model3" == "modelx") { //Model X has no second row center seat heater... i think
                        HStack {
                            HeaterIncrementer(seat: "rearLeft", buttonValue: .constant((connection.chosenCar?.climateState?.seatHeaterRearLeft) ?? 2), mirror: false, middle: false).environmentObject(connection)
                                .frame(width: 100, height: 100)
                            
                            HeaterIncrementer(seat: "rearRight", buttonValue: .constant((connection.chosenCar?.climateState?.seatHeaterRearRight) ?? 2), mirror: true, middle: false).environmentObject(connection)
                                .frame(width: 100, height: 100)
                        }
                    } else { //I think Model Y with third row will still have center heater?
                        HStack {
                            HeaterIncrementer(seat: "rearLeft", buttonValue: .constant((connection.chosenCar?.climateState?.seatHeaterRearLeft) ?? 2), mirror: false, middle: false).environmentObject(connection)
                                .frame(width: 100, height: 100)
                            
                            HeaterIncrementer(seat: "rearCenter", buttonValue: .constant((connection.chosenCar?.climateState?.seatHeaterRearCenter) ?? 2), mirror: false, middle: true).environmentObject(connection)
                                .frame(width: 100, height: 100)
                            
                            HeaterIncrementer(seat: "rearRight", buttonValue: .constant((connection.chosenCar?.climateState?.seatHeaterRearRight) ?? 2), mirror: true, middle: false).environmentObject(connection)
                                .frame(width: 100, height: 100)
                        }
                        
                        HStack {
                            HeaterIncrementer(seat: "rearLeftBack", buttonValue: .constant((connection.chosenCar?.climateState?.seatHeaterRearLeftBack) ?? 2), mirror: false, middle: false).environmentObject(connection)
                                .frame(width: 100, height: 100)
                            
                            HeaterIncrementer(seat: "rearRightBack", buttonValue: .constant((connection.chosenCar?.climateState?.seatHeaterRearRightBack) ?? 2), mirror: true, middle: false).environmentObject(connection)
                                .frame(width: 100, height: 100)
                        }
                    }

                }
            }
        }.padding(2)
        .onChange(of: connection.chosenCar?.climateState?.isClimateOn, perform: { value in
            if (!(connection.chosenCar?.climateState?.isClimateOn)!) {
                connection.sendCommand(command: VehicleCommand.setSeatHeater(seat: HeatedSeat.driver, level: .off), completion: {
                    connection.busy = false
                })
                
                connection.sendCommand(command: VehicleCommand.setSeatHeater(seat: HeatedSeat.passenger, level: .off), completion: {
                    connection.busy = false
                })
                
                connection.sendCommand(command: VehicleCommand.setSeatHeater(seat: HeatedSeat.rearLeft, level: .off), completion: {
                    connection.busy = false
                })
                
                connection.sendCommand(command: VehicleCommand.setSeatHeater(seat: HeatedSeat.rearCenter, level: .off), completion: {
                    connection.busy = false
                })
                
                connection.sendCommand(command: VehicleCommand.setSeatHeater(seat: HeatedSeat.rearRight, level: .off), completion: {
                    connection.busy = false
                })
                
                connection.sendCommand(command: VehicleCommand.setSeatHeater(seat: HeatedSeat.rearLeftBack, level: .off), completion: {
                    connection.busy = false
                })
                
                connection.sendCommand(command: VehicleCommand.setSeatHeater(seat: HeatedSeat.rearRightBack, level: .off), completion: {
                    connection.busy = false
                })
            }
        })
    }
}

struct Heaters_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Heaters().environmentObject(TeslaComponents())
        }
    }
}
