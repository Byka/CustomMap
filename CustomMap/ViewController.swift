//
//  ViewController.swift
//  CustomMap
//
//  Created by Suresh Reddy Yerasi on 18/07/18.
//  Copyright © 2018 Delta Technology And Management Services Private Limited. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    var tileRenderer: MKTileOverlayRenderer!
    
    
    let locationManager = CLLocationManager()
   
    let places = Place.getPlaces()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib. 17.4405, 78.39264
        
        self.setupTileRenderer()
        
        
        requestLocationAccess()
        addAnnotations()
        addPolyline()
        addPolygon()
        
        //let initialRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 17.4405, longitude: 78.39264), span: MKCoordinateSpan(latitudeDelta: 0.000005, longitudeDelta: 0.000005))
        
//        let location = CLLocationCoordinate2D(latitude: 17.4405,longitude: 78.39264)
//
//
//        let span = MKCoordinateSpanMake(0.10, 0.10)
//        let region = MKCoordinateRegion(center: location, span: span)
//        mapView.setRegion(region, animated: true)
        
        
        //mapView.region = initialRegion
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
        
        // 2.
        let sourceLocation = CLLocationCoordinate2D(latitude: 17.4406921, longitude: 78.3930128)
        let destinationLocation = CLLocationCoordinate2D(latitude: 17.4402844, longitude: 78.3922427)
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "LUCKY"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Trishul Grand"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        
    }
        
    }
    
    
//    func addPolyline() {
//        var locations = places.map { $0.coordinate }
//        let polyline = MKPolyline(coordinates: &locations, count: locations.count)
//
//        mapView?.add(polyline)
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self as MKMapViewDelegate
    }
    
    func setupTileRenderer() {
       
        let overlay = CustomMapOverLay()
        
        overlay.canReplaceMapContent = true
        mapView.add(overlay, level: .aboveLabels)
        tileRenderer = MKTileOverlayRenderer(tileOverlay: overlay)
        
        
        overlay.minimumZ = 19
        overlay.maximumZ = 19
        
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    
    func addAnnotations() {
        mapView?.delegate = self
        mapView?.addAnnotations(places)
        
        let overlays = places.map { MKCircle(center: $0.coordinate, radius: 100) }
        mapView?.addOverlays(overlays)
        
        // Add polylines
        
        //        var locations = places.map { $0.coordinate }
        //        print("Number of locations: \(locations.count)")
        //        let polyline = MKPolyline(coordinates: &locations, count: locations.count)
        //        mapView?.add(polyline)
        
    }
    
    func addPolyline() {
        var locations = places.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: &locations, count: locations.count)
        
        mapView?.add(polyline)
    }
    
    func addPolygon() {
        var locations = places.map { $0.coordinate }
        let polygon = MKPolygon(coordinates: &locations, count: locations.count)
        mapView?.add(polygon)
    }
}

// MARK: - MapView Delegate
extension ViewController: MKMapViewDelegate {
    
    /*
    private func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.strokeColor = UIColor.red
//        renderer.lineWidth = 4.0
//        return renderer
        return tileRenderer

    }
    */
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
            
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "ic_place")
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView.canShowCallout = true
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
       
        
        
        if overlay is MKTileOverlayRenderer {
            return tileRenderer

        }/*else if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
            
        }*/ else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
            
        } /*else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 2
            return renderer
        }*/
        
        //return MKOverlayRenderer()
        return tileRenderer

    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? Place, let title = annotation.title else { return }
        
        let alertController = UIAlertController(title: "Welcome to \(title)", message: "You've selected \(title)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

