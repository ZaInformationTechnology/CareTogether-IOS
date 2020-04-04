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
    var staticMyanmarResponse : StaticMyanmarResponse?
    @IBOutlet weak var frameTableView: NSLayoutConstraint!
    
    @IBOutlet weak var lyGlobalScrollView: UIScrollView!
    @IBOutlet weak var titleForPatient: UILabel!
    
    @IBOutlet weak var frameLocalTableView: UIView!
    
    var dataTable : SwiftDataTable?
    
    var configuration: DataTableConfiguration? = nil
    
    var dataSource = [[Any]]()
    
    public init(){
        var configuration = DataTableConfiguration()
        configuration.shouldShowSearchSection = false
        configuration.shouldShowFooter = false
        configuration.sortArrowTintColor = #colorLiteral(red: 0.06092309207, green: 0.2694674134, blue: 0.9163296819, alpha: 1)
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = "လုပ်ဆောင်နေသည်"
        initComponent()
        lyGlobalScrollView.isHidden = true
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dataTable!.topAnchor.constraint(equalTo: titleForPatient.layoutMarginsGuide.bottomAnchor, constant: 16),
            dataTable!.leadingAnchor.constraint(equalTo: frameLocalTableView.leadingAnchor),
            dataTable!.bottomAnchor.constraint(equalTo: frameLocalTableView.layoutMarginsGuide.bottomAnchor),
            dataTable!.trailingAnchor.constraint(equalTo: frameLocalTableView.trailingAnchor),
        ])
    }
    
    func setupViews() {
        navigationController?.navigationBar.isTranslucent = false
        title = "Employee Balances"
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        frameLocalTableView.addSubview(dataTable!)
    }
    
    
    func apiCall(){
        useCase.getStaticMyanmar { (state) in
            self.renderState(state: state)
        }
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
            self.dataByHospital =  response.data_by_regions
            self.dataSource = self.mapDataForDataTable()
            self.dataTable =  self.makeDataTable()
            self.setupViews()
            self.setupConstraints()
            self.dataTable?.reloadEverything()
            self.frameTableView.constant = CGFloat((self.dataSource.count * 50) + 50)
            self.frameLocalTableView.layoutIfNeeded()
            self.frameLocalTableView.updateConstraints()
        default :
            print("other case")
        }
        
        
      

    }
    
    
    func bindOverAll(response : OverAll){
        lbQSupAndQ.text = Int(response.total_quarantined_suspected ?? "0")?.numberFormat()
        lbQu.text = Int(response.total_quarantined ?? "0")?.numberFormat()
        lbSus.text = Int(response.suspected ?? "0")?.numberFormat()
        pending.text =  Int( response.pending ?? "0")?.numberFormat()
        lbNegative.text = Int( response.negative ?? "0")?.numberFormat()
        lbConfirmed.text = Int(response.confirmed  ?? "0")?.numberFormat()
        lbDeath.text = Int(response.deaths ?? "0")?.numberFormat()
        lbRetri.text = Int(response.recovered ?? "0")?.numberFormat()
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
    
    
    
    @IBOutlet weak var lyGlobalView: GlobalView!
    @objc func  changeGlobal(){
        lyGlobal.backgroundColor = UIColor(hexString: "#0d27e4")
        lyMyanmar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbGlobal.textColor = .white
        lbMyanmar.textColor = .black
        lbTitleDashboard.text = "Sureillance Dashboard (Global ) 2020"
        lyMyanmarScrollVie.isHidden = true
        lyGlobalScrollView.isHidden = false
        lyGlobalView.apiCall()
    }
    func mapDataForDataTable() -> [[Any]]{
        var source = [[Any]]()
        self.dataByHospital.forEach { (item) in
            var items = [Any]()
            items.append(item.region)
            items.append(item.quarantined)
            items.append(item.quarantined_suspected)
            items.append(item.confirmed)
            items.append(item.negative)
            items.append(item.pending)
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
        lyGlobalScrollView.isHidden = true
    }
    func data() -> [[DataTableValueType]]{
        return self.dataSource.map {
            $0.compactMap (DataTableValueType.init)
        }
    }
    
    func columnHeaders() -> [String] {
        return [
            "တိုင်း/ပြည်နယ်",
            "စောင့်ကြည့်",
            "သံသယ",
            "ပိုးတွေ့",
            "ပိုးမတွေ့",
            "အဖြစောင့်ဆိုင်းဆဲ"
        ]
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





extension InfoVc {
    
    func makeDataTable() -> SwiftDataTable {
        var configuration = DataTableConfiguration()
        configuration.shouldShowSearchSection = false
        configuration.shouldShowFooter = false
        configuration.sortArrowTintColor = #colorLiteral(red: 0.06092309207, green: 0.2694674134, blue: 0.9163296819, alpha: 1)
        self.configuration = configuration
        let dataTable = SwiftDataTable(
            data: self.data(),
            headerTitles: self.columnHeaders(),
            options: configuration
        )
        dataTable.translatesAutoresizingMaskIntoConstraints = false
        dataTable.delegate = self
        dataTable.delegateCellChanged = self
        return dataTable
    }
}


extension InfoVc : CellChanged {
    func cellForRowAt(row: Int,label : UILabel) {
        switch row {
        case 2:
            label.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        case 3 :
            label.textColor = .red
        case 4 :
            label.textColor = .green
        default:
            label.textColor = .black
        }
    }
}

extension InfoVc: SwiftDataTableDelegate {
    func didSelectItem(_ dataTable: SwiftDataTable, indexPath: IndexPath) {
        debugPrint("did select item at indexPath: \(indexPath) dataValue: \(dataTable.data(for: indexPath))")
    }
    
    
    func shouldContentWidthScaleToFillFrame(in dataTable: SwiftDataTable) -> Bool {
        return true
    }
    
    
    
    func dataTable(_ dataTable: SwiftDataTable, widthForColumnAt index: Int) -> CGFloat {
        
        
        if (index == 0){
            return 250
        }else{
            return 140
        }
    }
    
    
    
}


