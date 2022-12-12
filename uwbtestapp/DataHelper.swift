//
//  DataHelper.swift
//  uwbtestapp
//
//  Created by Arafat Hossain on 27/10/22.
//

import Foundation

class DataHelper {
    private let dateFormatter = DateFormatter()
    private let dateFString = "yyyy-MM-dd"
    private let timeFString = "yyyy-MM-dd_HH:mm:ss-SSS"
    private let distanceKey = "Distance"
    private let beaconLocKey = "Coordinate"
    private let rssiKey = "rssi"
    
    private var path: String = "Salah/Path"
    
    func storeDummyData() {
        buildData(deviceId: "Arafat")
        
        let distance:Float = 2.30356878967
        
        let dist = HelperUtility.getNumber(requiredDigit: 3, number: distance)
        
//        print("Arafat distance: \(dist)")

        let distanceData = DataInfo(path: getDistancePath(), dataString: "\(dist)m")
        FirebaseManager.shared.storeData(data: distanceData)

        let beaconLocData = DataInfo(path: getBeaconLocationPath(), dataString: "(12, 123, 111)")
        FirebaseManager.shared.storeData(data: beaconLocData)
    }
    
    func buildData(deviceId: String) {
        self.dateFormatter.dateFormat = self.dateFString
        let date = Date()
        let currentDateString = self.dateFormatter.string(from: date)
        
        self.dateFormatter.dateFormat = self.timeFString
        let curTimeString = self.dateFormatter.string(from: date)
        
        self.path = "\(deviceId)/\(currentDateString)/\(curTimeString)"
    }
    
    func getDistancePath() -> String {
        return "\(path)/\(distanceKey)"
    }
    
    func getBeaconLocationPath() -> String {
        return "\(path)/\(beaconLocKey)"
    }
    
    func getRSSIPath() -> String {
        return "\(path)/\(rssiKey)"
    }
}
