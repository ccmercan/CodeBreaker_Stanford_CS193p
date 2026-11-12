//
//  CodeBreakerApp.swift
//  CodeBreaker
//
//  Created by cag on 9/17/26.
//

import SwiftUI
import SwiftData

@main
struct CodeBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
                .modelContainer(for: CodeBreaker.self)
        }
    }
}
