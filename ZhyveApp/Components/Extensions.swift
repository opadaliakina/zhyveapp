//
//  Extensions.swift
//  ZhyveApp
//
//  Created by Anton Charny on 8/15/20.
//  Copyright © 2020 NavekSoft. All rights reserved.
//

import Foundation
import UIKit


public extension UIDevice {
    
    static func vibrate() {
        if UserSettings.allowVibration() && isHapticsSupported {
            if #available(iOS 10.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .light)
                if #available(iOS 13.0, *) {
                    generator.impactOccurred(intensity: 0.7)
                } else {
                    // for ios 12 and lower
                    generator.impactOccurred()
                }
            }
        }
    }
    
    static func selectionVibrate() {
        if UserSettings.allowVibration() && isHapticsSupported {
            if #available(iOS 10.0, *) {
                let generator = UISelectionFeedbackGenerator()
                generator.prepare()
                generator.selectionChanged()
            }
        }
    }
    
    static func warningVibration() {
        if UserSettings.allowVibration() && isHapticsSupported {
            if #available(iOS 10.0, *) {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            }
        }
    }
    
    static func successVibration() {
        if UserSettings.allowVibration() && isHapticsSupported {
            if #available(iOS 10.0, *) {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        }
    }
    
    static var isHapticsSupported : Bool {
        if #available(iOS 10.0, *) {
            let feedback = UIImpactFeedbackGenerator(style: .heavy)
            feedback.prepare()
            return feedback.description.hasSuffix("Heavy>")
        } else {
            return false
        }
    }
}
