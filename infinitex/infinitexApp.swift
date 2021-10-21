//
//  infinitexApp.swift
//  infinitex
//
//  Created by Jackson Zamorano on 10/17/21.
//

import SwiftUI

@main
struct infinitexApp: App {
    
    @State var renderer = WebView()
    
    var body: some Scene {
        WindowGroup {
            AppScene().environmentObject(renderer)
        }.commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem) {
                Button("New Text") {
                    renderer.latexCode = ""
                }.keyboardShortcut("n")
                Button("Generate") {
                    renderer.generate()
                }.keyboardShortcut(.init(.return, modifiers: .command))
                Button("Open") {
                    renderer.generate()
                    let url = renderer.write()
                    NSWorkspace.shared.open(url)
                }
                .keyboardShortcut("o")
                Button("Export") {
                    let sourceURL = renderer.write()
                    let panel = NSSavePanel()
                    panel.canCreateDirectories = true
                    panel.allowedFileTypes = ["png"]
                    panel.begin { res in
                        if res.rawValue == NSApplication.ModalResponse.OK.rawValue {
                            let destURL = panel.url!
                            try! FileManager.default.copyItem(at: sourceURL, to: destURL)
                        } else {
                            print("save canceled")
                        }
                    }
                }.keyboardShortcut("e")
            }
            CommandGroup(replacing: .textFormatting) {
                Button {
                    self.renderer.colorMode = 0
                } label: {
                    Text("Auto (Light/Dark)")
                }
                .keyboardShortcut("1")
                Button {
                    self.renderer.colorMode = 1
                } label: {
                    Text("Auto (White/Black)")
                }
                .keyboardShortcut("2")
                Button {
                    self.renderer.colorMode = 2
                } label: {
                    Text("White")
                }
                .keyboardShortcut("3")
                Button {
                    self.renderer.colorMode = 3
                } label: {
                    Text("Light")
                }
                .keyboardShortcut("4")
                Button {
                    self.renderer.colorMode = 4
                } label: {
                    Text("Dark")
                }
                .keyboardShortcut("5")
                Button {
                    self.renderer.colorMode = 5
                } label: {
                    Text("Black")
                }
                .keyboardShortcut("6")
            }
        }
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle(showsTitle: false))
    }
}
