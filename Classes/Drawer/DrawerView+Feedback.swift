//
//  BKDrawerView+Feedback.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 02/07/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

extension DrawerView {

    func launchFeedback() {
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
        }
    }
}
