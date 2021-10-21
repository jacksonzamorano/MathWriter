//
//  infinitexApp.swift
//  infinitex
//
//  Created by Jackson Zamorano on 10/17/21.
//

import SwiftUI

@main
struct MathWriterApp: App {
    
    @State var renderer = MathRenderer()
    @AppStorage("performanceMode") var performanceMode = 2
    
    var body: some Scene {
        WindowGroup {
            MathWriterView().environmentObject(renderer).userActivity("com.flare.mathwriter.launch", element: URL(string: "https://google.com")!) { url, activity in
                activity.title = "MathWriter"
                activity.addUserInfoEntries(from: ["math": renderer.latexCode, "colorMode": renderer.colorMode])
                activity.isEligibleForHandoff = true
                print("user activity issued")
            }
            .onContinueUserActivity("com.flare.mathwriter.launch") { activity in
                let math = activity.userInfo!["math"] as! String
                let color = activity.userInfo!["colorMode"] as! Int
                renderer.latexCode = math
                renderer.colorMode = color
            }
        }
    }

}
