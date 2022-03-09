import SwiftUI
import TeslaSwift

struct PowerMeter: View {
    @EnvironmentObject var connection: TeslaComponents
    @Binding var value: Float
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Rectangle()
                        .frame(width: 300, height: 5)
                        .foregroundColor(Color("Inactive"))
                        .opacity(0.5)
                }

                HStack {
                    ZStack (alignment: .trailing) {
                        if (value <= 0) {
                            Rectangle()
                                .frame(width: 150 * (CGFloat(abs(value)) / 100), height: 5)
                                .foregroundColor(Color("ActiveGreen"))
                                .animation(.spring())
                        }
                        Rectangle()
                            .frame(width: 150, height: 5)
                            .foregroundColor(.clear)
                    }
                    ZStack (alignment: .leading) {
                        Rectangle()
                            .frame(width: 150, height: 5)
                            .foregroundColor(.clear)
                        
                        Rectangle()
                            .frame(width: 150 * (CGFloat(value) / 350), height: 5)
                            .foregroundColor(Color("ActivePowerMeter"))
                            .animation(.spring())
                            .flipsForRightToLeftLayoutDirection(true)
                    }
                }
            }
        }
    }
}

struct PowerMeter_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            PowerMeter(value: .constant(75)).environmentObject(TeslaComponents())
        }
        .preferredColorScheme(.light)
    }
}
