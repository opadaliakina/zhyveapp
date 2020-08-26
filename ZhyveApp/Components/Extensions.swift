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

public func isIphone6() -> Bool {
    switch UIScreen.main.nativeBounds.height {
    case 1334:
        return true
    default:
        return false
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, alpha: Float = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
    
    convenience init(hex: Int, alpha: Float = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            alpha: alpha
        )
    }
    
    static var redBack: UIColor { return UIColor(hex: 0xE71E1E) }
    
    static var blackText: UIColor { return UIColor(hex: 0x1C1C1C) }
    
    static var greyText: UIColor { return UIColor(hex: 0x686868) }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
