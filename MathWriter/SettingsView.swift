import SwiftUI

public struct SettingsView: View {
    
    @AppStorage("performanceMode") var performanceMode = 2
    @AppStorage("performanceMessagesSuppresed") var messageSuppressed = false
    
    let prefPadding = EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40)
    
    var isAppleSilion: Bool {
        get {
            var systemInfo = utsname()
            uname(&systemInfo)
            let modelCode = withUnsafePointer(to: &systemInfo.machine) {
                $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                    ptr in String.init(validatingUTF8: ptr)
                }
            }
            return modelCode == "arm64"
        }
    }
    
    public var body: some View {
        TabView {
            VStack {
                VStack(alignment: .leading) {
                    Text("MathWriter works by generating images using your Mac's native WebKit engine. While it is power efficient, generating images quickly can have an effect on power consumption. You can adjust these settings here.")
                        .foregroundColor(Color("FadedColor"))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                if isAppleSilion {
                    HStack {
                        Image(systemName: "cpu")
                        Text("You're on a Apple Silicon Mac. All options are very efficient.")
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
                Picker(selection: $performanceMode, label: Text("Performance Mode")) {
                    Text("Low Power")
                        .tag(0)
                    Text("Efficient")
                        .tag(1)
                    Text("Balanced")
                        .tag(2)
                    Text("Performant")
                        .tag(3)
                }
                VStack(alignment: .leading, spacing: 5) {
                    PerformanceModeExplanationView(title: "Low Power", copy: "will never auto-generate images. You will have to manually generate images using the shortcut ⌘ + ⮐ or using the play button.")
                    PerformanceModeExplanationView(title: "Efficient", copy: "will auto-generate images slower than balanced. Recommended to get the very most out of your battery.")
                    PerformanceModeExplanationView(title: "Balanced", copy: "offers a trade-off between efficient and performant. Recommended for most users.")
                    PerformanceModeExplanationView(title: "Performant", copy: "will constantly generate images with almost zero delay. Recommended for desktops or users requiring a near-instant refresh.")
                }
                HStack {
                    Toggle("Hide performance messages", isOn: $messageSuppressed)
                }
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
            }
            .padding(prefPadding)
            .tabItem {
                Image(systemName: "bolt.circle")
                Text("Performance")
            }
        }
        .frame(width: 500)
            .navigationTitle("Preferences")
    }
    
}

public struct PerformanceModeExplanationView: View {
    
    public var title: String
    public var copy: String
    
    public var body: some View {
        HStack(alignment: .top, spacing: 1) {
            Text(title)
                .fontWeight(.bold)
                .frame(width: 120, alignment: .leading)
            Text(copy)
                .fixedSize(horizontal: false, vertical: true)
        }.foregroundColor(Color("FadedColor"))
    }
}
