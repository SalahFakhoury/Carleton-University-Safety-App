//
//  uwbManager.swift
//  uwbapp
//
//

import EstimoteUWB
import CoreLocation
class UWBManager {
    private var uwbManager: EstimoteUWBManager?
    private var beaconUpdateCallback: (UWBDevice)->Void
    private var beaconDisconnectCallBack: (String) -> Void
    
    init(beaconUpdateCallback: @escaping ((UWBDevice)->Void), beaconDisconnectCallBack: @escaping (String) -> Void) {
        self.beaconUpdateCallback = beaconUpdateCallback
        self.beaconDisconnectCallBack = beaconDisconnectCallBack
        setupUWB()
        
//        DataHelper().storeDummyData()
    }

    private func setupUWB() {
        uwbManager = EstimoteUWBManager(positioningObserver: self, discoveryObserver: self, beaconRangingObserver: self)
        uwbManager?.startScanning()
    }
}

// REQUIRED PROTOCOL
extension UWBManager: UWBPositioningObserver {
    func didUpdatePosition(for device: UWBDevice) {
        self.beaconUpdateCallback(device)
        ///devi.ce
        let dataHelper = DataHelper()
        dataHelper.buildData(deviceId: device.publicId)
        
        let distancePath = dataHelper.getDistancePath()
        let beaconPath = dataHelper.getBeaconLocationPath()
        let distance = HelperUtility.getNumber(requiredDigit: 3, number: device.distance)
        
        let distanceData = DataInfo(path: distancePath, dataString: "\(distance)m")
        
        let x = HelperUtility.getNumber(requiredDigit: 3, number: device.vector?.x ?? 0.0)
        let y = HelperUtility.getNumber(requiredDigit: 3, number: device.vector?.y ?? 0.0)
        let z = HelperUtility.getNumber(requiredDigit: 3, number: device.vector?.z ?? 0.0)
        
        let locString = "(\(x), \(y), \(z))"
        let CLocation  = CLLocation(latitude: Double(x), longitude: Double(y))
    
        
        let beaconLocationData = DataInfo(path: beaconPath, dataString: locString)
        
    //    FirebaseManager.shared.storeData(data: distanceData)
//        FirebaseManager.shared.storeData(data: beaconLocationData)
    }
}

// OPTIONAL PROTOCOL FOR BEACON BLE RANGING
extension UWBManager: BeaconRangingObserver {
    func didRange(for beacon: BLEDevice) {
       // print("BLE beacon did range: \(beacon)")
    }
}

// OPTIONAL PROTOCOL FOR DISCOVERY AND CONNECTIVITY CONTROL
extension UWBManager: UWBDiscoveryObserver {
    var shouldConnectAutomatically: Bool {
        return true // set this to false if you want to manage when and what devices to connect to for positioning updates
    }

    func didDiscover(device: UWBIdentifable, with rssi: NSNumber, from manager: EstimoteUWBManager) {
//        print("Discovered Device: \(device.publicId) rssi: \(rssi)")
        
        let dataHelper = DataHelper()
        dataHelper.buildData(deviceId: device.publicId)

        let rssiPath = dataHelper.getRSSIPath()
        let beaconLocationData = DataInfo(path: rssiPath, dataString: "\(rssi)")
        
       // FirebaseManager.shared.storeData(data: beaconLocationData)

        // if shouldConnectAutomatically is set to false - then you could call manager.connect(to: device)
        // additionally you can globally call discoonect from the scope where you have inititated EstimoteUWBManager -> disconnect(from: device) or disconnect(from: publicId)
    }

    func didConnect(to device: UWBIdentifable) {
//        print("Successfully Connected to: \(device.publicId) name -> \(device.name ?? "Unknown")")
    }

    func didDisconnect(from device: UWBIdentifable, error: Error?) {
        self.beaconDisconnectCallBack(device.publicId)
        
//        print("Beacon is disconnected: ID -> \(device.publicId) Name -> \(device.name ?? "Unknown")")
    }

    func didFailToConnect(to device: UWBIdentifable, error: Error?) {
//        print("Failed to conenct to: \(device.publicId) - error: \(String(describing: error))")
    }
}
