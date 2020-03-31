//
//  NewVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import JGProgressHUD

class NewVc: UIViewController {

    @IBOutlet weak var tbNew: UITableView!
    private var newList = [New]()
    let hud = JGProgressHUD(style: .dark)
    
    let useCase = NewUseCase()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = "လုပ်ဆောင်နေပါသည်"
        initTable()

        useCase.fetchNewList { (state) in
            switch state {
            case .Loading :
                self.showLoading(show: true)
            case .FetchNewListError :
                self.showLoading(show: false)
                self.showErrorMessageAlertWithRetry(message: "လုပ်ဆောင်မှုမအောင်မြင်ပါ") { (retry) in
                    
                }
            case .FetchNewListSuccess(let response) :
                self.showLoading(show: false)
                self.bindDataToList(data: response.data)
                
            default :
                print("other")
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
    
    func initTable(){
        tbNew.delegate = self
        tbNew.dataSource = self
        let cellNib = UINib(nibName: "NewCell", bundle: nil)
        tbNew.register(cellNib, forCellReuseIdentifier: "CellRow")
        
    }
    
    
    private func bindDataToList(data : [New]){
   
          if(data.count > 0){
              for item in data {
                  newList.append(item)
              }
          }
          
          UIView.transition(with: self.tbNew,
                            duration: 0.35,
                            options: .transitionCrossDissolve,
                            animations: { self.tbNew.reloadData() })
      }
}

extension NewVc : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "NewDetailVc") as! NewDetailVc
        vc.newsData = newList[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRow", for: indexPath) as! NewCell
        cell.selectionStyle = .none
        cell.lbNew.text = newList[indexPath.row].title
        return cell
    }
}
