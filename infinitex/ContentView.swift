import SwiftUI
import WebKit
import Combine

struct AppScene: View {
    
    @EnvironmentObject var renderer:WebView
    @State var workItem: DispatchWorkItem?
    @AppStorage("performanceMode") var performanceMode = 0
    @AppStorage("performanceMessagesSuppresed") var messageSuppressed = false
    
    @State var status = 0
    
    var body: some View {
        HStack {
            VStack {
                if performanceMode == 3 && !messageSuppressed {
                    AlertView(imageName: "bolt.slash", copy: "You're in performant mode, battery life may be shorter.")
                } else if performanceMode == 0 && !messageSuppressed {
                    AlertView(imageName: "play.slash", copy: "You're in low-power mode, use ⌘ + ⮐ to preview.")
                }
                TextEditor(text: $renderer.latexCode)
                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            }.frame(minWidth: 600)
        }
        .onChange(of: renderer.latexCode, perform: { _ in
            if let wi = workItem { wi.cancel(); workItem = nil }
            if performanceMode > 0 {
                status = 2
                workItem = DispatchWorkItem(block: {
                    status = 1
                    self.renderer.generate()
                    status = 0
                })
                DispatchQueue.main.asyncAfter(deadline: RefreshInterval.forPerformanceMode(mode: performanceMode), execute: workItem!)
            }
        })
        .onChange(of: renderer.image, perform: { _ in
            status = 0
        })
        .onChange(of: renderer.colorMode, perform: { _ in
            self.renderer.generate()
        })
        .toolbar {
            ToolbarItem() {
                Button {
                    self.renderer.generate()
                    self.status = 1
                } label: {
                    Image(systemName: "play")
                }
            }
            ToolbarItem() {
                Button {
                    let sourceURL = renderer.write()
                    let panel = NSSavePanel()
                    panel.canCreateDirectories = true
                    panel.allowedFileTypes = ["png"]
                    panel.begin { res in
                        if res.rawValue == NSApplication.ModalResponse.OK.rawValue {
                            let destURL = panel.url!
                            try! FileManager.default.copyItem(at: sourceURL, to: destURL)
                        }
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            ToolbarItem {
                HStack {
                    if performanceMode == 0 {
                        Image(systemName: "play.slash")
                        Text("Low-power mode is on.")
                    } else {
                        if status > 0 {
                            ProgressView()
                                .scaleEffect(0.5, anchor: .center)
                            Text(status == 1 ? "Rendering..." : "Waiting...")
                        } else {
                            Image(systemName: "checkmark.seal")
                            Text("Up to date.")
                        }
                    }
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            }
        }
        
    }
}

protocol AppSceneCommand {
    
}

struct AppScene_Previews: PreviewProvider {
    static var previews: some View {
        AppScene().environmentObject(WebView())
    }
}

struct AlertView: View {
    
    var imageName: String
    var copy: String
    
    @AppStorage("performanceMessagesSuppresed") var messageSuppressed = false
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(copy)
            Spacer()
            Button("Hide", action: {
                messageSuppressed = true
            })
        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .background(Color.accentColor).frame(maxWidth: .infinity)
    }
}
