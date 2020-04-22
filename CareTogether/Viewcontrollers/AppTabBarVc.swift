//
//  AppTabBarVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 19/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import Localize_Swift
class AppTabBarVc: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLocalelized), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
        changeLocalelized()
        // Do any additional setup after loading the view.
    }
    
    @objc func changeLocalelized(){
        guard let items = tabBar.items else { return }
        items[0].title = "tab1".localized()
        items[1].title = "tab2".localized()
        items[2].title = "tab3".localized()
        items[3].title = "tab4".localized()
        items[4].title = "tab5".localized()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    func createTabBarItem(tabBarTitle: String, tabBarImage: String, viewController: UIViewController) -> UINavigationController {
         let navCont = AppNavigationController(rootViewController: viewController)
         navCont.tabBarItem.title = tabBarTitle
         navCont.navigationBar.isTranslucent = true
         navCont.navigationBar.isHidden = true
         navCont.tabBarItem.image = UIImage(named: tabBarImage)
         return navCont
     }
}
