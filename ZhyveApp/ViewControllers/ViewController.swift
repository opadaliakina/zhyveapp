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
    var time: Double?
    var state: Bool?
    var range: NSRange?
}

class ViewController: UIViewController {
    
    @IBOutlet weak var phoneButtton: UIButton!
    @IBOutlet weak var burgerButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var overlay: UIView!
    
    @IBOutlet weak var mainLabelBottomConstraint: NSLayoutConstraint!
    
    var spinner: SpinnerView?
    
    var currentType: ScopeType = .liveBelarus
    var flashOn = false {
        didSet {
            lightButton.setTitle(flashOn ? "Спынiць!" : "Святло!", for: .normal)
            if !flashOn {
                counter = -1
                textCounter = -1
                flash(on: false, forTime: 0, completion: nil) // выключает все
                flashText(NSRange(location: 0, length: 0), forTime: 0, completion: nil)
                loopTimer?.invalidate()
                fullCycleTimer?.invalidate()
            }
        }
    }
    var counter: Int = 0
    var textCounter: Int = 0
    
    var fullCycleTimer: Timer? = Timer()
    var loopTimer: Timer? = Timer()
    
    var systemBrightness = CGFloat()
    
    let liveBelarusTiming: [Timing] = [
        Timing(time: 0.35, state: true, range: NSRange(location: 0, length: 2)),
        Timing(time: 0.075, state: false, range: NSRange(location: 0, length: 0)),
        Timing(time: 0.3, state: true, range: NSRange(location: 2, length: 2)),
        Timing(time: 0.2, state: false, range: NSRange(location: 0, length: 0)),
        Timing(time: 0.15, state: true, range: NSRange(location: 5, length: 2)),
        Timing(time: 0.075, state: false, range: NSRange(location: 0, length: 0)),
        Timing(time: 0.15, state: true, range: NSRange(location: 7, length: 2)),
        Timing(time: 0.075, state: false, range: NSRange(location: 0, length: 0)),
        Timing(time: 0.15, state: true, range: NSRange(location: 9, length: 5)),
        Timing(time: 0.075, state: false, range: NSRange(location: 0, length: 0))
    ]
    
//    let textLiveTiming: [Timing] = [
//        Timing(time: 0.3, range: NSRange(location: 0, length: 2)), // ЖЫ
//        Timing(time: 0.2, range: NSRange(location: 0, length: 0)), // выкл
//        Timing(time: 0.35, range: NSRange(location: 2, length: 2)), // ВЕ
//        Timing(time: 0.25, range: NSRange(location: 0, length: 0)), // выкл
//        Timing(time: 0.15, range: NSRange(location: 5, length: 2)), // _БЕ
//        Timing(time: 0.05, range: NSRange(location: 0, length: 0)), // выкл
//        Timing(time: 0.15, range: NSRange(location: 7, length: 2)), // ЛА
//        Timing(time: 0.05, range: NSRange(location: 0, length: 0)), // выкл
//        Timing(time: 0.2, range: NSRange(location: 9, length: 5)), // РУСЬ!
//        Timing(time: 0.2, range: NSRange(location: 0, length: 0)) // выкл
//    ]
    
    let textChangeTiming: [Timing] = [
        Timing(time: 0, range: NSRange(location: 0, length: 0))]
    
    let changesTiming: [Timing] = [
        Timing(time: 0, state: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        //        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        //        swipeView.addGestureRecognizer(swipeRight)
        let overlayTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(overlayTap))
        overlay.addGestureRecognizer(overlayTapRecognizer)
        if isSmallIPhone() {
            mainLabelBottomConstraint.constant = 50
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        makeButtonUI(phoneButtton)
        makeButtonUI(burgerButton)
        makeButtonUI(lightButton)
        mainLabelTextAligment()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print(mainTextLabel.textAlignment.rawValue)
        coordinator.animateAlongsideTransition(in: self.view, animation: { [weak self] (context) in
            guard let self = self else {return}
            self.mainLabelTextAligment()
            if let spinner = self.spinner, !spinner.isHidden {
                self.spinner?.center.x = self.view.center.x
                self.spinner?.center.y = self.lightButton.center.y
            }
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
            if isSmallIPhone() {
                mainLabelBottomConstraint.constant = 16
            }
            if isIphone6() {
                mainLabelBottomConstraint.constant = 50
            }
            self.mainTextLabel.textAlignment = .center
        case .portrait, .portraitUpsideDown,.unknown:
            if isSmallIPhone() || isIphone6()  {
                mainLabelBottomConstraint.constant = 50
            }
            if isIphone6() {
                mainLabelBottomConstraint.constant = 100
            }
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
    
    func addSpinner() {
        spinner = SpinnerView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        if let spinner = spinner {
            self.view.addSubview(spinner)
            spinner.center.x = self.view.center.x
            spinner.center.y = self.lightButton.center.y
            self.lightButton.setTitle(" ", for: .normal)
            self.spinner?.animate()
        }
    }
    
    func removeSpinner() {
        lightButton.setTitle(flashOn ? "Спынiць!" : "Святло!", for: .normal)
        self.spinner?.removeFromSuperview()
        self.spinner?.removeAnimation()
        self.spinner = nil
    }
    
    // MARK: - Actions
    
    @IBAction func showSettings(_ sender: Any) {
        flashOn = false
        performSegue(withIdentifier: "showInfo", sender: nil)
    }
    
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
    
    @IBAction func lightAction(_ sender: Any?) {
        self.flashOn.toggle()
        removeSpinner()
        if flashOn {
            addSpinner()
            if Reachability.isConnectedToNetwork() {
                Clock.sync(from: "time.google.com", samples: 0, first: { (date, offset) in
                    self.checkIfCanFireFlash(date: date)
                }, completion: nil)
            } else {
                checkIfCanFireFlash(date: Date())
            }
        }
    }
    
    func checkIfCanFireFlash(date: Date) {
        let before = Date().millisecondsSince1970 % 100
        let seconds = Calendar.current.component(.second, from: date)
        let miliseconds = date.millisecondsSince1970 % 1000
        var timeToWait: Int64 = 1000 - miliseconds
        if seconds % 2 == 0 {
            timeToWait += 1000
        }
        let now = Date().millisecondsSince1970 % 100
        timeToWait -= now - before
        print(timeToWait)
        
        //        usleep(useconds_t(timeToWait * 1000))
        var completionTime = Int64()
        switch timeToWait {
        case 0...200:
            completionTime = 100
        case 200...800:
            completionTime = 300
        default:
            completionTime = 500
        }
            
        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(Double(timeToWait - completionTime) / 1000), repeats: false) { [weak self] (timer) in
            guard let self = self else {return}
            if self.flashOn {
                print("circle complited")
                self.spinner?.completeCircle(forTime: CFTimeInterval(completionTime))
            }
        }
        
        fullCycleTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Double(timeToWait) / 1000), repeats: false) { [weak self] (timer) in
            guard let self = self else {return}
            if self.flashOn {
                self.removeSpinner()
                print("First timer")
                self.counter = 0
                self.textCounter = 0
                self.recursionTextFlash()
                self.recursionFlash()
            }
        }
    }
    
    func runFlash() {
        self.flashOn.toggle()
        self.counter = 0
        self.textCounter = 0
        self.recursionTextFlash()
        self.recursionFlash()
    }
    
    private func recursionFlash() {
        if flashOn, counter >= 0 {
            let timesArray = self.currentType == .liveBelarus ? liveBelarusTiming : changesTiming
            guard let state = timesArray[counter].state, let timing = timesArray[counter].time else {return}
            self.flash(on: state, forTime: timing) {
                self.counter = self.counter == timesArray.count - 1 ? 0 : self.counter + 1
                
                if self.counter == 0, let date = Clock.now {
                    self.checkIfCanFireFlash(date: date)
                    return
                }
                self.recursionFlash()
            }
        }
    }
    private func recursionTextFlash() {
        if flashOn, textCounter >= 0 {
            let textTimingArray = self.currentType == .liveBelarus ? liveBelarusTiming : textChangeTiming
            guard let range = textTimingArray[textCounter].range, let timing = textTimingArray[textCounter].time else {return}
            self.flashText(range, forTime: timing) {
                self.textCounter = self.textCounter == textTimingArray.count - 1 ? 0 : self.textCounter + 1
                if self.textCounter == 0 {
                    return
                }
                self.recursionTextFlash()
            }
        }
    }
    
    // MARK: - Text
    
    func flashText(_ range: NSRange, forTime seconds: Double, completion: (() -> Void)?) {
        if currentType == .changes {
            return
        }
        let attributed = NSMutableAttributedString(string: "Жыве Беларусь!")
        if range != NSRange(location: 0, length: 0) {
            attributed.addAttribute(.foregroundColor, value: UIColor.blackText, range: NSMakeRange(0, range.location))
            attributed.addAttribute(.foregroundColor, value: UIColor.redBack, range: range)
        } else {
            attributed.addAttribute(.foregroundColor, value: UIColor.blackText, range: NSMakeRange(0, range.location))
        }
        self.mainTextLabel.attributedText = attributed
        self.delay(bySeconds: seconds) {
            completion?()
        }
    }
    
    
    // MARK: - Flash
    
    private func flash(on: Bool, forTime seconds: Double, completion: (() -> Void)?) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            if on {
                DispatchQueue.main.async {
                    UIDevice.vibrate()
                }
            }
            device.unlockForConfiguration()
            
            loopTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] (timer) in
                guard let self = self else {return}
                print("Second timer")
                if self.flashOn {
                    completion?()
                }
                
            }
            //            usleep(useconds_t(seconds * 1000 * 1000))
            
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

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
