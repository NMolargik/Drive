//
//  SelectableCarPhoto.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 5/12/21.
//

import SwiftUI

struct SelectableCarPhoto: View {
    @EnvironmentObject var connection: TeslaComponents
    @State var options: [String] = []
    @State var model: String = "3"
    var body: some View {
        ZStack {
            Image("\(model)select")
        }.onAppear {
            model = getModel(options: options)
        }
    }
    func getModel(options: [String]) -> String {
        for option in options {
            switch option {
            case "MDLS": model = "S"
            case "MS03": model = "S"
            case "MS04": model = "S"
            case "MDLX": model = "X"
            case "MDL3": model = "3"
            case "MDLY": model = "Y"
            default: model = "3"

            }
        }
        return model
    }
}

struct SelectableCarPhoto_Previews: PreviewProvider {
    static var previews: some View {
        SelectableCarPhoto(model: "3").environmentObject(TeslaComponents())
    }
}
