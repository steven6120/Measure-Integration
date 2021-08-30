//
//  DataTransferVC.swift
//  Measure
//
//  Created by steven on 2021/2/25.
//  Copyright © 2021 levantAJ. All rights reserved.
//

import UIKit

protocol DismissBackImage:class {
    func dissmissimage(sentDatas: Any)
}

class DataTransferVC: UIViewController ,DismissBackDelegate{

    var long = ""
    var width = ""
    var latitude = ""
    var longitude = ""
    @IBOutlet weak var longtextfield: UITextField!
    @IBOutlet weak var widthtextfield: UITextField!
    @IBOutlet weak var latitudetextfield: UITextField!
    @IBOutlet weak var longitudetextfield: UITextField!
    @IBOutlet weak var ScreenshotImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longtextfield.attributedPlaceholder = NSAttributedString(string: "直接輸入或點選AR測量",attributes: [NSAttributedStringKey.foregroundColor:UIColor.gray])
        widthtextfield.attributedPlaceholder = NSAttributedString(string: "直接輸入或點選AR測量",attributes: [NSAttributedStringKey.foregroundColor:UIColor.gray])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToViewController" {
           let ViewController = segue.destination as! ViewController
            ViewController.delegate = self
        }
        else if segue.identifier == "GoToUIImage" {
            if let dataTransferVC = segue.destination as? UIImageVC
            {
                if let Photo = ScreenshotImageView.image{
                    dataTransferVC.delegates = Photo
                }
            }
        }
        
    }
     
    @IBAction func dissmissphoto(_ sender: UIButton) {
       
    }
    func dissmissBack(sentData: Any){
            long = sentData as! String
            print(long)
            longtextfield.text = long
        }
    func dissmisslatitude(sentData: Any){
        latitude = sentData as! String
        print(latitude)
        latitudetextfield.text = latitude
    }
    func dissmisslongitude(sentData: Any){
        longitude = sentData as! String
        print(longitude)
        longitudetextfield.text = longitude
    }
    func dissmissscreenshot(sentData: Any){
        ScreenshotImageView.image = sentData as? UIImage 
    }
}
