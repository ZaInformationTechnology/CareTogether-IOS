//
//  NotiDetailVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import JGProgressHUD
import ImageSlideshow
import Kingfisher
import SKPhotoBrowser

class NewDetailVc: UIViewController {
    
    var newsData : New?
    let useCase = NewUseCase()
    let hud = JGProgressHUD(style: .dark)
    @IBOutlet weak var lyPagerView: ImageSlideshow!
    
    @IBOutlet weak var lyContentView: UIView!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var contPagerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lyDetailToolbar: DetailToolbar!
    
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    var currentCount = 0
    var totalCount = 0
    var images = [String]()
    
    @IBAction func btnNext(_ sender: Any) {
        lyPagerView.nextPage(animated: true)
    }
    
    @IBAction func btnPreviousPressed(_ sender: Any) {
         lyPagerView.previousPage(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lyDetailToolbar.navigationController = self.navigationController
        hud.textLabel.text = "လုပ်ဆာင်နေပါသည်"
        guard let data = newsData else {
            return
        }
        
        useCase.fetchNewDetail(id: data.id) { (state) in
            switch state {
            case .Loading :
                self.showLoading(show: true)
            case .FetchNewDetailError :
                self.showLoading(show: false)
            case .FetchNewDetailSuccess(let response) :
                self.bindData(data: response)
                self.showLoading(show: false)
            default :
                print("other")
            }
        }
        
    }
    
    @IBAction func btnExpandPressed(_ sender: Any) {
        
        var images = [SKPhoto]()
        
        self.images.forEach { (item) in
            let photo = SKPhoto.photoWithImageURL(item)
            photo.shouldCachePhotoURLImage = true
            images.append(SKPhoto.photoWithImageURL(item))
        }
        
        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    func bindData(data : NewDetailResponse ){
        
        lbTitle.text = data.data.title
        lbContent.text = data.data.paragraphs.joined(separator: "  \n ")
        let images = data.data.images
        if(images != nil){
            if(!images!.isEmpty){
                bindPhotoInPager(images : images!)
            }else{
                hidePagerFrame()
            }
        }else{
            hidePagerFrame()
        }
        lyContentView.isHidden = false
    }
    
    func hidePagerFrame(){
        lyPagerView.isHidden = true
        contPagerViewHeight.constant = 0
        btnExpand.isHidden = true
        self.updateViewConstraints()
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    func bindPhotoInPager(images : [String]){
        var inputSource = [KingfisherSource]()
        images.forEach { (item) in
            inputSource.append(KingfisherSource(url: URL(string: item)!))
        }
        
        lyPagerView.delegate = self
        lyPagerView.pageIndicator = nil
        lyPagerView.zoomEnabled = true
        lyPagerView.setImageInputs(inputSource)
        self.totalCount = images.count
        bindDataInImageIndex()
        btnPrevious.isHidden = true
        self.images = images
    }
    
    private func showLoading(show : Bool){
        if(show){
            hud.show(in: self.view)
        }else{
            hud.dismiss(animated: true)
        }
    }
    
    func bindDataInImageIndex(){
         lbCount.text = "\(currentCount + 1)/\(totalCount)"
    }

    @IBOutlet weak var btnNext: UIButton!
}

extension NewDetailVc : ImageSlideshowDelegate {
    
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
