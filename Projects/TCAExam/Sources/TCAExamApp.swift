import SwiftUI
import ComposableArchitecture

@main
struct TCAExamApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(initialState: AppReducer.State()) {
                    AppReducer()
                        ._printChanges()
                }
            )
        }
    }
}
