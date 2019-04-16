//
//  CalculateDistanceUtility.swift
//  Coffee
//
//  Created by Justin Tsou on 2019/2/26.
//  Copyright © 2019 iOS9487. All rights reserved.
//

import Foundation
import MapKit

class CalculateDistanceUtility {

    class  func CalculateBetweenSourceAndDestinationDistance(userLocation:CLLocation, coffeeModel:CoffeeModel) -> Int  {
        let location = CLLocation(latitude: CLLocationDegrees(coffeeModel.latitude!)!, longitude: CLLocationDegrees(coffeeModel.longitude!)!)
        let distance = userLocation.distance(from: location)
        
        return Int(distance)
    }
    
    class func distanceConvert(distance:Int) -> String {
        
        let defaultDistance: Int = 1000  //定義距離1000公尺做基本公里數轉換
        var distanceText = "\(Int(distance)) 公尺"
        if Int(distance) > defaultDistance {
            let distanceTransform = Float(distance)/Float(defaultDistance)
            distanceText = "\(String(format:"%.2f",distanceTransform)) 公里"
        }
        return distanceText
    }
    
}
