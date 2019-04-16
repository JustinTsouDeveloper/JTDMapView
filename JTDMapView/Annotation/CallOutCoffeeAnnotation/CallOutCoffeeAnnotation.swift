//
//  CallOutCoffeeAnnotation.swift
//  Coffee
//
//  Created by Justin Tsou on 2019/3/21.
//  Copyright © 2019 iOS9487. All rights reserved.
//

import UIKit
import MapKit

class CallOutCoffeeAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageName: String?
    var category: CategoryType
    var coffeeModel: CoffeeModel?
    
    init(coffeeCoordinate:CLLocationCoordinate2D, category:CategoryType) {
        self.coordinate = coffeeCoordinate
        self.category = category
    }
}
