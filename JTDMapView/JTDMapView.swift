//
//  CoffeeMapView.swift
//  Coffee
//
//  Created by Justin Tsou on 2019/3/19.
//  Copyright © 2019 iOS9487. All rights reserved.
//

import UIKit
import MapKit

public enum CategoryType: String {
    case Distance = "距離"
    case Wifi = "網路"
    case Quiet = "安靜"
    case Tasty = "美味"
    case Seat = "座位"
    
    public static func getCategoryAllTypeRawValue() -> Array<String> {
        return [Distance.rawValue, Wifi.rawValue, Quiet.rawValue, Tasty.rawValue, Seat.rawValue]
    }
}

public protocol JTDMapViewDelegate: class {
    func tapNavigationButton(coffeeModel: CoffeeModel)
}

public class JTDMapView: UIView {
    
    @IBOutlet var contentView: UIView!
    private var cafeMapView: CafeMapView!
    public weak var delegate: JTDMapViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupMapView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.setupMapView()
    }
    
    public func updateCoffeeShop(coffeeModel:CoffeeModel, category:CategoryType) {
        self.cafeMapView.updateCoffeeShop(coffeeModel: coffeeModel, category: category)
    }
    
    private func setupMapView() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "JTDMapView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        contentView.frame = bounds
        
        self.cafeMapView = CafeMapView(frame: contentView.frame)
        self.cafeMapView.delegates = self
        self.cafeMapView.mapType = .standard
        
        // 是否顯示自身定位位置，地圖不會縮放，當用戶位置移動時地圖不會跟隨用戶位置移動而移動
        self.cafeMapView.showsUserLocation = true
        
        // 是否顯示自身定位位置，地圖縮放到一定比例，當用戶位置移動時地圖會跟隨用戶位置移動而移動
        self.cafeMapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        self.cafeMapView.isZoomEnabled = true      // 是否允許縮放地圖
        self.cafeMapView.isScrollEnabled = true    // 是否允許滾動
        self.cafeMapView.isRotateEnabled = true    // 是否允許旋轉
        self.cafeMapView.isPitchEnabled = false    // 是否允許顯示 3D
        self.cafeMapView.showsCompass = true       // 是否顯示指南針
        self.cafeMapView.showsScale = true         // 是否顯示比例尺
        self.cafeMapView.showsTraffic = true       // 是否顯示交通
        self.cafeMapView.showsBuildings = true     // 是否顯示建築物
        
        contentView.addSubview(self.cafeMapView)
        addSubview(contentView)
    }
}

extension JTDMapView: CafeMapViewDelegate {
    func tapNavigationButton(coffeeModel: CoffeeModel) {
        self.delegate?.tapNavigationButton(coffeeModel: coffeeModel)
    }
}
