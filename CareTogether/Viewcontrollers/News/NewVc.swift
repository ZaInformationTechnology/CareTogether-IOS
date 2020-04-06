//
//  NewVc.swift
//  CareTogether
//
//  Created by HeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import JGProgressHUD
import CRRefresh
import Kingfisher

class NewVc: UIViewController {
    
    @IBOutlet weak var tbVideo: UITableView!
    @IBOutlet weak var lyNewList: UIView!
    @IBOutlet weak var tbNew: UITableView!
    private var newList = [New]()
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var lbVideo: UILabel!
    @IBOutlet weak var lyVideoList: UIView!
    let useCase = NewUseCase()
    var newListPage = 1
    @IBOutlet weak var lbNew: UILabel!
    private var videoList = [VideoData]()
    
    
    func newApiCall(){
        useCase.fetchNewList(page : newListPage) { (state) in
            switch state {
            case .Loading :
                if(self.newListPage == 1) {
                    self.showLoading(show: true)
                }
            case .FetchNewListError :
                if(self.newListPage == 1) {
                    self.showLoading(show: false)
                    self.showErrorMessageAlertWithRetry(message: "လုပ်ဆောင်မှုမအောင်မြင်ပါ") { (retry) in
                        
                    }
                }else {
                    self.tbNew.cr.endLoadingMore()
                }
            case .FetchNewListSuccess(let response) :
                if(self.newListPage == 1) {
                    self.showLoading(show: false)
                }else{
                    self.tbNew.cr.endLoadingMore()
                }
                self.bindDataToList(data: response.data)
                if(response.meta.last_page == self.newListPage){
                    self.tbNew.cr.removeFooter()
                    print("remove footer")
                }
                self.newListPage += 1
                
            default :
                print("other")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = "လုပ်ဆောင်နေပါသည်"
        initTable()
        newApiCall()
        initVideoTable()
        initTap()
        
    }
    
    
    
    private func initTap(){
        let newTap = UITapGestureRecognizer(target: self, action: #selector(changeNewList))
        let videoTap = UITapGestureRecognizer(target: self, action: #selector(changeVideoList))
        
        self.lyNewList.addGestureRecognizer(newTap)
        self.lyVideoList.addGestureRecognizer(videoTap)
        
        
    }
    
    
    @objc func changeNewList(){
        lyNewList.animatePress()
        lyNewList.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        lyVideoList.backgroundColor = .white
        tbNew.isHidden = false
        tbVideo.isHidden = true
        lbVideo.textColor = .black
        lbNew.textColor = .white
    }
    
    @objc func changeVideoList(){
        useCase.fetchNewVideo { (state) in
            switch state {
            case .Loading :
                if self.videoList.isEmpty {
                    self.showLoading(show: true)

                }
            case .FetchNewVideosSuccess(let respone) :
                self.showLoading(show: false)
                self.bindDataToVideoList(data: respone.data)
            case .FetchNewVideosError :
                self.showLoading(show: false)
            default :
                print("other")
            }
            
        }
        lyVideoList.animatePress()
        lyNewList.backgroundColor = .white
        lyVideoList.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        tbNew.isHidden = true
        tbVideo.isHidden = false
        lbNew.textColor = .black
        lbVideo.textColor = .white
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
        tbNew.cr.addFootRefresh(animator: NormalFooterAnimator()){
            self.newApiCall()
        }
        
    }
    
    
    func initVideoTable(){
        tbVideo.delegate = self
               tbVideo.dataSource = self
               let cellNib = UINib(nibName: "VideoCell", bundle: nil)
        tbVideo.register(cellNib, forCellReuseIdentifier: "VCell")
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
    
    private func bindDataToVideoList(data : [VideoData]){
        
        if(data.count > 0){
            for item in data {
                videoList.append(item)
            }
        }
        
        UIView.transition(with: self.tbVideo,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.tbVideo.reloadData() })
    }
}

extension NewVc : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbNew {
            return newList.count
        }else{
            return videoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tbNew {
            let vc = self.storyboard?.instantiateViewController(identifier: "NewDetailVc") as! NewDetailVc
            vc.newsData = newList[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = storyboard?.instantiateViewController(identifier: "YoutubeVc") as! YoutubeVc
            vc.videoId = self.videoList[indexPath.row].id
            self.present(vc, animated: true, completion:nil)
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tbNew {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellRow", for: indexPath) as! NewCell
            cell.selectionStyle = .none
                   cell.lbNew.text = newList[indexPath.row].title
                   return cell
        }else if tableView == tbVideo {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VCell", for: indexPath) as! VideoCell
                       cell.selectionStyle = .none
                             // cell.lbNew.text = newList[indexPath.row].title
            cell.lbTitle.text = videoList[indexPath.row].title
            cell.iv.kf.setImage(with: URL(string: videoList[indexPath.row].image)!)
                              return cell
        }
        
       return UITableViewCell()
    }
}
