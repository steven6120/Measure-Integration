//
//  UIImageView.swift
//  Measure
//
//  Created by steven on 2021/3/15.
//  Copyright © 2021 levantAJ. All rights reserved.
//

import UIKit



class UIImageVC: UIViewController{
    @IBOutlet weak var ZoomInPicture: UIImageView!
    var delegates: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ZoomInPicture.image = delegates
    }
    
   /* func dissmissimage(sentDatas: Any) {
        ZoomInPicture.image = sentDatas as? UIImage
    }*/
    
    @IBAction func redissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
