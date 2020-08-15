//
//  ViewController.swift
//  ZhyveApp
//
//  Created by Olga Podoliakina on 8/15/20.
//  Copyright © 2020 NavekSoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pageViewContainer: UIView!
    @IBOutlet weak var phoneButtton: UIButton!
    @IBOutlet weak var burgerButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    
    private var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var currentType: ScopeType = .changes

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController.willMove(toParent: self)
        pageViewContainer.addSubview(pageController.view)
        pageController.view.frame = pageViewContainer.bounds
        pageController.didMove(toParent: self)
        
        pageController.dataSource = self
        pageController.delegate = self
        
        pageController.setViewControllers([pageControllerContent(nil)], direction: .forward, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        makeButtonUI(phoneButtton)
        makeButtonUI(burgerButton)
        makeButtonUI(lightButton)
    }
    
    func bottomButonUI() {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: lightButton.bounds,
        byRoundingCorners: [.topLeft , .topRight],
            cornerRadii: CGSize(width: 22, height: 22)).cgPath
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 4)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 10
        lightButton.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func makeButtonUI(_ button: UIButton) {
        button.backgroundColor = UIColor.white
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.1
        button.layer.cornerRadius = 22
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
    }
    
    func changeUI() {
        phoneButtton.backgroundColor = currentType == .liveBelarus ? .white : .redBack
        burgerButton.backgroundColor = currentType == .liveBelarus ? .white : .redBack
        lightButton.backgroundColor = currentType == .liveBelarus ? .white : .redBack
        lightButton.titleLabel?.textColor = currentType == .liveBelarus ? .blackText : .white
        phoneButtton.setImage(UIImage.init(named: currentType == .liveBelarus ? "phone_white" : "phone_red"), for: .normal)
        burgerButton.setImage(UIImage.init(named: currentType == .liveBelarus ? "burger_white" : "burger_red"), for: .normal)
    }
    
    private func pageControllerContent(_ previous: PageContent?) -> PageContent {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PageContent") as? PageContent
        if previous?.scopeType ?? .changes == .liveBelarus {
            vc?.scopeType = .changes
        } else {
            vc?.scopeType = .liveBelarus
        }
        return vc!
    }

}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? PageContent else {
            return nil
        }
        return pageControllerContent(vc)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? PageContent else {
            return nil
        }
        return pageControllerContent(vc)
    }
    
    
}

extension ViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewControllers = pageViewController.viewControllers as? [PageContent] {
            currentType = viewControllers.first?.scopeType ?? .liveBelarus
        }
        
        if finished && completed {
            changeUI()
        }
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
}
