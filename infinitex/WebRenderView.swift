import SwiftUI
import WebKit

class WebView: NSObject, ObservableObject, WKNavigationDelegate {
    
    let webView = WKWebView()
    @Published var latexCode: String = ""
    @Published var image:NSImage = NSImage(named: "Icon Simple")!
    @AppStorage("colorMode") var colorMode: Int = 0
    
    override init() {
        super.init()
        self.webView.navigationDelegate = self
        self.webView.frame = CGRect(x: 0, y: 0, width: 10000, height: 10000)
    }
    
    public func generate() {
        if latexCode != "" && latexCode != " " {
            webView.loadHTMLString(RenderObject(withContents: latexCode).html(colorMode: colorMode), baseURL: URL(string: "http://test.com")!)
        } else {
            image = NSImage(named: "Icon Simple")!
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finished navigation")
        webView.evaluateJavaScript(RenderObject.evalCode) { res, error in
            let data = res as! [NSNumber]

            let width = Int(truncating: data[0])
            let height = Int(truncating: data[1])
            
            let snapshotConfig = WKSnapshotConfiguration()
            snapshotConfig.rect = CGRect(x: 0, y: 0, width: width, height: height)
            webView.takeSnapshot(with: snapshotConfig) { img, error in
                self.image = img!
            }
        }
    }
    
    public func write() -> URL {
        let fileUrl = FileManager.default.temporaryDirectory.appendingPathComponent("output.png")
        let data = self.image.tiffRepresentation!
        let pngData = NSBitmapImageRep(data: data)?.representation(using: .png, properties: [:])
        try! pngData?.write(to: fileUrl)
        return fileUrl
    }
    
}

