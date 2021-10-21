import SwiftUI
import WebKit
import Combine

struct MathWriterView: View {
    
    @EnvironmentObject var renderer:MathRenderer
    @State var workItem: DispatchWorkItem?
    @AppStorage("performanceMessagesSuppresed") var messageSuppressed = false
    
    @State var status = 0
    
    var body: some View {
        HStack {
            VStack {
                if ProcessInfo.processInfo.isLowPowerModeEnabled == true {
                    AlertView(imageName: "play.slash", copy: "You're in low-power mode, use ⌘ + ⮐ to preview.")
                }
                TextEditor(text: $renderer.latexCode)
                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color(red: 0.118, green: 0.118, blue: 0.118))
            VStack(alignment: .center) {
                PreviewHeaderView()
                Spacer()
                Image(uiImage: renderer.image)
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
                Spacer()
            }.frame(minWidth: 700)
        }
        .padding(EdgeInsets(top: 50, leading: 0, bottom: 50, trailing: 0))
        .background(Color("PreviewBackgroundColor"))
        .ignoresSafeArea()
        .onChange(of: renderer.latexCode, perform: { _ in
            if let wi = workItem { wi.cancel(); workItem = nil }
            if ProcessInfo.processInfo.isLowPowerModeEnabled == false {
                status = 2
                workItem = DispatchWorkItem(block: {
                    status = 1
                    self.renderer.generate()
                    status = 0
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem!)
            }
        })
        .onChange(of: renderer.renderScale, perform: { _ in
            if ProcessInfo.processInfo.isLowPowerModeEnabled == false {
                self.renderer.generate()
            }
        })
        .onChange(of: renderer.image, perform: { _ in
            status = 0
        })
        .onChange(of: renderer.colorMode, perform: { _ in
            self.renderer.generate()
        })
    }
}

struct AppScene_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            MathWriterView()
                .environmentObject(MathRenderer())
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
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
        }
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .background(Color.accentColor).frame(maxWidth: .infinity)
    }
}
