//
//  ViewController.swift
//  ZhyveApp
//
//  Created by Olga Podoliakina on 8/15/20.
//  Copyright © 2020 NavekSoft. All rights reserved.
//

import UIKit
import AVFoundation

enum ScopeType {
    case liveBelarus
    case changes
}

public struct Timing {
    var time = Double()
    var state = Bool()
}

class ViewController: UIViewController {
    
    @IBOutlet weak var phoneButtton: UIButton!
    @IBOutlet weak var burgerButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var overlay: UIView!
    
    var currentType: ScopeType = .liveBelarus
    var flashOn = false {
        didSet {
            lightButton.setTitle(flashOn ? "Спынiць!" : "Святло!", for: .normal)
            if !flashOn {
                counter = -1
                flash(on: false, forTime: 0, completion: nil) // выключает все
            }
        }
    }
    var counter: Int = 0
    var systemBrightness = CGFloat()
    
    let liveBelarusTiming: [Timing] = [
        Timing(time: 0.3, state: false),
        Timing(time: 0.5, state: true),
        Timing(time: 0.1, state: false),
        Timing(time: 0.45, state: true),
        Timing(time: 0.200, state: false),
        Timing(time: 0.25, state: true),
        Timing(time: 0.1, state: false),
        Timing(time: 0.3, state: true),
        Timing(time: 0.1, state: false),
        Timing(time: 0.6, state: true),
    ]
    
    let changesTiming: [Timing] = [
        Timing(time: 0, state: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeView.addGestureRecognizer(swipeRight)
        let overlayTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(overlayTap))
        overlay.addGestureRecognizer(overlayTapRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        makeButtonUI(phoneButtton)
        makeButtonUI(burgerButton)
        makeButtonUI(lightButton)
        mainLabelTextAligment()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print(mainTextLabel.textAlignment.rawValue)
        coordinator.animateAlongsideTransition(in: self.view, animation: { [weak self] (context) in
            guard let self = self else {return}
            self.mainLabelTextAligment()
            
        }) { (completionContext) in
            print(self.mainTextLabel.textAlignment.rawValue)
        }
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
        view.backgroundColor = currentType == .liveBelarus ? .white : .redBack
        mainTextLabel.text = currentType == .liveBelarus ? "Жыве Беларусь!" : "Перамен!"
        mainTextLabel.textColor = currentType == .liveBelarus ? .blackText : .white
        phoneButtton.backgroundColor = currentType == .liveBelarus ? .white : .redBack
        burgerButton.backgroundColor = currentType == .liveBelarus ? .white : .redBack
        lightButton.backgroundColor = currentType == .liveBelarus ? .white : .redBack
        lightButton.titleLabel?.textColor = currentType == .liveBelarus ? .blackText : .white
        phoneButtton.setImage(UIImage.init(named: currentType == .liveBelarus ? "phone_white" : "phone_red"), for: .normal)
        burgerButton.setImage(UIImage.init(named: currentType == .liveBelarus ? "burger_white" : "burger_red"), for: .normal)
    }
    
    func hideTopButtons(_ hide: Bool, delay: TimeInterval = 0) {
        UIView.animate(withDuration: 0.3, delay: delay, options: [.allowUserInteraction,.curveEaseInOut], animations: {
            self.burgerButton.alpha = hide ? 0 : 1
            self.phoneButtton.alpha = hide ? 0 : 1
        }) { (completed) in
            
        }
    }
    
    func mainLabelTextAligment() {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft,.landscapeRight:
            self.mainTextLabel.textAlignment = .center
        case .portrait, .portraitUpsideDown,.unknown:
            self.mainTextLabel.textAlignment = .left
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        flashOn = false
        if currentType == .liveBelarus {
            currentType = .changes
        } else {
            currentType = .liveBelarus
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.changeUI()
        }) { (completed) in
            
        }
    
    }
    
    @objc func overlayTap() {
        burgerButton.alpha == 1 ? hideTopButtons(true) : hideTopButtons(false)
    }
    
    // MARK: -
    
    @IBAction func phoneAction(_ sender: Any?) {
        flashOn = false
        if overlay.isHidden {
            systemBrightness = UIScreen.main.brightness
            UIView.animate(withDuration: 0.5, animations: {
                self.phoneButtton.backgroundColor = .white
                self.burgerButton.backgroundColor = .white
                self.overlay.isHidden = false
                self.overlay.alpha = 1
                self.phoneButtton.setImage(UIImage.init(named: "light"), for: .normal)
                self.burgerButton.setImage(UIImage.init(named: "burger_white"), for: .normal)
            }) { (completed) in
                UIScreen.main.brightness = CGFloat(1)
                self.hideTopButtons(true, delay: 0.5)
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.overlay.alpha = 0
                self.phoneButtton.setImage(UIImage.init(named: self.currentType == .liveBelarus ? "phone_white" : "phone_red"), for: .normal)
                self.burgerButton.setImage(UIImage.init(named: self.currentType == .liveBelarus ? "burger_white" : "burger_red"), for: .normal)
                self.phoneButtton.backgroundColor = self.currentType == .liveBelarus ? .white : .redBack
                self.burgerButton.backgroundColor = self.currentType == .liveBelarus ? .white : .redBack
            }) { (completed) in
                self.overlay.isHidden = true
                UIScreen.main.brightness = self.systemBrightness
                self.hideTopButtons(false, delay: 0.5)
            }
        }
        
    }
    
    @IBAction func lightAction(_ sender: Any) {
        flashOn.toggle()
        counter = 0
        recursionFlash()
    }
    
    private func recursionFlash() {
        if flashOn, counter >= 0 {
            let timing = self.currentType == .liveBelarus ? liveBelarusTiming : changesTiming
            self.flash(on: timing[counter].state, forTime: timing[counter].time) {
                if self.counter == timing.count - 1 {
                    self.counter = 0
                } else {
                    self.counter += 1
                }
                self.recursionFlash()
            }
        }
    }
    
    // MARK: - Flash
    
    private func flash(on: Bool, forTime seconds: Double, completion: (() -> Void)?) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            if on {
                UIDevice.vibrate()
            }
            device.unlockForConfiguration()
            delay(bySeconds: seconds) {
                completion?()
            }
        } catch {
            print("Torch could not be on")
        }
    }
    
    
    public func delay(bySeconds seconds: Double, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: closure)
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
