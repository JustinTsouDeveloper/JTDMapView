//
//  CafeMapView.swift
//  JTDMapView
//
//  Created by Justin Tsou on 2019/4/16.
//  Copyright © 2019 iOSDeveloper. All rights reserved.
//

import UIKit
import MapKit

protocol CafeMapViewDelegate: class {
    func tapNavigationButton(coffeeModel: CoffeeModel)
}

class CafeMapView: MKMapView {
    
    weak var delegates: CafeMapViewDelegate?
    private var coffeeModel: CoffeeModel?
    private var coffeeAnnotation: CoffeeAnnotation?
    private var calloutCoffeeAnnotation: CallOutCoffeeAnnotation?
    private var category: CategoryType?
    private let space:CGFloat = 5                                        //大頭針與 calloutView 之間的間距
    private let annotationImageHeigh:CGFloat = 64                        //大頭針圖片高度
    private let multiplyNumber:Double = 4
    //private let visibleAreaDistance = CLLocationDistance(exactly: 300)   //地圖可視範圍
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupMapView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        //fatalError("init(coder:) has not been implemented")
        self.setupMapView()
    }
    
    private func setupMapView() {
        self.delegate = self
        self.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MKAnnotationView")
    }
    
    func updateCoffeeShop(coffeeModel:CoffeeModel, category:CategoryType) {
        guard let _ = coffeeModel.name,
            let _ = coffeeModel.latitude,
            let _ = coffeeModel.longitude else {
                return
        }
        self.category = category
        self.coffeeModel = coffeeModel
        self.removeAnnotations(self.annotations)
        self.addCoffeeAnnotationOnMap(coffeeModel: coffeeModel)
        self.setCoffeeShopVisibleArea()
        self.addCalloutCoffeeAnnotationOnMap(coffeeModel: coffeeModel, category:category)
        self.setupRoute(userLocation: self.userLocation, coffeeModel:self.coffeeModel!, category:self.category!)
    }
    
    private func setupRoute(userLocation:MKUserLocation, coffeeModel:CoffeeModel, category:CategoryType) {
        
        //1.創建起始點和目的地的經緯度信息CLLocationCoordinate2D
        //SourceLocation 為當前使用者位置，DestinationLocation 為目的地位置
        let sourceLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude )
        
        //2.創建出發點和目的地信息MKPlacemark
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        
        //3.根據MKPlacemark創建出發節點和目的地節點MKMapItem
        let sourceMapItems = MKMapItem(placemark: sourcePlacemark)
        sourceMapItems.name = "我的位置"
        
        let location = CLLocationCoordinate2D(latitude: Double(coffeeModel.latitude!)! , longitude: Double(coffeeModel.longitude!)!)
        
        let destinationPlacemark = MKPlacemark(coordinate: location, addressDictionary: nil)
        let destinationMapItems = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.requestsAlternateRoutes = true
        directionRequest.source = sourceMapItems
        directionRequest.destination = destinationMapItems
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {[weak self] (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            
            self?.removeOverlays((self?.overlays)!)
            self?.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
    }
    
    private func addCoffeeAnnotationOnMap(coffeeModel: CoffeeModel) {
        self.coffeeAnnotation = self.getCoffeeAnnotationFromCoffeeModel(coffeeModel: coffeeModel)
        self.addAnnotation(self.coffeeAnnotation!)
    }
    
    private func addCalloutCoffeeAnnotationOnMap(coffeeModel: CoffeeModel, category:CategoryType) {
        self.calloutCoffeeAnnotation = self.getCallOutAnnotationOnMapFromCoffeeModel(coffeeModel:coffeeModel, category:category)
        self.addAnnotation(self.calloutCoffeeAnnotation!)
    }
    
    private func setCoffeeShopVisibleArea() {
        let coffeeLocation = CLLocation(latitude: CLLocationDegrees(coffeeModel!.latitude!)!, longitude: CLLocationDegrees(coffeeModel!.longitude!)!)
        let userLocation = CLLocation(latitude: CLLocationDegrees(self.userLocation.coordinate.latitude), longitude: CLLocationDegrees(self.userLocation.coordinate.longitude))
        let distance = userLocation.distance(from: coffeeLocation)
        
        let averageDistance = CLLocationCoordinate2DMake(CLLocationDegrees((userLocation.coordinate.latitude + coffeeLocation.coordinate.latitude)/2), CLLocationDegrees((userLocation.coordinate.longitude + coffeeLocation.coordinate.longitude))/2)
        
        let region = MKCoordinateRegion(center: averageDistance, latitudinalMeters: distance * self.multiplyNumber, longitudinalMeters: distance * self.multiplyNumber)
        
        self.setRegion(self.regionThatFits(region), animated: true)
    }
    
    private func getCallOutAnnotationOnMapFromCoffeeModel(coffeeModel: CoffeeModel, category:CategoryType) -> CallOutCoffeeAnnotation {
        let coffeeCoordinate = CLLocationCoordinate2DMake(Double(coffeeModel.latitude!)!, Double(coffeeModel.longitude!)!)
        let callOutCoffeeAnnotation = CallOutCoffeeAnnotation(coffeeCoordinate: coffeeCoordinate, category:category)
        callOutCoffeeAnnotation.title = coffeeModel.name
        callOutCoffeeAnnotation.subtitle = self.accordingCategoryDecideSubtitle(coffeeModel: coffeeModel, category: category)
        callOutCoffeeAnnotation.coffeeModel = coffeeModel
        callOutCoffeeAnnotation.category = category
        return callOutCoffeeAnnotation
    }
    
    private func getCoffeeAnnotationFromCoffeeModel(coffeeModel: CoffeeModel) -> CoffeeAnnotation {
        let coffeeLocation = CLLocationCoordinate2DMake(Double(coffeeModel.latitude!)!, Double(coffeeModel.longitude!)!)
        let coffeeAnnotation = CoffeeAnnotation(coffeeLocation: coffeeLocation)
        coffeeAnnotation.imageName = "pin_coffeeshop"
        return coffeeAnnotation
    }
    
    private func accordingCategoryDecideSubtitle(coffeeModel: CoffeeModel, category:CategoryType) -> String {
        var subtitle = ""
        switch category {
        case .Distance:
            let distance = CalculateDistanceUtility.CalculateBetweenSourceAndDestinationDistance(userLocation: self.userLocation.location!, coffeeModel: coffeeModel)
            let distanceText = CalculateDistanceUtility.distanceConvert(distance: Int(distance))
            subtitle = distanceText
            break
        case .Wifi:
            guard let wifi = coffeeModel.wifi,
                wifi != 0 else {
                    return "尚未評分"
            }
            subtitle = "Wifi:\(String(wifi))"
            break
        case .Quiet:
            guard let quiet = coffeeModel.quiet,
                quiet != 0 else {
                    return "尚未評分"
            }
            subtitle = "Wifi:\(String(quiet))"
            break
        case .Tasty:
            guard let tasty = coffeeModel.tasty,
                tasty != 0 else {
                    return "尚未評分"
            }
            subtitle = "Wifi:\(String(tasty))"
            break
        case .Seat:
            guard let seat = coffeeModel.seat,
                seat != 0 else {
                    return "尚未評分"
            }
            subtitle = "Wifi:\(String(seat))"
            break
        }
        return subtitle
    }
}

extension CafeMapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let coffeeModel = self.coffeeModel,
            let category = self.category else {
                return
        }
        self.setupRoute(userLocation: self.userLocation, coffeeModel:coffeeModel,category:category)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }else if annotation.isKind(of: CoffeeAnnotation.self) {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MKAnnotationView", for: annotation)
            let coffeeAnnotation = annotation as! CoffeeAnnotation
            let imageName = coffeeAnnotation.imageName!
            annotationView.image = UIImage(named: imageName)
            annotationView.annotation = coffeeAnnotation
            annotationView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            return annotationView
        }
        else if annotation.isKind(of: CallOutCoffeeAnnotation.self) {
            let annotationView = CallOutCoffeeAnnotationView(annotation: annotation, reuseIdentifier: "CallOutCoffeeAnnotationView")
            
            annotationView.transform  = CGAffineTransform(scaleX: 0, y: 1)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                annotationView.transform = .identity
                annotationView.delegate = self
                annotationView.annotation = annotation
                annotationView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
                annotationView.centerOffset = CGPoint(x: -(annotationView.containerViewFrame!.size.width/2), y: -(self.annotationImageHeigh + annotationView.containerViewFrame!.size.height + self.space))
                
            }, completion: nil)
            
            return annotationView
        }else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView", for: annotation)
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            annotationView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        var renderer = MKOverlayRenderer()
        if overlay.isKind(of: MKPolyline.self) {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor(red: 0.0, green: 102/255 , blue: 255/255, alpha: 1)
            polylineRenderer.lineWidth = 6.0
            renderer = polylineRenderer
        }
        return renderer
    }
}

extension CafeMapView: CallOutCoffeeAnnotationViewDelegate {
    func tapNavigationAction(coffeeModel: CoffeeModel) {
        guard let cafeModel = self.coffeeModel else {
            return
        }
        self.delegates?.tapNavigationButton(coffeeModel: cafeModel)
    }
}
