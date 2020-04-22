//
//  SettingVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 16/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import JGProgressHUD
import Localize_Swift

class SettingVc: UIViewController {
    
    let hud  = JGProgressHUD(style: .dark)
    @IBOutlet weak var tbLocale: UITableView!
    let useCase = CommonUseCase()
    @IBOutlet weak var lyToolbar: DetailToolbar!
    var locales = [LocaleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = Const.instance.loading
        lyToolbar.lbTitle.text = Const.instance.setting
        lyToolbar.navigationController = self.navigationController
        lyToolbar.btnShare.isHidden = true
        initTable()
        apiCall()
        
        let offlineLocales = Store.instance.getLocales()
        if(offlineLocales != nil){
            bindDataToList(data: offlineLocales!)
//            print("OFFLINE DATA \(offlineLocales)" )
        }
    }
    
    
    func initTable(){
        tbLocale.delegate = self
        tbLocale.dataSource = self
        let cellNib = UINib(nibName: "LocaleCell", bundle: nil)
        self.tbLocale.backgroundColor = .white
        tbLocale.register(cellNib, forCellReuseIdentifier: "CellRow")
        
        
    }
    
    
    func apiCall(){
        useCase.getSettings { (state) in
            switch state {
            case .FetchSettingError :
                self.showLoading(show: false)
            case .FetchSettingSuccess(let data) :
                self.bindDataToList(data: data.locals)
                print("locale \(data.locals)")
                Store.instance.setLocales(locales: data.locals)
                self.showLoading(show: false)
            case .Loading :
                self.showLoading(show: true)
            }
        }
    }
    
    
    private func showLoading(show : Bool){
        if(show){
            hud.show(in: self.view)
        }else{
            hud.dismiss(animated: true)
        }
        
    }
    
    
       private func bindDataToList(data : [LocaleModel]){
        self.locales.removeAll()
           if(data.count > 0){
               for item in data {
                   locales.append(item)
               }
           }
           
           UIView.transition(with: self.tbLocale,
                             duration: 0.35,
                             options: .transitionCrossDissolve,
                             animations: { self.tbLocale.reloadData() })
       }

}


extension SettingVc : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locales.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Store.instance.setCurrentLanguage(loginResponse: locales[indexPath.row])
        checkAndChangeLanguage(locale: locales[indexPath.row].locale)
        DispatchQueue.main.async {
            self.tbLocale.reloadData()
        }
    }

    
    func checkAndChangeLanguage(locale : String){
        var currentLocale = locale
        switch locale {
        case "mm":
            currentLocale = "my"
        case "en" :
            currentLocale = "en"
        default:
            print("other")
        }
        Localize.setCurrentLanguage(currentLocale)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRow") as! LocaleCell
        

        let currentLanguage = Store.instance.getCurrentLanguage()
        let model = locales[indexPath.row]
        if(currentLanguage != nil) {
            if(model.locale == currentLanguage!.locale) {
                cell.lyCheck.isHidden = false
            }else{
                cell.lyCheck.isHidden = true
            }
            let image = UIImage(named: "\(model.locale)")
            cell.ivLogo.image = image
            cell.lbLocaleName.text = model.name
        }

        return cell
    }
    
    
}
