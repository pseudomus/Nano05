//
//  InvationSharePlayView.swift
//  Nano05
//
//  Created by Gustavo Horestee Santos Barros on 27/02/24.
//

import UIKit
import SwiftUI
import GroupActivities

struct ActivitySharingViewController: UIViewControllerRepresentable {
    let activity: GroupActivity

    func makeUIViewController(context: Context) -> GroupActivitySharingController {
        return try! GroupActivitySharingController(activity)
    }

    func updateUIViewController(_ uiViewController: GroupActivitySharingController, context: Context) { }
}
