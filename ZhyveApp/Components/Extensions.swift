//
//  Extensions.swift
//  ZhyveApp
//
//  Created by Anton Charny on 8/15/20.
//  Copyright © 2020 NavekSoft. All rights reserved.
//

import Foundation
import UIKit
import CoreHaptics

public extension UIViewController {
    
    func makeButtonUI(_ button: UIButton) {
        button.backgroundColor = UIColor.white
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.1
        button.layer.cornerRadius = 22
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
    }
}

public extension UIDevice {
    
    static func vibrate() {
        if UserSettings.allowVibration() && isHapticsSupported {
            if #available(iOS 10.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .light)
                if #available(iOS 13.0, *) {
                    generator.impactOccurred(intensity: 1)
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
    
    static var modelIdentifier: String {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    static var isHapticsSupported : Bool {
        if #available(iOS 13.0, *) {
            let hapticCapability = CHHapticEngine.capabilitiesForHardware()
            let supportsHaptics = hapticCapability.supportsHaptics
            return supportsHaptics
        } else {
            // assuming that iPads and iPods don't have a Taptic Engine
            if !modelIdentifier.contains("iPhone") {
                return false
            }
            
            // e.g. will equal to "9,5" for "iPhone9,5"
            let subString = String(modelIdentifier[modelIdentifier.index(modelIdentifier.startIndex, offsetBy: 6)..<modelIdentifier.endIndex])
            
            // will return true if the generationNumber is equal to or greater than 9
            if let generationNumberString = subString.components(separatedBy: ",").first,
                let generationNumber = Int(generationNumberString),
                generationNumber >= 9 {
                return true
            }
            return false
        }
    }
}

public func isSmallIPhone() -> Bool {
    switch UIScreen.main.nativeBounds.height {
    case 1136:
        return true
    default:
        return false
    }
}

public func isIphone6() -> Bool {
    switch UIScreen.main.nativeBounds.height {
    case 1334:
        return true
    default:
        return false
    }
}
