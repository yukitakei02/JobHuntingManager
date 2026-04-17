//
//  JobHuntingManagerApp.swift
//  JobHuntingManager
//
//  Created by 竹井佑騎 on 2026/04/17.
//

import SwiftUI
import SwiftData

@main
struct JobHuntingManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Company.self) // 倉庫の準備完了
    }
}
