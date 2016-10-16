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

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var scanInformationLabel: UILabel!
    @IBOutlet weak var ownDeviceNameLabel: UILabel!
    @IBOutlet weak var ownDeviceAddressLabel: UILabel!
    @IBOutlet weak var devicesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bluetoothDevices.append(BluetoothDevice(name: "Matt's iPhone", uuid: "D6B7DDF5-62F1-4F8D-9B99-809479967C4A"))
        bluetoothDevices.append(BluetoothDevice(name: "Krissie phone", uuid: "8DBA448D-0F4E-44E5-97DB-B0BDC0E1931C"))
        bluetoothDevices.append(BluetoothDevice(name: "James' tablet", uuid: "34DAA315-FF62-4BCA-B3F9-6AB3E9D6D8FD"))
        bluetoothDevices.append(BluetoothDevice(name: "MatthieudeWit-MacbookPro", uuid: "44DD37F5-D39C-4672-BEB0-6E435BF15E5D"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startOrStopScanning() {
        
        isScanning = !isScanning
        
        if isScanning {
            bluetoothDevices.removeAll()
            bluetoothDevices.append(BluetoothDevice(name: "Pimmie", uuid: "FC8B2555-02FB-43BD-AE84-E6CFACAC89A6"))
            bluetoothDevices.append(BluetoothDevice(name: "BT headset", uuid: "660C9774-26D0-4D7D-B2C9-3D2D1B3DC1E6"))
            bluetoothDevices.append(BluetoothDevice(name: "Laptop_Paul", uuid: "CB8ADDEF-7524-4FDF-8310-BA221031D784"))
            bluetoothDevices.append(BluetoothDevice(name: "Matt iPhone 7", uuid: "A78446D6-F900-464D-8AB9-5428908811D2"))
            devicesTableView.reloadData()
        }
        else {
            bluetoothDevices.removeAll()
            devicesTableView.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bluetoothDevices.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = bluetoothDevices[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "deviceDetailsSegue", sender: bluetoothDevices[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest = segue.destination as! DeviceDetailViewController
        guest.selectedDevice = sender as! BluetoothDevice
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

