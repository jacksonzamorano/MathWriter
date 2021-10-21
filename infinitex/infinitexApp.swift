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
                Button("Generate") {
                    renderer.generate()
                }.keyboardShortcut(.init(.return, modifiers: .command))
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
                EmptyView()
            }
        }
    }
}
