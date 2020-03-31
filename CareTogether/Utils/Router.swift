//
//  Router.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation
import UIKit

class Router {
    static let instance = Router()
    
    func goToPhoneLogin(window : UIWindow?)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyboard.instantiateViewController(identifier: "PhoneVerifyVc")
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
  
    
    
    func navigate(routeName : String,storyboard : String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: routeName)
        if #available(iOS 13.0, *){
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                print(">>> windowScene: \(windowScene)")
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene //Make sure to do this
                window.rootViewController = vc
                window.makeKeyAndVisible()
                appDelegate.window = window
            }
        } else {
            appDelegate.window?.rootViewController = vc
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    
    func showMessageDialog(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 13.0, *){
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                print(">>> windowScene: \(windowScene)")
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene //Make sure to do this
                window.rootViewController?.showErrorMessageAlertWithClose(message: "")
            }
        } else {
            appDelegate.window?.rootViewController?.showErrorMessageAlertWithClose(message: "")
        }
    }
    
    func goFontChooseVc(window : UIWindow?){
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let rootVC = storyboard.instantiateViewController(identifier: "PhoneVerifyVc")
          window?.rootViewController = rootVC
          window?.makeKeyAndVisible()
      }
    
    func goMainTab(window : UIWindow?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyboard.instantiateViewController(identifier: "AppTabBar")
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    func showVc(componentId : String,current : UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: componentId)
        destinationVC.modalPresentationStyle = .overCurrentContext
        current.present(destinationVC, animated: true, completion: nil)
    }
    
}
