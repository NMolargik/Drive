//
//  StandaloneHeater.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/15/21.
//

import SwiftUI
import TeslaSwift
import CoreHaptics

struct StandaloneHeater: View {
    @EnvironmentObject var connection: TeslaComponents
    @State var levelnum = 0
    @Binding var level: HeatLevel
    var body: some View {
        Image("seat-heater-\(levelnum)")
            .onChange(of: level, perform: { value in
                switch (level) {
                case .off: levelnum = 0
                case .low: levelnum = 1
                case .mid: levelnum = 2
                case .high: levelnum = 3
                }
            })
    }
}

struct StandaloneHeater_Previews: PreviewProvider {
    static var previews: some View {
        StandaloneHeater(level: .constant(.mid)).environmentObject(TeslaComponents())
    }
}
