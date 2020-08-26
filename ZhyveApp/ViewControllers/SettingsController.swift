//
//  SettingsController.swift
//  ZhyveApp
//
//  Created by Anton Charny on 8/19/20.
//  Copyright © 2020 NavekSoft. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vibrationSwitch.isOn = UserSettings.allowVibration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeButtonUI(backButton)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func switchVibration(_ sender: UISwitch) {
        UserSettings.setAllowVibration(sender.isOn)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonVibrationAction(_ sender: UIButton) {
        let state = vibrationSwitch.isOn
        switchVibrate()
        vibrationSwitch.setOn(!state, animated: true)
        UserSettings.setAllowVibration(vibrationSwitch.isOn)
    }
    
    private func switchVibrate() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
}
