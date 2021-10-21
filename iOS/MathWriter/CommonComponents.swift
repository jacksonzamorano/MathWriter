import SwiftUI

struct PreviewHeaderView: View {
    @EnvironmentObject var renderer:MathRenderer
    
    var body: some View {
        HStack {
            ZoomMenu(renderScale: $renderer.renderScale)
            Spacer()
            Text("Resolution: \(renderer.imageW) ✕ \(renderer.imageH)")
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
            Spacer()
            ColorModeMenu(colorMode: $renderer.colorMode)
        }.padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
    }
}

struct ZoomMenu: View {
    @Binding var renderScale: Double
    
    var body: some View {
        Menu {
            Button("25%") {
                self.renderScale = 0.25
            }
            Button("50%") {
                self.renderScale = 0.50
            }
            Button("75%") {
                self.renderScale = 0.75
            }
            Button("100%") {
                self.renderScale = 1.0
            }
            Button("125%") {
                self.renderScale = 1.25
            }
            Button("150%") {
                self.renderScale = 1.50
            }
            Button("175%") {
                self.renderScale = 1.75
            }
            Button("200%") {
                self.renderScale = 2.00
            }
        } label: {
            Text("\(Int(self.renderScale*100))%")
                .fontWeight(.bold)
                .frame(width: 70, height: 30)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(15)
        }
    }
}

struct ColorModeMenu: View {
    @Binding var colorMode: Int
    
    var body: some View {
        Menu {
            Button("Auto (Light/Dark)") {
                self.colorMode = 0
            }
            Button("Auto (White/Black)") {
                self.colorMode = 1
            }
            Button("White") {
                self.colorMode = 2
            }
            Button("Light") {
                self.colorMode = 3
            }
            Button("Dark") {
                self.colorMode = 4
            }
            Button("Black") {
                self.colorMode = 5
            }
        } label: {
            Text(title())
                .fontWeight(.bold)
                .frame(width: 100, height: 30)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(15)
        }
    }
    
    func title() -> String {
        var title = "Auto L/D"
        if self.colorMode == 1 { title = "Auto W/B" }
        else if self.colorMode == 2 { title = "White" }
        else if self.colorMode == 3 { title = "Light" }
        else if self.colorMode == 4 { title = "Dark" }
        else if self.colorMode == 5 { title = "Black" }
        return title
    }
}
