//
//  CoffeeAnnotation.swift
//  Coffee
//
//  Created by Justin Tsou on 2019/3/21.
//  Copyright © 2019 iOS9487. All rights reserved.
//

import UIKit
import MapKit

class CoffeeAnnotation:NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageName: String?
    
    init(coffeeLocation:CLLocationCoordinate2D) {
        self.coordinate = coffeeLocation
    }
}
