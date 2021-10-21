import SwiftUI
import WebKit
import Combine

struct AppScene: View {
    
    @State var latexCode: String = "\\infty"
    @State var htmlString: String = "<h1>Test</h1>"
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
                    .frame(height: 150)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                    .onDrag {
                        let fileURL = self.renderer.write()
                        let provider = NSItemProvider(contentsOf: fileURL)
                        return provider!
                    }
                Picker("Color Mode", selection: $renderer.colorMode) {
                    Text("Auto").tag(0)
                    Text("Light").tag(1)
                    Text("Dark").tag(2)
                }.frame(width: 200)
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
