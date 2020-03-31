//
//  FullInformationVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import SwiftDataTables
class FullInformationVc: UIViewController {
    @IBOutlet weak var lyDetailToolbar: DetailToolbar!
    
    @IBOutlet weak var tableFrame: RoundCardView!
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
        
        lyDetailToolbar.lbTitle.text = "ဆေးရုံအလိုက်စောင့်ကြည့်/သံသယလူနာ စုစုပေါင်း"
        lyDetailToolbar.navigationController = self.navigationController
        lyDetailToolbar.btnShare.isHidden = true
        
        dataTable = makeDataTable()
        setupViews()
        setupConstraints()
        dataTable?.collectionView.layer.cornerRadius = 8
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dataTable!.topAnchor.constraint(equalTo: tableFrame.layoutMarginsGuide.topAnchor, constant: 0),
            dataTable!.leadingAnchor.constraint(equalTo: tableFrame.leadingAnchor),
            dataTable!.bottomAnchor.constraint(equalTo: tableFrame.layoutMarginsGuide.bottomAnchor),
            dataTable!.trailingAnchor.constraint(equalTo: tableFrame.trailingAnchor),
        ])
    }
    
    func setupViews() {
        navigationController?.navigationBar.isTranslucent = false
        title = "Employee Balances"
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        tableFrame.addSubview(dataTable!)
    }
    
    func data() -> [[DataTableValueType]]{
        return self.dataSource.map {
            $0.compactMap (DataTableValueType.init)
        }
    }
    
    func columnHeaders() -> [String] {
        return [
            "ဆေးရုံအမည်",
            "စောင့်ကြည့်",
            "သံသယ",
            "ပိုးတွေ့",
            "ပိုးမတွေ့",
            "ဓာတ်ခွဲခန်းအဖြစောင့်ဆိုင်းဆဲ"
        ]
    }
    
}

extension FullInformationVc {
    func makeDataTable() -> SwiftDataTable {
        
        let dataTable = SwiftDataTable(
            data: self.data(),
            headerTitles: self.columnHeaders(),
            options: configuration!
        )
//        dataTable.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
//        dataTable.backgroundColor = .gree
        dataTable.translatesAutoresizingMaskIntoConstraints = false
        dataTable.delegate = self
        return dataTable
    }
}

extension FullInformationVc: SwiftDataTableDelegate {
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
