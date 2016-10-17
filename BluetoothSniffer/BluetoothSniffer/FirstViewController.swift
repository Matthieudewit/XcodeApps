//
//  FirstViewController.swift
//  BluetoothSniffer
//
//  Created by Matthieu de Wit on 16-10-16.
//  Copyright © 2016 MdW Development. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    
//    var bluetoothDevices = [BluetoothDevice]()
    var bluetoothDevices = [(BluetoothDevice, CBPeripheral)]()
//    var bluetoothPeripherals = [CBPeripheral]()
//    let locationManager = CLLocationManager()
    let centralManager = CBCentralManager()

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var scanInformationLabel: UILabel!
    @IBOutlet weak var ownDeviceNameLabel: UILabel!
    @IBOutlet weak var ownDeviceAddressLabel: UILabel!
    @IBOutlet weak var devicesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        centralManager.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startOrStopScanning() {
        
        isScanning = !isScanning
        
        if isScanning {
            
            bluetoothDevices.removeAll()
            devicesTableView.reloadData()
            
            // testdata
//            bluetoothDevices.append(BluetoothDevice(name: "Matt's iPhone", uuid: "D6B7DDF5-62F1-4F8D-9B99-809479967C4A"))
//            bluetoothDevices.append(BluetoothDevice(name: "Pimmie", uuid: "FC8B2555-02FB-43BD-AE84-E6CFACAC89A6"))
//            bluetoothDevices.append(BluetoothDevice(name: "BT headset", uuid: "660C9774-26D0-4D7D-B2C9-3D2D1B3DC1E6"))
//            bluetoothDevices.append(BluetoothDevice(name: "Laptop_Paul", uuid: "CB8ADDEF-7524-4FDF-8310-BA221031D784"))
//            bluetoothDevices.append(BluetoothDevice(name: "Matt iPhone 7", uuid: "A78446D6-F900-464D-8AB9-5428908811D2"))
//            devicesTableView.reloadData()
            
//            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
//            bluetoothDevices.removeAll()
//            devicesTableView.reloadData()
            
            centralManager.stopScan()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bluetoothDevices.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = bluetoothDevices[indexPath.row].description
        cell.textLabel?.text = bluetoothDevices[indexPath.row].0.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "deviceDetailsSegue", sender: bluetoothDevices[indexPath.row])
        
        let selectedDevice = bluetoothDevices[indexPath.row]
        
        centralManager.connect(selectedDevice.1, options: nil)
        performSegue(withIdentifier: "deviceDetailsSegue", sender: selectedDevice)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let guest = segue.destination as! DeviceDetailViewController
//        guest.selectedDevice = sender as! BluetoothDevice
//    }
    
    var destinationViewController: DeviceDetailViewController = DeviceDetailViewController()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        destinationViewController = segue.destination as! DeviceDetailViewController
        destinationViewController.selectedDevice = sender as! BluetoothDevice
    }
    
    // Bluetooth Location functions
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOn:
            print("Bluetooth ON")
        case .poweredOff:
            print("Bluetooth OFF")
        case .unauthorized:
            print("Bluetooth not authorized!")
        default:
            print("Bluetooth unknown state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        if !bluetoothDevices.contains( where: { $0.name == peripheral.name } ) {
//            bluetoothDevices.append(BluetoothDevice(name: peripheral.name!, uuid: peripheral.identifier))
//            bluetoothPeripherals.append(peripheral)
//            devicesTableView.reloadData()
//        }
        
        if !bluetoothDevices.contains( where: { $0.0.name == peripheral.name } ) {
            bluetoothDevices.append(BluetoothDevice(name: peripheral.name!, uuid: peripheral.identifier), peripheral)
            devicesTableView.reloadData()
            
            print("RSSI of \(peripheral.name!): \(RSSI)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected to \(peripheral.name)!")
        peripheral.delegate = self
        
//        peripheral.readRSSI()
        startTimerRSSI(peripheral: peripheral)
        
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("error: \(error)")
            return
        }
        if let services = peripheral.services {
            print("Found \(services.count) services! :\(services)")
            
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }

    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("error: \(error)")
            return
        }
        if let characteristics = service.characteristics {
            print("Found \(characteristics.count) characteristics @ \(service.uuid)!")
            
            for characteristic in characteristics {
                print("\(characteristic)")
//                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Failed… error: \(error)")
            return
        }
        print("characteristic uuid: \(characteristic.uuid), value: \(characteristic.value)")
    }
    
    var selectedPeripheral: CBPeripheral!
    var readRSSITimer: Timer!

    func startTimerRSSI(peripheral: CBPeripheral) {
        
        selectedPeripheral = peripheral
        
        readRSSITimer = Timer.scheduledTimer(timeInterval: 2,
                             target: self,
                             selector: #selector(readPeriphalRSSI),
                             userInfo: nil,
                             repeats: true)
    }
    
    func readPeriphalRSSI() {
        selectedPeripheral.readRSSI()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if let error = error {
            print("error: \(error)")
            return
        }
        print("RSSI read for \(peripheral.name!): \(RSSI)")
        
        // set new RSSI value
        destinationViewController.rssiStrength = Int(RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        readRSSITimer.invalidate()
    }

    
    func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral, error: Error?) {
        print("didUpdateRSSI")
    }
    
    
    
    // Properties
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

