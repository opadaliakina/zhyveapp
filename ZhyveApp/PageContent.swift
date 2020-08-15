//
//  PageContent.swift
//  ZhyveApp
//
//  Created by Olga Podoliakina on 8/15/20.
//  Copyright © 2020 NavekSoft. All rights reserved.
//

import UIKit

enum ScopeType {
    case liveBelarus
    case changes
}

class PageContent: UIViewController {
    
    @IBOutlet weak var mainTextLabel: UILabel!
    
    public var scopeType: ScopeType = .liveBelarus

    override func viewDidLoad() {
        super.viewDidLoad()

        if scopeType == .liveBelarus {
            view.backgroundColor = .white
            mainTextLabel.text = "Жыве Беларусь!"
            mainTextLabel.textColor = .blackText
        } else {
            view.backgroundColor = .redBack
            mainTextLabel.text = "Перамен!"
            mainTextLabel.textColor = .white
        }
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
