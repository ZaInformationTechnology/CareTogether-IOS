//
//  Extensions.swift
//  CareTogether
//
//  Created by HeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    
    func showVc(componentId : String,storyboardName : String){
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: componentId)
        destinationVC.modalPresentationStyle = .overCurrentContext
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    func popToRoot(){
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: {
                self.navigationController!.popToRootViewController(animated: true)
            })
        }
        else {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    
    
    func showErrorMessageAlertWithRetry(message : String , completion : @escaping (_ isRetry:Bool)->Void ){
        let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "သတိပေးချက်", style: .default) { (action) in
            completion(true)
        }
        let cancelAction = UIAlertAction.init(title:"ပြန်လုပ်မည်", style: .cancel) { (action) in
            completion( false)
        }
        alert.addAction(cancelAction)
        //        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorMessageAlertWithCloseWithCallback(message : String, completion :  @escaping (_ isOkPressed : Bool)-> Void ){
        let alert = UIAlertController.init(title: "သတိပေးချက်", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "ကောင်းပီ", style: .default) { (action) in
            completion(true)
        }
        
        let cancelAction = UIAlertAction.init(title:"မလုပ်ပါ", style: .cancel) { (action) in
            completion(false )
        }
    alert.addAction(cancelAction)

        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorMessageAlertWithClose(message : String){
        let alert = UIAlertController.init(title: "သတိပေးချက်", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "ကောင်းပီ", style: .default) { (action) in
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccessMessageAlertWithClose(message : String , completion :  @escaping ()-> Void ){
        let alert = UIAlertController.init(title: "LocalizationKey.successTitle.string", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "LocalizationKey.lbClose.string", style: .default) { (action) in
            completion()
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}
