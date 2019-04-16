//
//  CallOutCoffeeAnnotationView.swift
//  Coffee
//
//  Created by Justin Tsou on 2019/3/21.
//  Copyright © 2019 iOS9487. All rights reserved.
//

import UIKit
import MapKit

enum RatingType: Int {
    case VeryPoor
    case VeryBad
    case Bad
    case Normal
    case Good
    case Excellent
    
    static func getRatingType() -> Array<RatingType> {
        return [.VeryPoor, .VeryBad, .Bad, .Normal, .Good, .Excellent]
    }
}

protocol CallOutCoffeeAnnotationViewDelegate:class {
    func tapNavigationAction(coffeeModel:CoffeeModel)
}

class CallOutCoffeeAnnotationView: MKAnnotationView {
    private var callOutCoffeeAnnotation: CallOutCoffeeAnnotation?
    weak var delegate:CallOutCoffeeAnnotationViewDelegate?
    var containerViewFrame: CGRect?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        
        self.callOutCoffeeAnnotation = annotation as? CallOutCoffeeAnnotation
        
        guard let coffeeCallOutAnnotation = self.callOutCoffeeAnnotation,
            let coffeeModel = coffeeCallOutAnnotation.coffeeModel,
            let title = coffeeCallOutAnnotation.title,
            let subtitle = coffeeCallOutAnnotation.subtitle else {
                return
        }
        
        switch coffeeCallOutAnnotation.category {
        case .Distance:
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "CallOutCoffeeDistanceContainerView", bundle: bundle)
            let view = nib.instantiate(withOwner: self, options: nil).first as? CallOutCoffeeDistanceContainerView
            
            guard let containerView = view else {
                return
            }
            
            let frameHeight = containerView.calculateCoffeeDistanceContainerViewFrameHeigh(text: title, bounds: containerView.bounds)
            self.containerViewFrame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: frameHeight)
            containerView.delegate = self
            containerView.setupCallOutCoffeeDistanceContainerView(frame: self.containerViewFrame!)
            self.addSubview(containerView)
            
            containerView.titleString.text = title
            containerView.subTitleString.text = subtitle
            containerView.setSubTitleLabelAnimation()
            let categoryImageName = self.accordingCategoryDecideImageName(category: coffeeCallOutAnnotation.category)
            containerView.animationForImageView(imageView: containerView.categoryIconImageView, imageName: categoryImageName, delay: 0.7)
            
            break
        case .Wifi,.Quiet,.Tasty,.Seat:
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "CallOutCoffeeContainerView", bundle: bundle)
            let view = nib.instantiate(withOwner: self, options: nil).first as? CallOutCoffeeContainerView
            
            guard let containerView = view else {
                return
            }
            
            let frameHeight = containerView.calculateCoffeeContainerViewFrameHeigh(text: title, bounds: containerView.bounds)
            self.containerViewFrame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: frameHeight)
            containerView.delegate = self
            containerView.setupCallOutCoffeeContainerView(frame: self.containerViewFrame!)
            self.addSubview(containerView)
            
            containerView.titleString.text = title
            containerView.subTitleString.text = subtitle
            let rating = self.accordingCategoryDecideRating(category: coffeeCallOutAnnotation.category , coffeeModel: coffeeModel)
            containerView.setRatingImage(rating: rating)
            containerView.setSubTitleLabel(rating: rating)
            containerView.setImageViewAnimation(rating: rating)
            containerView.setSubTitleLabelAnimation(ishidden: containerView.subTitleString.isHidden)
            let categoryImageName = self.accordingCategoryDecideImageName(category: coffeeCallOutAnnotation.category)
            containerView.animationForImageView(imageView: containerView.categoryIconImageView, imageName: categoryImageName, delay: 0.7)
            
            break
        }
        
        
    }
    
    private func accordingCategoryDecideImageName(category:CategoryType) -> String {
        var imageName = ""
        switch category {
        case .Distance:
            imageName = "Distance"
            break
        case .Wifi:
            imageName = "Wifi"
            break
        case .Quiet:
            imageName = "Quiet"
            break
        case .Tasty:
            imageName = "Tasty"
            break
        case .Seat:
            imageName = "Seat"
            break
        }
        return imageName
    }
    
    private func accordingCategoryDecideRating(category:CategoryType, coffeeModel:CoffeeModel) -> Int {
        var rating:Int = 0
        switch category {
        case .Distance:
            break
        case .Wifi:
            rating = coffeeModel.wifi ?? 0
            break
        case .Quiet:
            rating = coffeeModel.quiet ?? 0
            break
        case .Tasty:
            rating = coffeeModel.tasty ?? 0
            break
        case .Seat:
            rating = coffeeModel.seat ?? 0
            break
        }
        return rating
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside = rect.contains(point)
        
        if (!isInside) {
            for subview in subviews {
                isInside = subview.frame.contains(point)
                
                if (isInside) {
                    break
                }
            }
        }
        
        return isInside;
    }
}

extension CallOutCoffeeAnnotationView: CallOutCoffeeContainerViewDelegate {
    func tapNavagiationButton() {
        guard let coffeeAnnotation = self.callOutCoffeeAnnotation,
            let coffeeModel =  coffeeAnnotation.coffeeModel else {
                return
        }
        self.delegate?.tapNavigationAction(coffeeModel:coffeeModel)
    }
}

extension CallOutCoffeeAnnotationView: CallOutCoffeeDistanceContainerViewDelegate {
    func tapCoffeeDistanceContainerViewNavagiationButton() {
        guard let coffeeAnnotation = self.callOutCoffeeAnnotation,
            let coffeeModel =  coffeeAnnotation.coffeeModel else {
                return
        }
        self.delegate?.tapNavigationAction(coffeeModel:coffeeModel)
    }
}
