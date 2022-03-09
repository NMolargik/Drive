//
//  Temperature.swift
//  
//
//  Created by Nick Molargik on 11/26/20.
//

import SwiftUI
import TeslaSwift

struct Temperature: View {
    @EnvironmentObject var connection: TeslaComponents
    @State private var temperatureDisplayed: Float = 75.0
    @State private var temperatureFromCar: Float = 23.9
    @State private var tempSliding: Bool = false
    
    var body: some View {
        VStack {
            //Fahrenheit Temperature
            if ((connection.chosenCar?.guiSettings?.temperatureUnits) ?? "F" == "F") {
                Text((temperatureDisplayed > 81) ? "HI" : (temperatureDisplayed < 60) ? "LO" : "\(String(format: "%.0f", temperatureDisplayed))°")
                    .foregroundColor(temperatureDisplayed > 81 ? Color.red : (temperatureDisplayed < 60) ? Color.blue : Color.white)
                    .bold()
                    .font(.title)
                    .padding(.bottom, -10)
                    
                Slider(value: $temperatureDisplayed, in: 59.0...82.0, step: 1.0, onEditingChanged: { bool in
                    if (bool) {
                        tempSliding = true
                    } else {
                        tempSliding = false
                        connection.sendCommand(command: VehicleCommand.setTemperature(driverTemperature: Double(fahrenheitToCelsius(temp: temperatureDisplayed)), passengerTemperature: Double(fahrenheitToCelsius( temp: temperatureDisplayed))), completion: {
                            connection.busy = false
                        })
                    }
                })
                .scaleEffect(x: 0.8, y: 0.8)
                .accentColor(temperatureDisplayed > 81 ? Color.red : (temperatureDisplayed < 60) ? Color.blue : Color.white)
                .onAppear(perform: {
                    temperatureDisplayed = Float((connection.chosenCar?.climateState?.driverTemperatureSetting?.fahrenheit) ?? 69)
                })
                .onChange(of: (connection.chosenCar?.climateState?.driverTemperatureSetting?.celsius) ?? 20.0, perform: { value in
                    if (!tempSliding) {
                        temperatureDisplayed = celsiusToFahrenheit(temp: Float(value))
                    }
                })
            }
            //Celsius Temperature
            else {
                Text((temperatureFromCar > 26.7) ? "HI" : (temperatureFromCar < 15.6) ? "LO" : "\(String(format: "%.0f", temperatureFromCar))°")
                    .foregroundColor(temperatureFromCar > 26.7 ? Color.red : (temperatureFromCar < 15.6) ? Color.blue : Color.white)
                    .bold()
                    .font(.title)
                    .padding(.bottom, -10)
                
                Slider(value: $temperatureDisplayed, in: 15.0...27.8, step: 0.1, onEditingChanged: { bool in
                    if (bool) {
                        tempSliding = true
                    } else {
                        tempSliding = false
                        connection.sendCommand(command: VehicleCommand.setTemperature(driverTemperature: Double(temperatureDisplayed), passengerTemperature: Double(temperatureDisplayed)), completion: {
                            connection.busy = false
                        })
                    }
                })
                .scaleEffect(x: 0.8, y: 0.8)
                .accentColor(temperatureDisplayed > 81 ? Color.red : (temperatureDisplayed < 60) ? Color.blue : Color.white)
                .onAppear(perform: {
                    temperatureDisplayed = celsiusToFahrenheit(temp: Float((connection.chosenCar?.climateState?.driverTemperatureSetting?.celsius)!))
                })
                .onChange(of: (connection.chosenCar?.climateState?.driverTemperatureSetting?.celsius)!, perform: { value in
                    if (!tempSliding) {
                        temperatureDisplayed = celsiusToFahrenheit(temp: Float(value))
                    }
                })
            }
        }
    }
}

func fahrenheitToCelsius (temp: Float) -> Float {
    var temperature = temp
    temperature = (temperature - 32) * 5 / 9
    return temperature
}

func celsiusToFahrenheit (temp: Float) -> Float {
    var temperature = temp
    temperature = (temperature * 9 / 5) + 32
    return temperature
}

struct Temperature_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            Temperature().environmentObject(TeslaComponents())
        }
    }
}
