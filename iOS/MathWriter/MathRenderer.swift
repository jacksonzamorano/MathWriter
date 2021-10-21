import SwiftUI
import WebKit

class MathRenderer: NSObject, ObservableObject, WKNavigationDelegate {
    
    let webView = WKWebView()
    @AppStorage("renderScale") var renderScale: Double = 1.0
    @AppStorage("latexCode") var latexCode: String = ""
    @Published var image:UIImage = UIImage(named: "Icon Simple")!
    @Published var imageH: Int = 0
    @Published var imageW: Int = 0
    @AppStorage("colorMode") var colorMode: Int = 0

    override init() {
        super.init()
        self.webView.navigationDelegate = self
        self.webView.frame = CGRect(x: 0, y: 0, width: 10000, height: 10000)
        if latexCode != "" && latexCode != " " {
            self.generate()
        }
    }
    
    public func generate() {
        if latexCode != "" && latexCode != " " {
            webView.loadHTMLString(MathRenderRepresentation(withContents: latexCode).html(colorMode: colorMode, scaleMode: renderScale), baseURL: URL(string: "http://test.com")!)
        } else {
            image = UIImage(named: "Icon Simple")!
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(MathRenderRepresentation.evalCode) { res, error in
            let data = res as! [NSNumber]

            let width = Int(truncating: data[0])
            let height = Int(truncating: data[1])
            
            self.imageW = width
            self.imageH = height
            
            let snapshotConfig = WKSnapshotConfiguration()
            snapshotConfig.rect = CGRect(x: 0, y: 0, width: width, height: height)
            webView.takeSnapshot(with: snapshotConfig) { img, error in
                self.image = img!
            }
        }
    }
    
    public func write() -> URL {
        let fileUrl = FileManager.default.temporaryDirectory.appendingPathComponent("output.png")
        let data = self.image.pngData()!
        try! data.write(to: fileUrl)
        return fileUrl
    }
    
}

