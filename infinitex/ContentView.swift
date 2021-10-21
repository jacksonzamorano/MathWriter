import SwiftUI
import WebKit
import Combine

struct AppScene: View {
    
    @State var latexCode: String = "\\infty"
    @State var htmlString: String = "<h1>Test</h1>"
    @ObservedObject var renderer = WebView()
    
    var body: some View {
        HStack {
            VStack {
                TextField("LaTeX", text: $latexCode)
                Button("Generate") {
                    htmlString = RenderObject(withContents: latexCode).html()
                    renderer.generate(htmlString: latexCode)
                }
            }.frame(maxWidth: 300, minHeight: 500)
            Image(nsImage: renderer.image)
        }
    }
}

struct AppScene_Previews: PreviewProvider {
    static var previews: some View {
        AppScene()
    }
}
