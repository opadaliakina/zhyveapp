//
//  BCBController.swift
//  ZhyveApp
//
//  Created by Olga Podoliakina on 8/26/20.
//  Copyright © 2020 NavekSoft. All rights reserved.
//

import UIKit

class BCBController: UIViewController {
    
    @IBOutlet weak var burgerButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    
    var systemBrightness = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()

        let overlayTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(overlayTap))
        view.addGestureRecognizer(overlayTapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        makeButtonUI(burgerButton)
        makeButtonUI(lightButton)
        
        systemBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = CGFloat(1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideTopButtons(true, delay: 0.5)
    }
    
    @objc func overlayTap() {
        burgerButton.alpha == 1 ? hideTopButtons(true) : hideTopButtons(false)
    }
    
    func hideTopButtons(_ hide: Bool, delay: TimeInterval = 0) {
        UIView.animate(withDuration: 0.3, delay: delay, options: [.allowUserInteraction,.curveEaseInOut], animations: {
            self.burgerButton.alpha = hide ? 0 : 1
            self.lightButton.alpha = hide ? 0 : 1
        }) { (completed) in
            
        }
    }
    
    @IBAction func lightAction(_ sender: Any?) {
        UIScreen.main.brightness = self.systemBrightness
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
