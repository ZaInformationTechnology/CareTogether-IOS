//
//  GlobalView.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 01/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import JGProgressHUD

class GlobalView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lyAsian: UIView!
    @IBOutlet weak var lyAll: UIView!
    @IBOutlet weak var lbAsian: UILabel!
    @IBOutlet weak var lbAll: UILabel!
    @IBOutlet weak var lyAsianHeight: NSLayoutConstraint!
    @IBOutlet weak var lyAllheight: NSLayoutConstraint!
    let useCase = InfoUseCase()
    
    var asianDataSource = [[Any]]()
    var globalDataSource = [[Any]]()

    var aisanDataTable : SwiftDataTable?
    var globalDataTable : SwiftDataTable?
    
    let hud = JGProgressHUD(style: .dark)
    
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        initView()
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
        
    }
    
    
    func setupConstraintsForAsian() {
          NSLayoutConstraint.activate([
              aisanDataTable!.topAnchor.constraint(equalTo: lbAsian.layoutMarginsGuide.bottomAnchor, constant: 16),
              aisanDataTable!.leadingAnchor.constraint(equalTo: lyAsian.leadingAnchor),
              aisanDataTable!.bottomAnchor.constraint(equalTo: lyAsian.layoutMarginsGuide.bottomAnchor),
              aisanDataTable!.trailingAnchor.constraint(equalTo: lyAsian.trailingAnchor),
          ])
      }
      
      func setupViewsForAsian() {
          lyAsian.addSubview(aisanDataTable!)
      }
    
    
    func setupConstraintsForGlobal() {
             NSLayoutConstraint.activate([
                 globalDataTable!.topAnchor.constraint(equalTo: lbAll.layoutMarginsGuide.bottomAnchor, constant: 16),
                 globalDataTable!.leadingAnchor.constraint(equalTo: lyAll.leadingAnchor),
                 globalDataTable!.bottomAnchor.constraint(equalTo: lyAll.layoutMarginsGuide.bottomAnchor),
                 globalDataTable!.trailingAnchor.constraint(equalTo: lyAll.trailingAnchor),
             ])
         }
         
         func setupViewsForGlobal() {
             lyAll.addSubview(globalDataTable!)
         }
       
       
    
    func apiCall(){
        showLoading(show: true)
        useCase.getStaticGlobal { (state) in
            self.renderState(state: state)
        }
        
        useCase.getStaticAsian { (state) in
            self.renderState(state: state)
        }
    }
    
    
    func renderState(state : InfoState){
        switch state {
        case .FetchStaticAsianError:
            print("asian error")
            self.showLoading(show: false)
        case .FetchStaticGlobalError :
            print("global error")
            self.showLoading(show: false)
        case .FetchGlobalSuccess(let response) :
            print("global success")
            self.bindDataForGlobal(data: response.data)
            self.showLoading(show: false)
        case .FetchAsianSuccess(let response) :
            print("asian success")
            self.showLoading(show: false)
            self.bindDataForAsian(data: response.data)
        default:
            print("other")
        }
    }
    
    
    func showLoading(show : Bool){
        if(show){
            hud.show(in: self.contentView)

        }else{
            hud.dismiss(animated: true)
        }
    }
    
    
    func bindDataForAsian(data : [DataByCountry]){
        if(!data.isEmpty){
            self.asianDataSource = mapDataForDataTable(data: data)
            self.aisanDataTable = makeAsianDataDataTable()
            self.setupViewsForAsian()
            self.setupConstraintsForAsian()
            aisanDataTable?.reloadEverything()
            self.lyAsianHeight.constant = CGFloat((self.asianDataSource.count * 50))

        }else{
            lyAsianHeight.constant = 0
        }
        self.contentView.layoutIfNeeded()
        self.contentView.updateConstraints()
    }
    
    
    
    
    func makeAsianDataDataTable() -> SwiftDataTable {
           var configuration = DataTableConfiguration()
           configuration.shouldShowSearchSection = false
           configuration.shouldShowFooter = false
           configuration.shouldShowVerticalScrollBars = false
           configuration.sortArrowTintColor = #colorLiteral(red: 0.06092309207, green: 0.2694674134, blue: 0.9163296819, alpha: 1)
           let dataTable = SwiftDataTable(
            data: asianData(),
               headerTitles: self.columnHeaders(),
               options: configuration
           )
           dataTable.translatesAutoresizingMaskIntoConstraints = false
           dataTable.delegate = self
           dataTable.delegateCellChanged = self
           return dataTable
       }
    
    
     func makeGlobalDataTable() -> SwiftDataTable {
            var configuration = DataTableConfiguration()
            configuration.shouldShowSearchSection = false
            configuration.shouldShowVerticalScrollBars = false
            configuration.shouldShowFooter = false
            configuration.sortArrowTintColor = #colorLiteral(red: 0.06092309207, green: 0.2694674134, blue: 0.9163296819, alpha: 1)
            let dataTable = SwiftDataTable(
             data: globalData(),
                headerTitles: self.columnHeaders(),
                options: configuration
            )
            dataTable.translatesAutoresizingMaskIntoConstraints = false
            dataTable.delegate = self
            dataTable.delegateCellChanged = self
    
            return dataTable
        }
     
    
    
    func asianData() -> [[DataTableValueType]]{
           return self.asianDataSource.map {
               $0.compactMap (DataTableValueType.init)
           }
       }
    
    
    func bindDataForGlobal(data : [DataByCountry]){
        if(!data.isEmpty){
            self.globalDataSource = mapDataForDataTable(data: data)
            self.globalDataTable = makeGlobalDataTable()
            self.setupViewsForGlobal()
            self.setupConstraintsForGlobal()
            aisanDataTable?.reloadEverything()
            self.lyAllheight.constant = CGFloat((self.globalDataSource.count * 45))

        }else{
            lyAllheight.constant = 0
        }
        self.contentView.layoutIfNeeded()
        self.contentView.updateConstraints()
    }
    
    
    func globalData() -> [[DataTableValueType]]{
           return self.globalDataSource.map {
               $0.compactMap (DataTableValueType.init)
           }
       }
       
       func columnHeaders() -> [String] {
           return [
               "နိုင်ငံ",
               "ဖြစ်ပွားမှုစုစုပေါင်း",
               "ယနေ့တွေ့ရှိ",
               "စုစုပေါင်းသေဆုံး",
               "ယနေ့သေဆုံး",
               "ပြန်လည်ကောင်းမွန်",
           ]
       }
    
    func mapDataForDataTable(data : [DataByCountry]) -> [[Any]]{
          var source = [[Any]]()
          data.forEach { (item) in
              var items = [Any]()
              items.append(item.country)
              items.append(item.total_cases)
              items.append("+\(item.new_cases)")
              items.append("+\(item.total_deaths)")
              items.append("+\(item.new_deaths)")
              items.append("+\(item.total_recovered)")
              source.append(items)
          }
          return source
      }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initView()
        
    }
    
    
    private func initView(){
        
        let bundle = Bundle(for: GlobalView.self)
        bundle.loadNibNamed("GlobalView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame  = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        hud.textLabel.text = "လုပ်ဆောင်နေပါသည်"
        
    }
    
}
extension GlobalView: SwiftDataTableDelegate {
    func didSelectItem(_ dataTable: SwiftDataTable, indexPath: IndexPath) {
        debugPrint("did select item at indexPath: \(indexPath) dataValue: \(dataTable.data(for: indexPath))")
    }
    
    
    func shouldContentWidthScaleToFillFrame(in dataTable: SwiftDataTable) -> Bool {
        return true
    }
    
    
    
    func dataTable(_ dataTable: SwiftDataTable, widthForColumnAt index: Int) -> CGFloat {
        
        
        if (index == 0){
            return 200
        }else{
            return 140
        }
    }
    
    
    
}

extension GlobalView : CellChanged {
    func cellForRowAt(row: Int,label : UILabel) {
        switch row {
        case 2:
            label.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        case 3 :
            label.textColor = .red
        case 4 :
            label.textColor = .red
        case 5 :
            label.textColor = .green
        default:
            label.textColor = .black
        }
    }
}
