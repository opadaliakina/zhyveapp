//
//  InfoController.swift
//  ZhyveApp
//
//  Created by Anton Charny on 8/19/20.
//  Copyright © 2020 NavekSoft. All rights reserved.
//

import UIKit

class InfoController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeButtonUI(closeButton)
        topViewUI()
        settingsButton.isHidden = !UIDevice.isHapticsSupported
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    func topViewUI() {
        topView.backgroundColor = UIColor.white
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowRadius = 10
        topView.layer.shadowOpacity = 0.1
        topView.layer.cornerRadius = 32
        topView.layer.shadowOffset = CGSize(width: 4, height: 4)
    }
}
