//
//  CallOutCoffeeContainerView.swift
//  Coffee
//
//  Created by Justin Tsou on 2019/3/21.
//  Copyright © 2019 iOS9487. All rights reserved.
//

import UIKit

protocol CallOutCoffeeContainerViewDelegate : class {
    func tapNavagiationButton()
}

class CallOutCoffeeContainerView: UIView {
    
    @IBOutlet weak var titleString: UILabel!
    @IBOutlet weak var subTitleString: UILabel!
    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var starImage1: UIImageView!
    @IBOutlet weak var starImage2: UIImageView!
    @IBOutlet weak var starImage3: UIImageView!
    @IBOutlet weak var starImage4: UIImageView!
    @IBOutlet weak var starImage5: UIImageView!
    weak var delegate: CallOutCoffeeContainerViewDelegate?
    
    //titleString 上方間距 5 + subTitleString 本身高度 25 + subTitleString 上方間距 5 + subTitleString 下方間距 5 = 40
    private let componentlayoutConstraintHeight: CGFloat = 40
    
    //Button 固定寬度 50 + Button 右邊間距 8 + Button 左邊間距 8 + titleString 左邊間距 8 + 微調 2 = 76
    private let componentTotalLayoutConstraint: CGFloat = 76
    
    @IBAction func tapCoffeeContainerViewNavagiationButton(_ sender: UIButton) {
        self.delegate?.tapNavagiationButton()
    }
    
    func setupCallOutCoffeeContainerView(frame: CGRect) {
        self.frame = frame
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor(red: 187.0/255.0, green: 85.0/255.0, blue: 0.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 2
        self.navigationButton.layer.masksToBounds = true
        self.navigationButton.layer.cornerRadius = 10
    }
    
    func setSubTitleLabel(rating: Int) {
        let ratingValue = RatingType.getRatingType()
        switch ratingValue[rating] {
        case .VeryPoor:
            self.hiddenLabel(label: self.subTitleString, isHidden: false)
            break
        case .VeryBad,.Bad,.Normal,.Good,.Excellent:
            self.hiddenLabel(label: self.subTitleString, isHidden: true)
            break
        }
    }
    
    func setSubTitleLabelAnimation(ishidden:Bool) {
        guard !ishidden else {
            return
        }
        self.subTitleString.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
            self.subTitleString.transform = .identity
        }, completion: nil)
    }
    
    func setRatingImage(rating: Int) {
        
        let ratingValue = RatingType.getRatingType()
        switch ratingValue[rating] {
        case .VeryPoor:
            self.hiddenImageView(imageView: self.starImage1, isHidden: true)
            self.hiddenImageView(imageView: self.starImage2, isHidden: true)
            self.hiddenImageView(imageView: self.starImage3, isHidden: true)
            self.hiddenImageView(imageView: self.starImage4, isHidden: true)
            self.hiddenImageView(imageView: self.starImage5, isHidden: true)
            break
            
        case .VeryBad:
            self.hiddenImageView(imageView: self.starImage1, isHidden: false)
            self.hiddenImageView(imageView: self.starImage2, isHidden: true)
            self.hiddenImageView(imageView: self.starImage3, isHidden: true)
            self.hiddenImageView(imageView: self.starImage4, isHidden: true)
            self.hiddenImageView(imageView: self.starImage5, isHidden: true)
            break
            
        case .Bad:
            self.hiddenImageView(imageView: self.starImage1, isHidden: false)
            self.hiddenImageView(imageView: self.starImage2, isHidden: false)
            self.hiddenImageView(imageView: self.starImage3, isHidden: true)
            self.hiddenImageView(imageView: self.starImage4, isHidden: true)
            self.hiddenImageView(imageView: self.starImage5, isHidden: true)
            break
            
        case .Normal:
            self.hiddenImageView(imageView: self.starImage1, isHidden: false)
            self.hiddenImageView(imageView: self.starImage2, isHidden: false)
            self.hiddenImageView(imageView: self.starImage3, isHidden: false)
            self.hiddenImageView(imageView: self.starImage4, isHidden: true)
            self.hiddenImageView(imageView: self.starImage5, isHidden: true)
            break
            
        case .Good:
            self.hiddenImageView(imageView: self.starImage1, isHidden: false)
            self.hiddenImageView(imageView: self.starImage2, isHidden: false)
            self.hiddenImageView(imageView: self.starImage3, isHidden: false)
            self.hiddenImageView(imageView: self.starImage4, isHidden: false)
            self.hiddenImageView(imageView: self.starImage5, isHidden: true)
            break
            
        case .Excellent:
            self.hiddenImageView(imageView: self.starImage1, isHidden: false)
            self.hiddenImageView(imageView: self.starImage2, isHidden: false)
            self.hiddenImageView(imageView: self.starImage3, isHidden: false)
            self.hiddenImageView(imageView: self.starImage4, isHidden: false)
            self.hiddenImageView(imageView: self.starImage5, isHidden: false)
            break
        }
    }
    
    func setImageViewAnimation(rating:Int) {
        
        let ratingValue = RatingType.getRatingType()
        switch ratingValue[rating] {
        case .VeryPoor:
            break
        case .VeryBad:
            self.animationForImageView(imageView: self.starImage1, imageName: "Star", delay: 1)
            break
        case .Bad:
            self.animationForImageView(imageView: self.starImage1, imageName: "Star", delay: 1)
            self.animationForImageView(imageView: self.starImage2, imageName: "Star", delay: 1.3)
            break
        case .Normal:
            self.animationForImageView(imageView: self.starImage1, imageName: "Star", delay: 1)
            self.animationForImageView(imageView: self.starImage2, imageName: "Star", delay: 1.3)
            self.animationForImageView(imageView: self.starImage3, imageName: "Star", delay: 1.6)
            break
        case .Good:
            self.animationForImageView(imageView: self.starImage1, imageName: "Star", delay: 1)
            self.animationForImageView(imageView: self.starImage2, imageName: "Star", delay: 1.3)
            self.animationForImageView(imageView: self.starImage3, imageName: "Star", delay: 1.6)
            self.animationForImageView(imageView: self.starImage4, imageName: "Star", delay: 1.9)
            break
        case .Excellent:
            self.animationForImageView(imageView: self.starImage1, imageName: "Star", delay: 1)
            self.animationForImageView(imageView: self.starImage2, imageName: "Star", delay: 1.3)
            self.animationForImageView(imageView: self.starImage3, imageName: "Star", delay: 1.6)
            self.animationForImageView(imageView: self.starImage4, imageName: "Star", delay: 1.9)
            self.animationForImageView(imageView: self.starImage5, imageName: "Star", delay: 2.2)
            break
        }
    }
    
    func animationForImageView(imageView: UIImageView, imageName:String, delay: TimeInterval) {
        imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1, delay: delay, options: .curveEaseIn, animations: {
            imageView.image = UIImage(named: imageName)
            imageView.transform = .identity
        }, completion: nil)
    }
    
    func calculateCoffeeContainerViewFrameHeigh(text:String, bounds: CGRect) -> CGFloat {
        
        let frameHeight = CalculateViewFrameHeighUtility.calculateViewFrameHeigh(text: text, bounds: bounds, layoutConstraintHeight: self.componentlayoutConstraintHeight, componentTotalLayoutConstraint: self.componentTotalLayoutConstraint)
        
        return frameHeight
    }
    
    private func hiddenImageView(imageView: UIImageView, isHidden: Bool)
    {
        imageView.isHidden = isHidden
    }
    
    private func hiddenLabel(label: UILabel, isHidden: Bool)
    {
        label.isHidden = isHidden
    }
}
