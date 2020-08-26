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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return UIStatusBarStyle.default
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFlag" {
          self.flashOn = false
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        makeButtonUI(phoneButtton)
        makeButtonUI(burgerButton)
        makeButtonUI(lightButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    // MARK: - Flash
    
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
//                print("circle complited")
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
    
    private func recursionFlash() {
        if flashOn, counter >= 0 {
            let timesArray = self.currentType == .liveBelarus ? liveBelarusTiming : changesTiming
            guard let state = timesArray[counter].state, let timing = timesArray[counter].time else {return}
            self.flash(on: state, forTime: timing) {
                self.counter = self.counter == timesArray.count - 1 ? 0 : self.counter + 1
                
                if self.counter == 0 {
                    self.checkIfCanFireFlash(date: Clock.now ?? Date())
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
        print("....")
        print("flash text")
        _ = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] (timer) in
            guard let self = self else {return}
            if self.flashOn {
                completion?()
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
                DispatchQueue.main.async {
                    UIDevice.vibrate()
                }
            }
            device.unlockForConfiguration()
            
            loopTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] (timer) in
                guard let self = self else {return}
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
