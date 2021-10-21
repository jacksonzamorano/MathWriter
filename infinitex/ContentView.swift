import SwiftUI
import WebKit
import Combine

struct AppScene: View {
    
    @EnvironmentObject var renderer:WebView
    
    var body: some View {
        HStack {
            VStack {
                TextEditor(text: $renderer.latexCode)
                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(30)
            }
            .frame(width: 500)
            .background(Color(red: 0.118, green: 0.118, blue: 0.118))
            VStack(alignment: .center) {
                Image(nsImage: renderer.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5)
                    .frame(height: 150)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 30))
                    .onDrag {
                        let fileURL = self.renderer.write()
                        let provider = NSItemProvider(contentsOf: fileURL)
                        return provider!
                    }
                Picker("Color Mode", selection: $renderer.colorMode) {
                    Text("Auto (Light/Dark)").tag(0)
                    Text("Auto (White/Black)").tag(1)
                    Text("White").tag(2)
                    Text("Light").tag(3)
                    Text("Dark").tag(4)
                    Text("Black").tag(5)
                }.frame(width: 250)
                Text("Export ⌘+E").foregroundColor(Color("FadedColor"))
                Text("or drag + drop").foregroundColor(Color("FadedColor"))
            }.frame(minWidth: 300)
        }.toolbar {
            ToolbarItem {
                Button {
                    self.renderer.generate()
                } label: {
                    Image(systemName: "play")
                }

            }
        }
    }
}

protocol AppSceneCommand {
    
}

struct AppScene_Previews: PreviewProvider {
    static var previews: some View {
        AppScene()
    }
}
