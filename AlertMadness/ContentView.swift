//
//  ContentView.swift
//  AlertMadness
//
//  Created by Jason Ji on 3/28/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Combine
import SwiftUI

    class Model: ObservableObject {
        @Published var presentAlert = false
        @Published var count = 0
        
        var timerPublisher: AnyPublisher<Int, Never>?
        var cancellables = Set<AnyCancellable>()
        
        init() {
            timerPublisher = Timer.publish(every: 1.0, on: .main, in: .common)
                .autoconnect()
                .map { [unowned self] _ in self.count + 1 }
                .eraseToAnyPublisher()
        }
        
        func startTimer() {
            timerPublisher?
                .assign(to: \.count, on: self)
                .store(in: &cancellables)
        }
    }

    struct ContentView: View {
        @ObservedObject var model: Model
        
        var body: some View {
            VStack(spacing: 20.0) {
                VStack(alignment: .leading, spacing: 2.0) {
                    Text("This project shows two bugs related to SwiftUI code running in a Catalyst app around Alerts. For each bug, run the app as a Catalyst app on the Mac, and be sure to kill and restart the app before viewing each bug.").font(.system(.largeTitle))
                    Text("")
                    Text("Bug #1: UIKeyCommand action selector is repeatedly and infinitely invoked when the key command is pressed.").fontWeight(.bold)
                    Text("1. Press CMD+N to trigger a key command.")
                    Text("2. Observe that the alert is attempted to be presented over and over, and that the console log shows the postNewGame selector is being invoked over and over.")
                    Text("")
                    Text("Bug #2: When a timer is regularly updating the UI, and an alert is displayed, the system continually adds to the alert.").fontWeight(.bold)
                    Text("1. Press 'Start Timer' to begin a timer that updates a counter in the UI.")
                    Text("2. Press 'Show Alert' to attempt to display an alert.")
                    Text("3. Observe that the Alert shows initially correctly, but then each time the timer fires, the alert shows more and more duplicates of the buttons.")
                }
                
                VStack(spacing: 16) {
                    Text("Count: \(model.count)")
                    Button("Start Timer") {
                        self.model.startTimer()
                    }
                    Button("Show Alert") {
                        self.model.presentAlert.toggle()
                    }
                }
            }.padding()
            .alert(isPresented: $model.presentAlert) {
                Alert(title: Text("New Game"),
                      message: Text("Are you sure you want to start a new game? The current game will be recorded as a loss."),
                      primaryButton: Alert.Button.destructive(Text("New Game")) {
                        print("New Game selected")
                      },
                      secondaryButton: Alert.Button.cancel()
                )
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: Model())
    }
}
