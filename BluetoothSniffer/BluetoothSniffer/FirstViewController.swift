//
//  FirstViewController.swift
//  BluetoothSniffer
//
//  Created by Matthieu de Wit on 16-10-16.
//  Copyright © 2016 MdW Development. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var bluetoothDevices = [BluetoothDevice]()
//    var isScanning: Bool = false

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var scanInformationLabel: UILabel!
    @IBOutlet weak var ownDeviceNameLabel: UILabel!
    @IBOutlet weak var ownDeviceAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startOrStopScanning() {
        
        isScanning = !isScanning
        
        if isScanning {
            bluetoothDevices.append(BluetoothDevice(name: "Matt's iPhone", id: "3ce2ef69-4414-469d-9d55-3ec7fcc38520"))
            bluetoothDevices.append(BluetoothDevice(name: "Krissie phone", id: "3ce2ef69-4414-469d-9d55-3ec7fcc38520"))
            bluetoothDevices.append(BluetoothDevice(name: "James' tablet", id: "3ce2ef69-4414-469d-9d55-3ec7fcc38520"))
            bluetoothDevices.append(BluetoothDevice(name: "MatthieudeWit-MacbookPro", id: "3ce2ef69-4414-469d-9d55-3ec7fcc38520"))
        }
        else {
            bluetoothDevices.removeAll()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Test" + indexPath.row.description
        return cell
    }
    
    var isScanning: Bool = false {
        willSet {
            
        }
        
        didSet {
            if isScanning {
                print("isScanning is set to true")
                scanButtonText = "Stop"
                scanInformationLabelText = "scanning for devices..."
            }
            else {
                print("isScanning is set to false")
                scanButtonText = "Scan"
                scanInformationLabelText = "no scan in progress"
            }
        }
    }
    
    var scanButtonText: String {
        get { return scanButton.currentTitle! }
        set { scanButton.setTitle(newValue, for: UIControlState.normal) }
    }
    var scanInformationLabelText: String {
        get { return scanInformationLabel.text! }
        set { scanInformationLabel.text = newValue }
    }
    

}

