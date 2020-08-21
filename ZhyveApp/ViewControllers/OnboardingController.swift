//
//  OnboardingController.swift
//  ZhyveApp
//
//  Created by Anton Charny on 8/21/20.
//  Copyright © 2020 NavekSoft. All rights reserved.
//

import UIKit
import AVFoundation



class OnboardingController: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        if let mainController = sb.instantiateViewController(withIdentifier: "firstController") as? ViewController {
            mainController.modalPresentationStyle = .fullScreen
            self.present(mainController, animated: true, completion: nil)
        }
    }
}
