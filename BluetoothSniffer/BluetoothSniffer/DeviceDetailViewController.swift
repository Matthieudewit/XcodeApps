//
//  DeviceDetailViewController.swift
//  BluetoothSniffer
//
//  Created by Matthieu de Wit on 16-10-16.
//  Copyright © 2016 MdW Development. All rights reserved.
//

import UIKit
import CoreLocation

class DeviceDetailViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceAddressLabel: UILabel!
    @IBOutlet weak var deviceMajorLabel: UILabel!
    @IBOutlet weak var deviceMinorLabel: UILabel!
    @IBOutlet weak var deviceLocationLabel: UILabel!
    
    var rssiStrength: Int = 0 {
        willSet {
            
        }
        
        didSet {
            if rssiStrength >= -50 && rssiStrength < 0 {
                self.view.backgroundColor = colors[CLProximity.immediate]
            }
            else if rssiStrength >= -65 && rssiStrength < -50  {
                self.view.backgroundColor = colors[CLProximity.near]
            }
            else if rssiStrength >= -100 && rssiStrength < -65  {
                self.view.backgroundColor = colors[CLProximity.far]
            }
            else {
                self.view.backgroundColor = colors[CLProximity.unknown]
            }
        }
    }
    
    var selectedDevice: BluetoothDevice = BluetoothDevice()
    let locationManager = CLLocationManager()
    
    let colors = [
        CLProximity.immediate: UIColor.green,
        CLProximity.near: UIColor.blue,
        CLProximity.far: UIColor.red,
        CLProximity.unknown: UIColor.darkGray
    ] as [AnyHashable : UIColor]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        deviceNameLabel.text = selectedDevice.name
        deviceAddressLabel.text = selectedDevice.uuid.description
        deviceMajorLabel.text = selectedDevice.major.description
        deviceMinorLabel.text = selectedDevice.minor.description
        deviceLocationLabel.text = selectedDevice.distance
        
        // Use locationManager to follow distance to object
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        let region = CLBeaconRegion(proximityUUID: selectedDevice.uuid, identifier: selectedDevice.name)
        locationManager.startRangingBeacons(in: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let beaconsFiltered = beacons.filter{ $0.minor.intValue == selectedDevice.minor }
        if beaconsFiltered.count > 0 {
            let wantedBeacon = beaconsFiltered[0]
            switch  wantedBeacon.proximity {
            case .immediate:
                self.view.backgroundColor = colors[CLProximity.immediate]
            case .near:
                self.view.backgroundColor = colors[CLProximity.near]
            case .far:
                self.view.backgroundColor = colors[CLProximity.far]
            default:
                self.view.backgroundColor = colors[CLProximity.unknown]
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
