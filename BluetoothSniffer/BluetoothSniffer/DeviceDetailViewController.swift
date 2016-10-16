//
//  DeviceDetailViewController.swift
//  BluetoothSniffer
//
//  Created by Matthieu de Wit on 16-10-16.
//  Copyright © 2016 MdW Development. All rights reserved.
//

import UIKit

class DeviceDetailViewController: UIViewController {

    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceAddressLabel: UILabel!
    @IBOutlet weak var deviceMajorLabel: UILabel!
    @IBOutlet weak var deviceMinorLabel: UILabel!
    @IBOutlet weak var deviceLocationLabel: UILabel!
    
    var selectedDevice: BluetoothDevice = BluetoothDevice(name: "", uuid: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        deviceNameLabel.text = selectedDevice.name
        deviceAddressLabel.text = selectedDevice.uuid
        deviceMajorLabel.text = selectedDevice.major.description
        deviceMinorLabel.text = selectedDevice.minor.description
        deviceLocationLabel.text = selectedDevice.distance
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
