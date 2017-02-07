//
//  GroceryStoreViewController.swift
//  SPORK
//
//  Created by Kimberly Skipper on 2/7/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GroceryStoreViewController: UIViewController, CLLocationManagerDelegate
    
{
    //this variable gives you access to the location manager throughout the view controller.
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad()
    
    {
        super.viewDidLoad()
        
        title = "Local Grocery Stores"
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location services
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse
        {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
            //pinned current location done in storyboard
            
            //zooms in on approx 15 mile radius of location.
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
            print("location:: \(location)")
            
           // http://www.techotopia.com/index.php/Working_with_MapKit_Local_Search_in_iOS_8_and_Swift
            
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Groceries"
            request.region = mapView.region
            
            let search = MKLocalSearch(request: request)
            
            search.start(completionHandler: {(response, error) in
                
                if error != nil {
                    print("Error occured in search:\(error!.localizedDescription)")
                } else if response!.mapItems.count == 0 {
                    print("No matches found")
                } else {
                    print("Matches found")
                    
                    for item in response!.mapItems {
                        print("Name = \(item.name)")
                        print("Phone = \(item.phoneNumber)")
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        self.mapView.addAnnotation(annotation)
                        
                        
                    }
                    
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("error:: (error)")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
