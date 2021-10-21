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
                TextField("LaTeX", text: $renderer.latexCode).textFieldStyle(PlainTextFieldStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Button("Generate") {
                    renderer.generate()
                }
                
            }.padding(EdgeInsets(top: 50, leading: 30, bottom: 50, trailing: 30)).frame(width: 500, height: 200)
            VStack(alignment: .center) {
                Image(nsImage: renderer.image).onDrag {
                    let fileURL = self.renderer.write()
                    let provider = NSItemProvider(contentsOf: fileURL)
                    return provider!
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                Picker("Color Mode", selection: $renderer.colorMode) {
                    Text("Auto").tag(0)
                    Text("Light").tag(1)
                    Text("Dark").tag(2)
                }.frame(width: 200)
                Text("Export ⌘+E").foregroundColor(Color("FadedColor"))
                Text("or drag + drop").foregroundColor(Color("FadedColor"))
            }.frame(width: 300)
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
