//
//  CallOutCoffeeDistanceContainerView.swift
//  Coffee
//
//  Created by Justin Tsou on 2019/4/1.
//  Copyright © 2019 iOS9487. All rights reserved.
//

import UIKit

protocol CallOutCoffeeDistanceContainerViewDelegate : class {
    func tapCoffeeDistanceContainerViewNavagiationButton()
}

class CallOutCoffeeDistanceContainerView: UIView {
    
    @IBOutlet weak var titleString: UILabel!
    @IBOutlet weak var subTitleString: UILabel!
    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var navigationButton: UIButton!
    
    weak var delegate: CallOutCoffeeDistanceContainerViewDelegate?
    
    //titleString 上方間距 5 + subTitleString 本身高度 25 + subTitleString 上方間距 5 + subTitleString 下方間距 5 = 40
    private let componentlayoutConstraintHeight: CGFloat = 40
    
    //Button 固定寬度 50 + Button 右邊間距 8 + Button 左邊間距 8 + titleString 左邊間距 8 + 微調 2 = 76
    private let componentTotalLayoutConstraint: CGFloat = 76
    
    @IBAction func tapCoffeeContainerViewNavagiationButton(_ sender: UIButton) {
        self.delegate?.tapCoffeeDistanceContainerViewNavagiationButton()
    }
    
    func setupCallOutCoffeeDistanceContainerView(frame: CGRect) {
        self.frame = frame
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor(red: 187.0/255.0, green: 85.0/255.0, blue: 0.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 2
        self.navigationButton.layer.masksToBounds = true
        self.navigationButton.layer.cornerRadius = 10
    }
    
    func setSubTitleLabelAnimation() {
        self.subTitleString.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
            self.subTitleString.transform = .identity
        }, completion: nil)
    }
    
    func animationForImageView(imageView: UIImageView, imageName:String, delay: TimeInterval) {
        imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1, delay: delay, options: .curveEaseIn, animations: {
            imageView.image = UIImage(named: imageName)
            imageView.transform = .identity
        }, completion: nil)
    }
    
    func calculateCoffeeDistanceContainerViewFrameHeigh(text:String, bounds: CGRect) -> CGFloat {
        
        let frameHeight = CalculateViewFrameHeighUtility.calculateViewFrameHeigh(text: text, bounds: bounds, layoutConstraintHeight: self.componentlayoutConstraintHeight, componentTotalLayoutConstraint: self.componentTotalLayoutConstraint)
        
        return frameHeight
    }
}
