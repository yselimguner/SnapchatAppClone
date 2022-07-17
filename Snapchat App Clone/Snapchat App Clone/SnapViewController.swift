//
//  SnapViewController.swift
//  Snapchat App Clone
//
//  Created by Yavuz Güner on 15.07.2022.
//

import UIKit
import ImageSlideshow
import Kingfisher
import ImageSlideshowKingfisher

class SnapViewController: UIViewController {

    @IBOutlet weak var timeLeftLabel : UILabel!
    
    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()
    override func viewDidLoad() {
        super.viewDidLoad()


        if let snap = selectedSnap {
            
            timeLeftLabel.text = "Time Left : \(snap.timeDifferance)"
            
            for imageUrl in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.backgroundColor = UIColor.white
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLeftLabel)
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
