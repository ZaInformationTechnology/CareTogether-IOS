//
//  SafeNoticeVc.swift
//  CareTogether
//
//  Created by HeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import ImageSlideshow

class SafeNoticeVc: UIViewController {
    
    
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    
    @IBOutlet weak var lyRealNew: UIView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lyControlFrame: UIView!
    @IBOutlet weak var lyPagerContainer: ImageSlideshow!
    var totalCount = 0
    var currentCount = 0
    var inputSource = [ImageSource]()
    func bindDataInImageIndex(){
        lbCount.text = "\(currentCount + 1)/\(totalCount)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lyPagerContainer.roundedTop()
        lyControlFrame.roundedBottom()
        
        let realNewTap = UITapGestureRecognizer(target: self, action: #selector(goRealNewVc))
        lyRealNew.addGestureRecognizer(realNewTap)
        
        initPager()
        
    }
    
    
    @objc func goRealNewVc(){
        lyRealNew.animatePress()
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewController(withIdentifier: "RealNewVc") as! RealNewVc, animated: true)
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
