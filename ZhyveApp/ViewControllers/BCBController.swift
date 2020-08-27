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
        perform(#selector(hideTopButtons), with: nil, afterDelay: 0.5)
    }
    
    @objc func overlayTap() {
        if burgerButton.isHidden {
            burgerButton.isHidden = false
            lightButton.isHidden = false
            perform(#selector(hideTopButtons), with: nil, afterDelay: 2)
        }
    }
    
    @objc func hideTopButtons() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction,.curveEaseInOut], animations: {
            self.burgerButton.isHidden = true
            self.lightButton.isHidden = true
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
