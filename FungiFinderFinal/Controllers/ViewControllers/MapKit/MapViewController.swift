//
//  MapViewController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/5/21.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet private var mapView: MKMapView!
    
    //MARK: - PROPERTIES
    // Gets location of device
    let manager = CLLocationManager()
    var observation: Observation?

    
    //MARK: - LIFECYCLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupViews()
        
    }
    
    //MARK: - TEST
    
    
    //MARK: - PERMISSIONS
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        // App first launched, hasn't determined
        case .notDetermined:
            // For use when the app is open, & in the background
            manager.requestAlwaysAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
            // For use when the app is open
        case .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
        
        switch manager.accuracyAuthorization {
        
        case .fullAccuracy:
            break
        case .reducedAccuracy:
            break
        @unknown default:
            break
        }
        // This will update us along the way, as the user has our app
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Status is the outcome of our ability to use their location, where were checking if there's been changes
        switch status {
        case .restricted:
            print("\nUsers location is restricted")
            
        case .denied:
            print("\nUser denied access to use their location\n")
            
        case .authorizedWhenInUse:
            print("\nuser granted authorizedWhenInUse\n")
            
        case .authorizedAlways:
            print("\nuser selected authorizedAlways\n")
            
        default: break
        }
    }
    
    //MARK: - HELPER METHODS
    func setupViews() {
        // Set accuracy for location
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // set delegate for location
        manager.delegate = self
        // Request permission
        manager.requestWhenInUseAuthorization()
        // Fetch location
        manager.startUpdatingLocation()
        // Set delegate for mapView
        mapView.delegate = self
        // Allows reaction to touch on map (tap recognizer)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
            gestureRecognizer.delegate = self
            mapView.addGestureRecognizer(gestureRecognizer)
    }
// Handles the tap & gets location coordinates
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        // Add annotation(pin):
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        //annotation.title
        //annotation.subtitle
    }
    
    // Delegate function; gets called when location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //let userLocation = location.coordinate
            //userLocation.latitude
            //userLocation.longitude
            manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    // Zoom into map on location, & add pin
    func render(_ location: CLLocation) {
        // The latitude and longitude associated with a location
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        // The width and height of a map region.
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        // Set maps region(view)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        //mapView.addAnnotation(pin)
    }
    // Set custom image for map pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
        annotationView.image = #imageLiteral(resourceName: "fungiPoint2")
        annotationView.canShowCallout = true
        return annotationView
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}// End of Class

