//
//  InfoVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import SwiftHEXColors
import JGProgressHUD
import SwiftDataTables

class InfoVc: UIViewController {
    
    @IBOutlet weak var lbMyanmar: UILabel!
    @IBOutlet weak var lbGlobal: UILabel!
    @IBOutlet weak var lyGlobal: UIView!
    @IBOutlet weak var lyMyanmar: UIView!
    let useCase = InfoUseCase()
    
    @IBOutlet weak var lbQu: UILabel!
    @IBOutlet weak var lbQSupAndQ: UILabel!
    @IBOutlet weak var lbSus: UILabel!
    @IBOutlet weak var pending: UILabel!
    
    @IBOutlet weak var lbRetri: UILabel!
    @IBOutlet weak var lbDeath: UILabel!
    @IBOutlet weak var lbConfirmed: UILabel!
    @IBOutlet weak var lbNegative: UILabel!
    
    @IBOutlet weak var lyMyanmarScrollVie: UIScrollView!
    @IBOutlet weak var lbTitleDashboard: UILabel!
    let hud = JGProgressHUD(style: .dark)
    var dataByHospital = [DataByHospital]()
    @IBOutlet weak var tbHospital: UITableView!
    var staticMyanmarResponse : StaticMyanmarResponse?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = "လုပ်ဆောင်နေသည်"
        initComponent()
        apiCall()
        initHospitalTb()
        
    }
    
    
    func apiCall(){
        useCase.getStaticMyanmar { (state) in
            self.renderState(state: state)
        }
    }
    
    
    func initHospitalTb(){
        tbHospital.delegate = self
        tbHospital.dataSource = self
        let cellNib = UINib(nibName: "DataByHospitalCell", bundle: nil)
        tbHospital.register(cellNib, forCellReuseIdentifier: "CellRow")
        
    }
    
    
    private func bindDataToList(data : [DataByHospital]){
        
        if(data.count > 0){
            for item in data {
                dataByHospital.append(item)
            }
        }
        
        UIView.transition(with: self.tbHospital,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.tbHospital.reloadData() })
    }
    
    
    
    
    func renderState(state : InfoState){
        switch state {
        case .Loading:
            if( self.staticMyanmarResponse == nil){
                self.showLoading(show: true)
            }
        case .FetchStaticError :
            self.showLoading(show: false)
            self.showErrorMessageAlertWithRetry(message: "လုပ်ဆောင်မှုမအောင်မြင်ပါ") { retry in
                self.apiCall()
                
            }
        case .FetchStaticMyanmarSuccess(let response) :
            self.showLoading(show: false)
            self.staticMyanmarResponse = response
            self.bindOverAll(response : response.overall_counts)
            self.bindDataToList(data: response.data_by_hospitals)
            
        }
    }
    
    
    func bindOverAll(response : OverAll){
        lbQSupAndQ.text = Int(response.total_quarantined_suspected ?? "0")?.numberFormat()
        lbQu.text = Int(response.total_quarantined ?? "0")?.numberFormat()
        lbSus.text = Int(response.suspected ?? "0")?.numberFormat()
        pending.text =  Int( response.pending ?? "0")?.numberFormat()
        lbNegative.text = Int( response.negative ?? "0")?.numberFormat()
        lbConfirmed.text = (response.confirmed  ?? 0) .numberFormat()
        lbDeath.text = (response.deaths ?? 0).numberFormat()
        lbRetri.text = (response.recovered ?? 0).numberFormat()
    }
    
    func showLoading(show : Bool){
        if(show){
            hud.show(in: self.view)
        }else{
            hud.dismiss(animated: true)
        }
    }
    
    func initComponent(){
        lyGlobal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeGlobal)))
        
        lyMyanmar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeMM)))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
    }
    
    
    
    @objc func  changeGlobal(){
        lyGlobal.backgroundColor = UIColor(hexString: "#0d27e4")
        lyMyanmar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbGlobal.textColor = .white
        lbMyanmar.textColor = .black
        lbTitleDashboard.text = "Sureillance Dashboard (Global ) 2020"
        lyMyanmarScrollVie.isHidden = true
        
    }
    func mapDataForDataTable() -> [[Any]]{
        var source = [[Any]]()
        self.dataByHospital.forEach { (item) in
            var items = [Any]()
            items.append(item.hospital)
            items.append(Int(item.quarantined).numberFormat())
            items.append(Int(item.quarantined_suspected).numberFormat())
            items.append(item.confirmed.numberFormat())
            items.append(item.negative.numberFormat())
            items.append(item.pending.numberFormat())
            source.append(items)
        }
        return source
    }
    @IBAction func btnExpandPressed(_ sender: Any) {
        print("go data table")
        var configuration = DataTableConfiguration()
        configuration.shouldShowSearchSection = false
        configuration.shouldShowFooter = false
        let vc = storyboard?.instantiateViewController(withIdentifier: "FullInformationVc") as! FullInformationVc
        vc.dataSource = mapDataForDataTable()
        vc.configuration = configuration
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func  changeMM(){
        lyMyanmar.backgroundColor = UIColor(hexString: "#0d27e4")
        lyGlobal.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbMyanmar.textColor = .white
        lbGlobal.textColor = .black
        lbTitleDashboard.text = "Sureillance Dashboard (Myanmar ) 2020"
        lyMyanmarScrollVie.isHidden = false
    }
}



extension Int {
    func numberFormat() -> String{
        
        let number = NSNumber(integerLiteral: self)
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = ""
        currencyFormatter.locale = Locale(identifier: "my-MM")
        let priceString = currencyFormatter.string(from : number)!
        return priceString
    }
}


extension InfoVc : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(dataByHospital.count>4){
            return 4
        }else{
            return dataByHospital.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRow", for: indexPath) as! DataByHospitalCell
        
        cell.lbCount.text = dataByHospital[indexPath.row].quarantined_suspected.numberFormat()
        cell.lbHospitalName.text = dataByHospital[indexPath.row].hospital
        cell.selectionStyle = .none
        return cell
    }
    
    
}
