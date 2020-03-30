//
//  KeyCommandHostingController.swift
//  Freecell
//
//  Created by Jason Ji on 12/31/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

class KeyCommandHostingController<Content: View>: UIHostingController<Content> {
    override var keyCommands: [UIKeyCommand]? {
        [
            UIKeyCommand(title: "New Game", action: #selector(postNewGame), input: "n", modifierFlags: .command)
        ]
    }
    
    @objc func postNewGame() {
        print("postNewGame called")
        NotificationCenter.default.post(name: .newGameRequested, object: nil)
    }
    
}

public extension Notification.Name {
   static let newGameRequested = Notification.Name(rawValue: "newGameRequested")
}
