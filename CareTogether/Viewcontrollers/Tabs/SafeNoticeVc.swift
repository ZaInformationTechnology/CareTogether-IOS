//
//  SafeNoticeVc.swift
//  CareTogether
//
//  Created by HeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import ImageSlideshow
import JGProgressHUD

class SafeNoticeVc: UIViewController {
    
    let hud = JGProgressHUD(style: .dark)
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var tbVideo: UITableView!
    
    @IBOutlet weak var lbVideo: UILabel!
    @IBOutlet weak var lyVideo: UIView!
    @IBOutlet weak var lyRealNew: UIView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lyControlFrame: UIView!
    @IBOutlet weak var lyPagerContainer: ImageSlideshow!
    var totalCount = 0
    var currentCount = 0
    private var videoList = [VideoData]()
    @IBOutlet weak var lbRealNew: UILabel!
    
    var inputSource = [ImageSource]()
    func bindDataInImageIndex(){
        lbCount.text = "\(currentCount + 1)/\(totalCount)"
    }
    let useCase = NewUseCase()

    @IBOutlet weak var lyNewPager: RoundCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lyPagerContainer.roundedTop()
        lyControlFrame.roundedBottom()
        
        let realNewTap = UITapGestureRecognizer(target: self, action: #selector(goRealNewVc))
        lyRealNew.addGestureRecognizer(realNewTap)
        
        initPager()
        initTap()
        initVideoTable()
    }
    
    
    
    
    
    @objc func goRealNewVc(){
        lyRealNew.animatePress()
        lyRealNew.animatePress()
                lyRealNew.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                lyVideo.backgroundColor = .white
                lyNewPager.isHidden = false
                tbVideo.isHidden = true
                lbVideo.textColor = .black
                lbRealNew.textColor = .white
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewController(withIdentifier: "RealNewVc") as! RealNewVc, animated: true)
    }
    
    
    
     private func initTap(){
         let newTap = UITapGestureRecognizer(target: self, action: #selector(goRealNewVc))
         let videoTap = UITapGestureRecognizer(target: self, action: #selector(changeVideoList))
         
         self.lyRealNew.addGestureRecognizer(newTap)
         self.lyVideo.addGestureRecognizer(videoTap)
         
         
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
    func initVideoTable(){
        tbVideo.delegate = self
        tbVideo.dataSource = self
        let cellNib = UINib(nibName: "VideoCell", bundle: nil)
        tbVideo.register(cellNib, forCellReuseIdentifier: "VCell")
        tbVideo.estimatedRowHeight = 80.0
        tbVideo.rowHeight = UITableView.automaticDimension
    }
     
     private func showLoading(show : Bool){
            if(show){
                hud.show(in: self.view)
            }else{
                hud.dismiss(animated: true)
            }
        }
     
     @objc func changeVideoList(){
          useCase.fetchDoDontVideo { (state) in
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
                       self.showErrorMessageAlertWithClose(message: Const.instance.unknownError)
                   default :
                       print("other")
                   }
                   
               }
         lyVideo.animatePress()
         lyRealNew.backgroundColor = .white
         lyVideo.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
         lyNewPager.isHidden = true
         tbVideo.isHidden = false
         lbRealNew.textColor = .black
         lbVideo.textColor = .white
     }
    
    
    
    func initPager(){
        
        for index in 1...23 {
            inputSource.append(ImageSource(image: UIImage(named: "do_and_dont_\(index)")!))
        }
        
        lyPagerContainer.delegate = self
        lyPagerContainer.pageIndicator = nil
        lyPagerContainer.zoomEnabled = true
        lyPagerContainer.setImageInputs(inputSource)
        self.totalCount = inputSource.count
        bindDataInImageIndex()
        btnPrevious.isHidden = true
    }
    
    
    @IBAction func btnNextPressed(_ sender: Any) {
        lyPagerContainer.nextPage(animated: true)
        
    }
    
    @IBAction func btnPreviousPressed(_ sender: Any) {
        lyPagerContainer.previousPage(animated: true)
    }
    
    func addChildVc(){
        let controller = NoticePagerVc()
        addChild(controller)
        self.lyPagerContainer.addSubview(controller.view)
        controller.view.frame = lyPagerContainer.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.didMove(toParent: self)
    }
    
}
extension SafeNoticeVc : ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        currentCount = page
        bindDataInImageIndex()
        if(page == 0){
            btnPrevious.isHidden = true
        }else{
            btnPrevious.isHidden = false
        }
    }
}


extension SafeNoticeVc  : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "YoutubeVc") as! YoutubeVc
                   vc.videoId = self.videoList[indexPath.row].id
                   self.present(vc, animated: true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VCell", for: indexPath) as! VideoCell
                   cell.selectionStyle = .none
                   cell.lbTitle.text = videoList[indexPath.row].title
                   cell.iv.kf.setImage(with: URL(string: videoList[indexPath.row].image)!)
                   return cell
    }
    
    
 
    
}
