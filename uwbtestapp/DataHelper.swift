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
//    private let timeFString = "yyyy-MM-dd_HH:mm:ss-SSS"
    private let timeFString = "HH:mm:ss-SSS"
    private let distanceKey = "Distance"
    private let rssiKey = "rssi"
    
    private let speedKey = "Avg Speed"
    private let prevSpeedKey = "Previous Speed"
    private let spotSpeedKey = "Spot Speed"
    private let beaconLocKey = "Coordinate"
    private let ttcKey = "Time to Collision"
    private let accKey = "Acceleration"
    private let mttcKey = "MTTC"
    private let lastDate = Date()
    
    private let coordinateX = "x"
    private let coordinateY = "y"
    
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
        
//        let diff = Calendar.current.dateComponents([.second], from: date, to: lastDate)
//        let miliseconds = (diff.second ?? 0) * 1000
//        if miliseconds > 50{
//
//        }
        
        self.dateFormatter.dateFormat = self.timeFString
        let curTimeString = self.dateFormatter.string(from: date)
        self.path = "\(deviceId)/\(currentDateString)/\(curTimeString)"
    }
    
    func buildDataForCoordinate() {
        self.dateFormatter.dateFormat = self.dateFString
        let date = Date()
        let currentDateString = self.dateFormatter.string(from: date)
        
//        let diff = Calendar.current.dateComponents([.second], from: date, to: lastDate)
//        let miliseconds = (diff.second ?? 0) * 1000
//        if miliseconds > 50{
//
//        }
        
        self.dateFormatter.dateFormat = self.timeFString
        let curTimeString = self.dateFormatter.string(from: date)
        self.path = "\("Coordinates")/\(currentDateString)/\(curTimeString)"
    }
    
    func getCurrentDateString()->String {
        self.dateFormatter.dateFormat = self.dateFString
        let date = Date()
        return self.dateFormatter.string(from: date)
        
//        self.dateFormatter.dateFormat = self.timeFString
//        let curTimeString = self.dateFormatter.string(from: date)
//
//        self.path = "\(deviceId)/\(currentDateString)/\(curTimeString)"
    }
    
    func buildDataForTTC(deviceId: String, level:String) {
        self.dateFormatter.dateFormat = self.dateFString
        let date = Date()
        let currentDateString = self.dateFormatter.string(from: date)
        
        self.dateFormatter.dateFormat = self.timeFString
        let curTimeString = self.dateFormatter.string(from: date)
        
        self.path = "\(deviceId)/\(level)/\(currentDateString)/\(curTimeString)"
    }
    
    func getDistancePath() -> String{
        return "\(path)/\(distanceKey)"
    }
    
    func getAccelarationPath() -> String{
        return "\(path)/\(accKey)"
    }
    
    func getSpeedPath() -> String{
        return "\(path)/\(speedKey)"
    }
    
    func getPrevSpeedPath() -> String{
        return "\(path)/\(prevSpeedKey)"
    }
    
    func getmTTCPath() -> String{
        return "\(path)/\(mttcKey)"
    }
    
    func getFinalTTCPath(type:String) -> String{
        return "\(path)/\(type)"
    }
    
    func getSpotSpeedPath() -> String{
        return "\(path)/\(spotSpeedKey)"
    }
    
    func getBeaconLocationPath() -> String{
        return "\(path)/\(beaconLocKey)"
    }
    
    func getCoordinateXPath() -> String{
        return "\(path)/\(coordinateX)"
    }
    
    func getCoordinateYPath() -> String{
        return "\(path)/\(coordinateY)"
    }
    
    func getTimeToCollisionPath() -> String{
        return "\(path)/\(ttcKey)"
    }
    
    func getRSSIPath() -> String{
        return "\(path)/\(rssiKey)"
    }
}
