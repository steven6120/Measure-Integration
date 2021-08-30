//
//  ViewController.swift
//  Measure
//
//  Created by levantAJ on 8/9/17.
//  Copyright © 2017 levantAJ. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation

protocol DismissBackDelegate: class {
    
    func dissmissBack(sentData: Any)
    func dissmisslatitude(sentData: Any)
    func dissmisslongitude(sentData: Any)
    func dissmissscreenshot(sentData: Any)
    
    }

final class ViewController: UIViewController,CLLocationManagerDelegate{
  
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var targetImageView: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var meterImageView: UIImageView!
    @IBOutlet weak var resetImageView: UIImageView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var screenshotButton: UIButton!
    @IBOutlet weak var screenshotImageView: UIImageView!
    fileprivate lazy var session = ARSession()
    fileprivate lazy var sessionConfiguration = ARWorldTrackingConfiguration()
    fileprivate lazy var isMeasuring = false;
    fileprivate lazy var vectorZero = SCNVector3()
    fileprivate lazy var startValue = SCNVector3()
    fileprivate lazy var endValue = SCNVector3()
    fileprivate lazy var lines: [Line] = []
    fileprivate var currentLine: Line?
    fileprivate lazy var unit: DistanceUnit = .centimeter
    
    var dtvc = ""
    var latitude = ""
    var longitude = ""
    weak var delegate: DismissBackDelegate?
    
    var location : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        location = CLLocationManager()
        location.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        // 首次使用 向使用者詢問定位自身位置權限
         if CLLocationManager.authorizationStatus()
                == .notDetermined {
            location.requestWhenInUseAuthorization()
            location.startUpdatingLocation()
         }
         // 使用者已經拒絕定位自身位置權限
         else if CLLocationManager.authorizationStatus()
                    == .denied {
             // 提示可至[設定]中開啟權限
             let alertController = UIAlertController(
               title: "定位權限已關閉",
               message:
               "如要變更權限，請至 設定 > 隱私權 > 定位服務 ＞ Measure 開啟",
                preferredStyle: .alert)
             let okAction = UIAlertAction(
                title: "確認", style: .default, handler:nil)
             alertController.addAction(okAction)
            self.present(
               alertController,
               animated: true, completion: nil)
         }
         else if CLLocationManager.authorizationStatus()
                    == .authorizedWhenInUse {
                // 開始定位自身位置
                location.startUpdatingLocation()
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause()
        location.stopUpdatingLocation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetValues()
        isMeasuring = true
        targetImageView.image = UIImage(named: "targetGreen")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMeasuring = false
        targetImageView.image = UIImage(named: "targetWhite")
        if let line = currentLine {
            lines.append(line)
            currentLine = nil
            resetButton.isHidden = false
            resetImageView.isHidden = false
            screenshotButton.isHidden = false
            screenshotImageView.isHidden = false
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
   
    func locationManager(_ manager: CLLocationManager,
      didUpdateLocations locations: [CLLocation]) {
        // 印出目前所在位置座標
        let c: CLLocation = locations[locations.count - 1]
        latitude = String(c.coordinate.latitude)
        print (c.coordinate.latitude)
        longitude = String(c.coordinate.longitude)
        print (c.coordinate.longitude)
    }
    
    @IBAction func screenshotbuttonTapped(button: UIButton) {
        delegate?.dissmissscreenshot(sentData: sceneView.snapshot())
       
    }
    @IBAction func resetButtonTapped(button: UIButton) {
       
        delegate?.dissmissBack(sentData: dtvc)
        delegate?.dissmisslatitude(sentData: latitude)
        delegate?.dissmisslongitude(sentData: longitude)
        
        resetButton.isHidden = true
        resetImageView.isHidden = true
        screenshotButton.isHidden = true
        screenshotImageView.isHidden = true
        for line in lines {
            line.removeFromParentNode()
        }
        lines.removeAll()
        location.stopUpdatingLocation()
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async { [weak self] in
            self?.detectObjects()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        messageLabel.text = "發生錯誤"
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        messageLabel.text = "已暫停"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        messageLabel.text = "結束暫停"
    }
}

// MARK: - Users Interactions


extension ViewController {
    @IBAction func meterButtonTapped(button: UIButton) {
        let alertVC = UIAlertController(title: "Settings", message: "Please select distance unit options", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: DistanceUnit.centimeter.title, style: .default) { [weak self] _ in
            self?.unit = .centimeter
        })
        alertVC.addAction(UIAlertAction(title: DistanceUnit.inch.title, style: .default) { [weak self] _ in
            self?.unit = .inch
        })
        alertVC.addAction(UIAlertAction(title: DistanceUnit.meter.title, style: .default) { [weak self] _ in
            self?.unit = .meter
        })
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Privates

extension ViewController {
    fileprivate func setupScene() {
        targetImageView.isHidden = true
        sceneView.delegate = self
        sceneView.session = session
        loadingView.startAnimating()
        meterImageView.isHidden = true
        messageLabel.text = "偵測中…"
        resetButton.isHidden = true
        resetImageView.isHidden = true
        screenshotButton.isHidden = true
        screenshotImageView.isHidden = true
        session.run(sessionConfiguration, options: [.resetTracking, .removeExistingAnchors])
        resetValues()
    }
    
    fileprivate func resetValues() {
        isMeasuring = false
        startValue = SCNVector3()
        endValue =  SCNVector3()
    }
    
    fileprivate func detectObjects() {
        guard let worldPosition = sceneView.realWorldVector(screenPosition: view.center) else { return }
        targetImageView.isHidden = false
        meterImageView.isHidden = false
        screenshotButton.isHidden = false
        if lines.isEmpty {
            messageLabel.text = "按住螢幕並移動手機…"
        }
        loadingView.stopAnimating()
        if isMeasuring {
            if startValue == vectorZero {
                startValue = worldPosition
                currentLine = Line(sceneView: sceneView, startVector: startValue, unit: unit)
            }
            endValue = worldPosition
            currentLine?.update(to: endValue)
            messageLabel.text = currentLine?.distance(to: endValue) ?? "計算中…"
            dtvc = currentLine?.distancenounit(to: endValue) ?? "計算中…"
            
        }
    }
}
