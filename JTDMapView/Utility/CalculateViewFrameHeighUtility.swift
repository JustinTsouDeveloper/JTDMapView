//
//  CalculateViewFrameHeighUtility.swift
//  Coffee
//
//  Created by Justin Tsou on 2019/4/2.
//  Copyright © 2019 iOS9487. All rights reserved.
//

import Foundation
import UIKit

class CalculateViewFrameHeighUtility {
    class func calculateViewFrameHeigh(text:String, bounds:CGRect, layoutConstraintHeight:CGFloat ,componentTotalLayoutConstraint:CGFloat) -> CGFloat {
        
        let stringHeight = self.accordingDescriptionDecideHeight(content: text, bounds: bounds, componentTotalLayoutConstraint: componentTotalLayoutConstraint)
        let frameHeight = stringHeight.height + layoutConstraintHeight
        return frameHeight
    }
    
    private class func accordingDescriptionDecideHeight(content:String , bounds:CGRect, componentTotalLayoutConstraint:CGFloat) -> CGSize {
        var textLabelSize:CGSize?
        let textFont = UIFont.systemFont(ofSize: 17)
        let textString = content
        
        let textMaxSize = CGSize(width: bounds.width - componentTotalLayoutConstraint , height: CGFloat(MAXFLOAT))
        textLabelSize = self.textSize(text:textString , font: textFont, maxSize: textMaxSize)
        
        return textLabelSize!
    }
    
    private class func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font :font], context: nil).size
    }

}

