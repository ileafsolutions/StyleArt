//
//  SVProgessHudHandler.swift
//  StlyeArts
//
//  Created by Levin on 15/05/17.
//  Copyright © 2017 Jaison Joseph. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIView{
    func showHud(message:String){
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.medium))
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.red)
        SVProgressHUD.show(withStatus: message)
    
    }
    
    func showHud(message:String,progress:Float){
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.medium))
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.red)
        SVProgressHUD.show(withStatus: message)
        SVProgressHUD.showProgress(progress, status: message)
        
    }

    
   func hideHud() {
    SVProgressHUD.dismiss()
    
    }
}
