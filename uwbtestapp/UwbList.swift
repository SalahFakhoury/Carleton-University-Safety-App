//
//  UwbRadar.swift
//  uwbapp
//
//

import SwiftUI
import EstimoteUWB
import AVFoundation
import Accelerate


struct BeaconItem: Identifiable {
    let id = UUID()
    var publicID: String = ""
    var distance: Float = 0
    var vector: EstimoteUWB.Vector?
    var name: String = ""
    var speed : Double = 0.0
    var date:String = Date().formattedString()
    var distanceOverTime : Float = 0
    var accelaration : Double = 0.0
    var levelColor : Color = .white
    var isLevelOn = false
    var finalTTC : Double = 0.0
    var mTTC : Double = 0.0
    var finalTTCType : String = ""
    var timeToColision : Double = 0.0
    var spotspeed : Double = 0.0
    var previousSpeed : Double = 0.0
    var PreviosSpeedwithoutupdate : Double = 0.0
}

struct BeaconMulti: Identifiable {
    let id = UUID()
    var x: Float = 0.0
    var y: Float = 0.0
    var distance: Float = 0.0
}

class BeaconList: ObservableObject {
    @Published var beacons: [BeaconItem]
    @Published var beaconsMulti : [BeaconMulti]
    var totalMinutes = 0
    var firstBeaconDistance : Float = 0
    var secondBeaconDistance : Float = 0
    var thirdBeaconDistance : Float = 0
    var fourthBeaconDistance : Float = 0
    var fifthBeaconDistance : Float = 0
    
    var firstBeaconName : String = ""
    var secondBeaconName : String = ""
    var thirdBeaconName : String = ""
    var fourthBeaconName : String = ""
    var fifthBeaconName : String = ""
    
    var oldTime = Date()
    var oldNotifiationTime = Date()
    var previousSpeed : Double = 0.0
    var prevAvgSpeed: Double = 0.0
    
    
    init(items: [BeaconItem], value:[BeaconMulti]) {
        
        beacons = items
        beaconsMulti = value
    }
    
   
    func addBeacon(beacon: BeaconItem) {
        self.beacons.append(beacon)
    }
    
    func addBeaconMulti(beaconMulti: BeaconMulti){
        self.beaconsMulti.append(beaconMulti)
    }
    
    func removeBeacon(publicID: String) {
        var index: Int = 0;
        for i in 0..<self.beacons.count {
            index = i
            if (self.beacons[index].publicID == publicID) {
                break
            }
        }
//        self.beacons.remove(at: index)
    }
    
    func contains(publicID: String) -> Bool {
        for i in 0..<self.beacons.count {
            if self.beacons[i].publicID == publicID {
                return true
            }
        }
        return false
    }
    
    func updateBeaconDistance(publicID: String, distance: Float) {
        for i in 0..<self.beacons.count {
            
            if self.beacons[i].publicID == publicID {
                if distance != self.beacons[i].distance {
                    let distanceTravel = self.beacons[i].distance - distance
                    //debugPrint("Old Distance",self.beacons[i].distance)
                   // debugPrint("Old distan,New Distance",self.beacons[i].distance,distance)
                    //debugPrint("Distance over time",distanceTravel)
    //                let _ = print("updateBeaconDistance : \(publicID) \(distance)")
                    
                    self.beacons[i].distance = distance
                    self.beacons[i].distanceOverTime = distanceTravel
                }
                
                if distance <= 1.0 && totalMinutes <= 0 {
                    self.totalMinutes += 1
//                    NotificationService.shared.createNotifcation()
                }
                break
                
                
            }
        }
    }

    func updateBeaconVector(publicID: String, vector: EstimoteUWB.Vector?) {
        for i in 0..<self.beacons.count {
            
//            let _ = print("updateBeaconVector \(publicID) \(self.beacons[i].distance)")
//            let _ = print("updateBeaconVector \(self.beacons[i].speed)")
            if i == 0{
                firstBeaconDistance = self.beacons[i].distance
                let value = self.beacons[i].publicID
                firstBeaconName = String(value.prefix(2))
               // print(firstBeaconName, self.beacons[i].speed)
            }else if i == 1{
                secondBeaconDistance = self.beacons[i].distance
                let value = self.beacons[i].publicID
                secondBeaconName = String(value.prefix(2))
               // print(secondBeaconName, self.beacons[i].speed)
            }else if i == 2{
                thirdBeaconDistance = self.beacons[i].distance
                let value = self.beacons[i].publicID
                thirdBeaconName = String(value.prefix(2))
            }else if i == 3{
                fourthBeaconDistance = self.beacons[i].distance
                let value = self.beacons[i].publicID
                fourthBeaconName = String(value.prefix(2))
            }else if i == 4{
                fifthBeaconDistance = self.beacons[i].distance
                let value = self.beacons[i].publicID
                fifthBeaconName = String(value.prefix(3))
            }
            
            
            if firstBeaconDistance > 0 && secondBeaconDistance > 0 && thirdBeaconDistance > 0 && self.beacons.count == 3{
//                var a = CGPoint()
//                var b = CGPoint()
//                var c = CGPoint()
                let dA = firstBeaconDistance
                let dB = secondBeaconDistance
                let dC = thirdBeaconDistance
                
//                if let beaconAVector = self.beacons[0].vector{
////                    a = CGPoint(x: CGFloat(beaconAVector.x), y: CGFloat(beaconAVector.y))
//                    a = CGPoint(x: 0, y: 0 )
//                }
//                if let beaconBVector = self.beacons[1].vector{
////                    b = CGPoint(x: CGFloat(beaconBVector.x), y: CGFloat(beaconBVector.y))
//                    b = CGPoint(x: CGFloat(secondBeaconDistance), y: 0)
//                }
//                if let beaconCVector = self.beacons[2].vector{
////                    c = CGPoint(x: CGFloat(beaconCVector.x), y: CGFloat(beaconCVector.y))
//                    c = CGPoint(x: 0, y: CGFloat(thirdBeaconDistance))
//                }
                
                let a = CGPoint(x: 0, y: 0)
                let b = CGPoint(x: CGFloat(secondBeaconDistance), y: 0)
                let c = CGPoint(x: 0, y: CGFloat(thirdBeaconDistance))
                
                let w1 = (dA*dA) - (dB*dB)
                let w2 = (a.x*a.x) - (a.y*a.y)
                let w3 = (b.x*b.x) + (b.y*b.y)
                
                
                let W =  CGFloat(w1) - w2 + w3//(dA*dA) - (dB*dB) - (a.x*a.x) - (a.y*a.y) + (b.x*b.x) + (b.y*b.y)
                
                let z1 =  dB*dB - dC*dC
                let z2 =  b.x*b.x - b.y*b.y
                let z3 = c.x*c.x + c.y*c.y
                
                
                
                
                let Z = CGFloat(z1) - z2 + z3 //dB*dB - dC*dC - b.x*b.x - b.y*b.y + c.x*c.x + c.y*c.y;

                let x = (W*(c.y-b.y) - Z*(b.y-a.y)) / (2 * ((b.x-a.x)*(c.y-b.y) - (c.x-b.x)*(b.y-a.y)));
                let y = (W - 2*x*(b.x-a.x)) / (2*(b.y-a.y))
                //y2 is a second measure of y to mitigate errors
                let y2 = ((Z - 2*x*(c.x-b.x)) / (2*(c.y-b.y)))

                let y3 = (y + y2) / 2;

                let value = CGPointMake(x, y2)
//                print(value)
            }
            
            if firstBeaconDistance > 0 && secondBeaconDistance > 0 && thirdBeaconDistance > 0 &&
                fourthBeaconDistance > 0 && self.beacons.count == 4{
               
                let dist1 = firstBeaconDistance
                let dist2 = secondBeaconDistance
                let dist3 = thirdBeaconDistance
                let dist4 = fourthBeaconDistance

                let arrDist = [firstBeaconDistance, secondBeaconDistance, thirdBeaconDistance, fourthBeaconDistance] // line 35
                
                let point1 = CGPoint(x: 0, y: 0)
                let point2 = CGPoint(x: CGFloat(dist2), y: 0)
                let point3 = CGPoint(x: 0, y: CGFloat(dist3))
                let point4 = CGPoint(x: CGFloat(dist4), y: CGFloat(dist4))
                
                beaconsMulti[0].distance = firstBeaconDistance
                beaconsMulti[0].x = 0
                beaconsMulti[0].y = 0
                
                beaconsMulti[1].distance = secondBeaconDistance
                beaconsMulti[1].x = dist2
                beaconsMulti[1].y = 0
                
                beaconsMulti[2].distance = thirdBeaconDistance
                beaconsMulti[2].x = 0
                beaconsMulti[2].y = dist3
                
                beaconsMulti[3].distance = fourthBeaconDistance
                beaconsMulti[3].x = dist4
                beaconsMulti[3].y = dist4
                
                let rows = beaconsMulti.count
                let columns = 2
                var A = [[Float]](repeating: [Float](repeating: 0, count: columns), count: rows)
               
                let B = beaconsMulti.map { $0.distance }
//                let Bs = [Float](repeating: 0, count: 2)//        [beaconsMulti.map { $0.distance }]
                var X = [Float](repeating: 0, count: 2)
                
                for (i, beacon) in beaconsMulti.enumerated() {
                    A[i][0] = beacon.x
                    A[i][1] = beacon.y
                  }
               // Zeroth attempt
                
                // Transpose of A
                let At = A.transposed()
                
                // Matrix multiplication of At and A
                let AtA = At.matrixProduct(matrix: A)
                
                // Inverse of AtA
                let AtAInverse = AtA.inverse()
                
                // Matrix multiplication of AtAInverse and At
                let AtAInverseAt = AtAInverse?.matrixProduct(matrix: At)
                
                //Vector multiplication of AtAInverseAt and B
                X = AtAInverseAt!.vectorProduct(vector: B)

                if X.count > 1{
                    let x = String(format:"%0.2f",X[0])
                    let y = String(format:"%0.2f",X[1])
                    print(x,y)
                }
//                if X.count > 0{
//                    print(X[0])
//                }
//                print(X.count)
              /*
                // First attempt
                
                // Transpose of A
//                let At = A.map { $0.map { $1 } }
                
                let At = A[0].enumerated().map { (column, _) in
                    A.map { $0[column] }
                }
                // A.transpose() * A
                var AtA = [[Float]](repeating: [Float](repeating: 0, count: A[0].count), count: A[0].count)
                for i in 0..<AtA.count {
                    for j in 0..<AtA[i].count {
                        for k in 0..<At.count {
                            AtA[i][j] += At[i][k] * A[k][j]
                        }
                    }
                }

                // Inverse of (A.transpose() * A)
                let AtAInverse = AtA//inverse(AtA)

                // (A.transpose() * A).inverse() * A.transpose()
                var AtAInverseAt = [[Float]](repeating: [Float](repeating: 0, count: AtAInverse.count), count: At.count)
                for i in 0..<AtAInverseAt.count {
                    for j in 0..<AtAInverseAt[i].count {
                        for k in 0..<AtAInverse.count {
                            AtAInverseAt[i][j] += AtAInverse[i][k] * At[k][j]
                        }
                    }
                }

                // (A.transpose() * A).inverse() * A.transpose() * B
                X = [Float](repeating: 0, count: B.count)
                for i in 0..<X.count {
                    for j in 0..<AtAInverseAt.count {
                        X[i] += AtAInverseAt[j][i] * B[i]
                    }
                }
                
                print(X)
                */
                
                
                /* Second attempt
                // Transpose of A
                var At = [[Float]](repeating: [Float](repeating: 0, count: A.count), count: A[0].count)
                for i in 0..<A.count {
                    for j in 0..<A[i].count {
                        At[j][i] = A[i][j]
                    }
                }

                // A transpose * A
                var AtA = [[Float]](repeating: [Float](repeating: 0, count: A[0].count), count: A[0].count)
                for i in 0..<AtA.count {
                    for j in 0..<AtA[i].count {
                        for k in 0..<A.count {
                            AtA[i][j] += At[i][k] * A[k][j]
                        }
                    }
                }

                // Inverse of A transpose * A
                var invAtA = [[Float]](repeating: [Float](repeating: 0, count: AtA.count), count: AtA[0].count)
                // You can implement the inverse of matrix by using the Gaussian-Jordan elimination method

                // A transpose * B
                var AtB = [Float](repeating: 0, count: A[0].count)
                for i in 0..<AtB.count {
                    for j in 0..<A.count {
                        AtB[i] += At[i][j] * B[j]
                    }
                }

                // X = (A transpose * A)^-1 * A transpose * B
                var asdf = [Float](repeating: 0, count: A[0].count)
                for i in 0..<X.count {
                    for j in 0..<invAtA.count {
                        X[i] += invAtA[i][j] * AtB[j]
                    }
                }*/
                
                /* third attempt
                //let X = (A.transposed() * A).inverse() * A.transposed() * B

                // A.transposed()
                let AT = A[0].enumerated().map { (column, _) in
                    A.map { $0[column] }
                }
                
                // (A.transposed() * A)
                let transposed = AT.map { row in
                    A[0].enumerated().map { (column, _) in
                        row.enumerated().reduce(0) { (result, columnIndexAndValue) in
                            result + columnIndexAndValue.element * A[columnIndexAndValue.offset][column]
                        }
                    }
                }
                
                //(A.transposed() * A).inverse()
                let inverseValue = transposed.inverse()
                
//                A.transposed() * B
                let transposedWithB = AT.map { row in
                    B[0].enumerated().map { (column, _) in
                        row.enumerated().reduce(0) { (result, columnIndexAndValue) in
                            result + columnIndexAndValue.element * B[columnIndexAndValue.offset][column]
                        }
                    }
                }
                
//                (A.transposed() * A).inverse() * A.transposed() * B
                X = inverseValue.map { row in
                    transposedWithB[0].enumerated().map { (column, _) in
                        row.enumerated().reduce(0) { (result, columnIndexAndValue) in
                            result + columnIndexAndValue.element * transposedWithB[columnIndexAndValue.offset][column]
                        }
                    }
                }!
                
                print(X[0],X[1]) */
                
                let arrPoints = [point1, point2, point3, point4] // line 34
                
                let l = arrPoints.count // line 23
                let S = arrDist.reduce(0, +) // line 24
             
                var W = [Float]()
                for w in arrDist{
                    let value = (Float(l - 1) * S) / (S - w)
                    W.append(value)
                } // line 26
                
                
                var points = [CGPoint]()
                var pointsX = [CGFloat]()
                var pointsY = [CGFloat]()
                for i in 0..<l{
                    let point = arrPoints[i]
                    
                    let valueX = point.x * CGFloat(W[i])
                    let valueY = point.y * CGFloat(W[i])
                    
                    pointsX.append(valueX)
                    pointsY.append(valueY)
                    
                    let value = CGPointMake(valueX, valueY)
                    points.append(value)
                }
                
                let pointX = pointsX.reduce(0, +)
                let pointY = pointsY.reduce(0, +)
                
                let finalPoint = CGPointMake(pointX, pointY)
//                print(finalPoint)  // line 28
                
            }
            
            // Distance and position wrt static values
            let firstDistance = 4.70
            let secondDistance = 5.57
          
            
            let value1 = (firstDistance * firstDistance)
            let value2 = (secondDistance * secondDistance)
            let thirdDistance = sqrt(value1 + value2)
            
            //print(String(format:"%.2f",thirdDistance))
            
            let beacon50 = CGPoint(x: 0, y: 0)
            let beacon11 = CGPoint(x: CGFloat(secondDistance), y: 0)
            let beacon10 = CGPoint(x: 0, y: CGFloat(thirdDistance))
            
            let dA = firstDistance
            let dB = secondDistance
            let dC = thirdDistance
            
            let w1 = (dA*dA) - (dB*dB)
            let w2 = (beacon50.x*beacon50.x) - (beacon50.y*beacon50.y)
            let w3 = (beacon11.x*beacon11.x) + (beacon11.y*beacon11.y)
            
            let W =  CGFloat(w1) - w2 + w3//(dA*dA) - (dB*dB) - (a.x*a.x) - (a.y*a.y) + (b.x*b.x) + (b.y*b.y)
            
            let z1 =  dB*dB - dC*dC
            let z2 =  beacon11.x*beacon11.x - beacon11.y*beacon11.y
            let z3 = beacon10.x*beacon10.x + beacon10.y*beacon10.y
            
            let Z = CGFloat(z1) - z2 + z3 //dB*dB - dC*dC - b.x*b.x - b.y*b.y + c.x*c.x + c.y*c.y;

            let x = (W*(beacon10.y-beacon11.y) - Z*(beacon11.y-beacon50.y)) / (2 * ((beacon11.x-beacon50.x)*(beacon10.y-beacon11.y) - (beacon10.x-beacon11.x)*(beacon11.y-beacon50.y)))
            let y = (W - 2*x*(beacon11.x-beacon50.x)) / (2*(beacon11.y-beacon50.y))
            //y2 is a second measure of y to mitigate errors
            let y2 = ((Z - 2*x*(beacon10.x-beacon11.x)) / (2*(beacon10.y-beacon11.y))) + 2
            let y3 = (y + y2) / 2

            let value = CGPointMake(x, y2)
           // print(value)
           // print(String(format:"%.2f, %.2f",value.x, value.y))
            
            if firstBeaconDistance > 0 && secondBeaconDistance > 0{
                let value1 = (firstBeaconDistance * firstBeaconDistance)
                let value2 = (secondBeaconDistance * secondBeaconDistance)
                let sqrt = sqrt(value1 + value2)
//                print("Distance between",firstBeaconName,"and",secondBeaconName,sqrt)
            }
            if secondBeaconDistance > 0 &&  thirdBeaconDistance > 0{
                let value1 = (secondBeaconDistance * secondBeaconDistance)
                let value2 = (thirdBeaconDistance * thirdBeaconDistance)
                let sqrt = sqrt(value1 + value2)
                //print("Distance between",secondBeaconName,"and",thirdBeaconName, sqrt)
            }
            if thirdBeaconDistance > 0 && fourthBeaconDistance > 0{
                let value1 = (thirdBeaconDistance * thirdBeaconDistance)
                let value2 = (fourthBeaconDistance * fourthBeaconDistance)
                let sqrt = sqrt(value1 + value2)
                //print("Distance between",thirdBeaconName,"and", fourthBeaconName, sqrt)
            }
            if fourthBeaconDistance > 0 && firstBeaconDistance > 0{
                let value1 = (fourthBeaconDistance * fourthBeaconDistance)
                let value2 = (firstBeaconDistance * firstBeaconDistance)
                let sqrt = sqrt(value1 + value2)
                //print("Distance between",fourthBeaconName,"and", firstBeaconName, sqrt)
            }
            if fifthBeaconDistance > 0 && fourthBeaconDistance > 0{
                let value1 = (fifthBeaconDistance * fifthBeaconDistance)
                let value2 = (fourthBeaconDistance * fourthBeaconDistance)
                let sqrt = sqrt(value1 + value2)
               // print("Distance between",fifthBeaconName,"and", fourthBeaconName, sqrt)
            }
            
          /*  if self.beacons.count >= 2{
                let firstbeacon = self.beacons[0].distance
                let secondbeacon = self.beacons[1].distance
                let value1 = (firstbeacon * firstbeacon)
                let value2 = (secondbeacon * secondbeacon)
                let sqrt = sqrt(value1 + value2)
                print(sqrt)
                
            } */
          

            
            if self.beacons[i].publicID == publicID {
                
                // Showing Test Notification
                self.beacons[i].vector = vector
                
                // Creating an object of User Location then get his
                // let CLocation  = CLLocation(latitude: Double(vector?.x ?? 0.0), longitude: Double(vector?.y ?? 0.0))
                // self.beacons[i].speed = CLocation.speedAccuracy
                self.beacons[i].date = Date().formattedString()
                let diatance = self.beacons[i].distanceOverTime
                //print(diatance)
                
                //print(oldTime,Date())
                let tempDate = Date()
                let elapsed = Date().timeIntervalSince(oldTime)
                oldTime = tempDate

                let dataHelper = DataHelper()
                
                // print(elapsed)
                let tempElapsed = Int(elapsed * 10) // this is just to check if the value is greater than 0
               
                if tempElapsed > 0{
                    
                    let time = elapsed //self.beacons[i].date.timeInterval()
                    //0.673 - 0.655 / 0.5
                    
                    let speed = diatance/Float(time)
                    
                    self.beacons[i].spotspeed = Double(speed)
                    // debugPrint("Beacon vector \(vector?.x)" )
                    //debugPrint("Beacon Speed \(speed.avoidNotation)")
                    
                    let avgSpeed = (previousSpeed + Double(speed)) / 2
//                    print("Avg. Speed")
                    
//                                        print("Speed",speed)
                    
                    let diffSpeed = Double(speed) - previousSpeed
                    
                    let acceleration = (avgSpeed - prevAvgSpeed) / Double(time) // arafat: diff in avg speed
                    
//                    let accelaration = diffSpeed / Double(time) // Diff in avg speed divide diff in time
                    
                    self.beacons[i].accelaration = acceleration
                    
//                   print(accelaration, speed, diffSpeed)
                    
                    // arafat: storing new avg to previous for next
                    prevAvgSpeed = avgSpeed
                    self.beacons[i].PreviosSpeedwithoutupdate = previousSpeed
                    previousSpeed = Double(speed)
                    
                    self.beacons[i].previousSpeed = Double(previousSpeed)
                    self.beacons[i].speed = Double(avgSpeed)
                    
//                    if speed != 0{
                        //                    print(elapsed,diatance)
                        //                    self.beacons[i].speed = Double(speed)
                        //Double(speed.avoidNotation) ?? 0.000
                        //print(elapsed, Double(speed))
//                    }
                    
                    //              let timeToColision = self.beacons[i].distance/speed
                    let timeToColision = self.beacons[i].distance/Float(self.beacons[i].speed)
                    let tempDistance = self.beacons[i].distance
                    self.beacons[i].timeToColision = Double(timeToColision)
                    
                    
                    let innerValues = pow(self.beacons[i].speed, 2) + 2 * self.beacons[i].accelaration * Double(self.beacons[i].distance)
                    
                    if innerValues < 0 || avgSpeed < 0 {
                        let finalTTC = Double(timeToColision)
                        self.beacons[i].finalTTC = finalTTC
                        self.beacons[i].finalTTCType = "FinalTTC - Avgspeed or innerValues < 0, mTTC=can not be solved"
                        self.beacons[i].mTTC = Double(timeToColision)
//                        let strAcc = String(format:"%.2f", finalTTC)
//                        let info = DataInfo(path: "MixTTC", dataString: strAcc)
//                         FirebaseManager.shared.storeData(data: info)
                    }else{
                        
                        let sqrtValues = sqrt(innerValues)
                        
                        
                        let t1 = -self.beacons[i].speed + sqrtValues
                        let t2 = -self.beacons[i].speed - sqrtValues
                        
                        let frontValuet1 = t1 / self.beacons[i].accelaration
                        let frontValuet2 = t2 / self.beacons[i].accelaration
                        
                        let TTC_acc = frontValuet1
                        
                        
//                        let finalTTC = sqrtValues.isNaN ? Double(timeToColision) : (Double(timeToColision) + TTC_acc)/2
//
//                        if sqrtValues.isNaN {
//                            let finalTTC = Double(timeToColision)
//                            self.beacons[i].finalTTC = finalTTC
//                            self.beacons[i].finalTTCType = "TTC"
//                            self.beacons[i].mTTC = Double(timeToColision)
////                            let strAcc = String(format:"%.2f", finalTTC)
////                            let info = DataInfo(path: "MixTTC", dataString: strAcc)
////                             FirebaseManager.shared.storeData(data: info)
//                        }
//                        else
                        if (frontValuet1 > 0.0) && (frontValuet2 > 0.0){
                            if frontValuet1 >= frontValuet2 {
                                
                                let finalTTC = (Double(timeToColision) + frontValuet2)/2
                                self.beacons[i].finalTTC = finalTTC
                                self.beacons[i].finalTTCType = "MixTTC - (t1>t2)"
                                self.beacons[i].mTTC = frontValuet2
//                                let strAcc = String(format:"%.2f", finalTTC)
//                                let info = DataInfo(path: "MixTTC-(t1>0,t2>0)", dataString: strAcc)
//                                 FirebaseManager.shared.storeData(data: info)
                            }else {
                                let finalTTC = (Double(timeToColision) + frontValuet1)/2
                                self.beacons[i].finalTTC = finalTTC
                                self.beacons[i].finalTTCType = "MixTTC - (t2>t1)"
                                self.beacons[i].mTTC = frontValuet1
                            }
                        }else if (frontValuet1 > 0.0) && (frontValuet2 <= 0.0) {
                            let finalTTC = (Double(timeToColision) + frontValuet1)/2
                            self.beacons[i].finalTTC = finalTTC
                            self.beacons[i].finalTTCType = "MixTTC - (t1>0,t2<=0)"
                            self.beacons[i].mTTC = frontValuet1
//                            let strAcc = String(format:"%.2f", finalTTC)
//                            let info = DataInfo(path: "MixTTC-(t1>0,t2<=0)", dataString: strAcc)
//                             FirebaseManager.shared.storeData(data: info)
                        }
                        else if (frontValuet1 <= 0.0) && (frontValuet2 > 0.0) {
                            let finalTTC = (Double(timeToColision) + frontValuet2)/2
                            self.beacons[i].finalTTC = finalTTC
                            self.beacons[i].finalTTCType = "MixTTC - (t1<=0,t2>0)"
                            self.beacons[i].mTTC = frontValuet2
//                            let strAcc = String(format:"%.2f", finalTTC)
//                            let info = DataInfo(path: "MixTTC-(t1<=0,t2>0)", dataString: strAcc)
//                             FirebaseManager.shared.storeData(data: info)
                        }else{
                            let finalTTC = Double(timeToColision)
                            self.beacons[i].finalTTC = finalTTC
                            self.beacons[i].finalTTCType = "TTC - (t1&t2<0) "
                            self.beacons[i].mTTC = Double(timeToColision)
                        }
//                        print(timeToColision, frontValuet1, frontValuet2, self.beacons[i].finalTTC)
                        
                    }
                    
                    if tempDistance <= 1.0 || (self.beacons[i].finalTTC <= 3.0 && self.beacons[i].finalTTC >= 0){
                    //print("Notfication", timeToColision, mTTC, finalTTC)
//                   print(tempDistance, timeToColision)
                    
                    //print("Notfication",timeToColision,tempDistance)

                    let tempDate = Date()
                    let elapsed = Date().timeIntervalSince(oldNotifiationTime)
                    //print(tempDate, oldNotifiationTime)
                    
                    let tempElapsed = Int(elapsed * 10)
                    oldNotifiationTime = tempDate
                    
                    if tempElapsed >= 10 {
//                        print(tempElapsed, tempDistance, self.beacons[i].finalTTC)
                        NotificationService.shared.createNotifcation()
                        
                        toggleTorch(on: true)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            toggleTorch(on: false)
                        }
                    }
    
                    if self.beacons[i].finalTTC >= 0 && self.beacons[i].finalTTC <= 1{
                        self.beacons[i].levelColor = .red
                        self.beacons[i].isLevelOn = true
                        dataHelper.buildDataForTTC(deviceId: "TimeToCollision Notification", level: "High Risk")
                                                
                        let ttcPath = dataHelper.getTimeToCollisionPath()
                        let distancePath = dataHelper.getDistancePath()
                        let speedPath = dataHelper.getSpeedPath()
                        let spotSpeedPath = dataHelper.getSpotSpeedPath()
                        let prevSpeedPath = dataHelper.getPrevSpeedPath()
                        let accPath = dataHelper.getAccelarationPath()
                        let finalTTCPath = dataHelper.getFinalTTCPath(type: self.beacons[i].finalTTCType)
                        let mttcPath = dataHelper.getmTTCPath()

                        let strDistance = String(format:"%.2f", tempDistance)
                        let strTimeToColision = String(format: "%.2f",self.beacons[i].finalTTC)
                        let beaconSpeed = String(format: "%.2f", self.beacons[i].speed)
                        let strAcc = String(format:"%.2f", self.beacons[i].accelaration)
                        let strFinalTTC = String(format:"%.2f", self.beacons[i].finalTTC)
                        let strmTTC = String(format:"%.2f", self.beacons[i].mTTC)
                        let strSpotSpeed = String(format: "%.2f", self.beacons[i].spotspeed)
                        let strPrevSpeed = String(format: "%.2f", self.beacons[i].PreviosSpeedwithoutupdate)
                        
                        let ttcData = DataInfo(path: ttcPath, dataString: "\(strTimeToColision)")
                        let distanceData = DataInfo(path: distancePath, dataString: "\(strDistance)")
                        let speedData = DataInfo(path: speedPath, dataString: "\(beaconSpeed)")
                        let accData = DataInfo(path: accPath, dataString: "\(strAcc)")
                        let finalTTCData = DataInfo(path: finalTTCPath, dataString: "\(strFinalTTC)")
                        let spotSpeedData = DataInfo(path: spotSpeedPath, dataString: "\(strSpotSpeed)")
                        let prevSpeedData = DataInfo(path: prevSpeedPath, dataString: "\(strPrevSpeed)")
                        let mTTCData = DataInfo(path: mttcPath, dataString: "\(strmTTC)")

                        
                        FirebaseManager.shared.storeData(data: ttcData)
                        FirebaseManager.shared.storeData(data: distanceData)
                        FirebaseManager.shared.storeData(data: speedData)
                        FirebaseManager.shared.storeData(data: accData)
                        FirebaseManager.shared.storeData(data: finalTTCData)
                        FirebaseManager.shared.storeData(data: mTTCData)
                        FirebaseManager.shared.storeData(data: spotSpeedData)
                        FirebaseManager.shared.storeData(data: prevSpeedData)
                        
                        
                    }else if self.beacons[i].finalTTC >= 1.1 && self.beacons[i].finalTTC <= 2{
                        self.beacons[i].levelColor = .yellow
                        self.beacons[i].isLevelOn = true
                        dataHelper.buildDataForTTC(deviceId: "TimeToCollision Notification", level: "Moderate Risk")
                        
                        let ttcPath = dataHelper.getTimeToCollisionPath()
                        let distancePath = dataHelper.getDistancePath()
                        let speedPath = dataHelper.getSpeedPath()
                        let spotSpeedPath = dataHelper.getSpotSpeedPath()
                        let prevSpeedPath = dataHelper.getPrevSpeedPath()
                        let accPath = dataHelper.getAccelarationPath()
                        let finalTTCPath = dataHelper.getFinalTTCPath(type: self.beacons[i].finalTTCType)
                        let mttcPath = dataHelper.getmTTCPath()

                        let strDistance = String(format:"%.2f", tempDistance)
                        let strTimeToColision = String(format: "%.2f",self.beacons[i].finalTTC)
                        let beaconSpeed = String(format: "%.2f", self.beacons[i].speed)
                        let strAcc = String(format:"%.2f", self.beacons[i].accelaration)
                        let strFinalTTC = String(format:"%.2f", self.beacons[i].finalTTC)
                        let strmTTC = String(format:"%.2f", self.beacons[i].mTTC)
                        let strSpotSpeed = String(format: "%.2f", self.beacons[i].spotspeed)
                        let strPrevSpeed = String(format: "%.2f", self.beacons[i].PreviosSpeedwithoutupdate)
                        
                        let ttcData = DataInfo(path: ttcPath, dataString: "\(strTimeToColision)")
                        let distanceData = DataInfo(path: distancePath, dataString: "\(strDistance)")
                        let speedData = DataInfo(path: speedPath, dataString: "\(beaconSpeed)")
                        let accData = DataInfo(path: accPath, dataString: "\(strAcc)")
                        let finalTTCData = DataInfo(path: finalTTCPath, dataString: "\(strFinalTTC)")
                        let spotSpeedData = DataInfo(path: spotSpeedPath, dataString: "\(strSpotSpeed)")
                        let prevSpeedData = DataInfo(path: prevSpeedPath, dataString: "\(strPrevSpeed)")
                        let mTTCData = DataInfo(path: mttcPath, dataString: "\(strmTTC)")

                        
                        FirebaseManager.shared.storeData(data: ttcData)
                        FirebaseManager.shared.storeData(data: distanceData)
                        FirebaseManager.shared.storeData(data: speedData)
                        FirebaseManager.shared.storeData(data: accData)
                        FirebaseManager.shared.storeData(data: finalTTCData)
                        FirebaseManager.shared.storeData(data: mTTCData)
                        FirebaseManager.shared.storeData(data: spotSpeedData)
                        FirebaseManager.shared.storeData(data: prevSpeedData)
                        
                        
                    }else if self.beacons[i].finalTTC >= 2.1 && self.beacons[i].finalTTC <= 3{
                        self.beacons[i].levelColor = .green
                        self.beacons[i].isLevelOn = true
                        dataHelper.buildDataForTTC(deviceId: "TimeToCollision Notification", level: "Low Risk")
                        
                        let ttcPath = dataHelper.getTimeToCollisionPath()
                        let distancePath = dataHelper.getDistancePath()
                        let speedPath = dataHelper.getSpeedPath()
                        let spotSpeedPath = dataHelper.getSpotSpeedPath()
                        let prevSpeedPath = dataHelper.getPrevSpeedPath()
                        let accPath = dataHelper.getAccelarationPath()
                        let finalTTCPath = dataHelper.getFinalTTCPath(type: self.beacons[i].finalTTCType)
                        let mttcPath = dataHelper.getmTTCPath()

                        let strDistance = String(format:"%.2f", tempDistance)
                        let strTimeToColision = String(format: "%.2f",self.beacons[i].finalTTC)
                        let beaconSpeed = String(format: "%.2f", self.beacons[i].speed)
                        let strAcc = String(format:"%.2f", self.beacons[i].accelaration)
                        let strFinalTTC = String(format:"%.2f", self.beacons[i].finalTTC)
                        let strmTTC = String(format:"%.2f", self.beacons[i].mTTC)
                        let strSpotSpeed = String(format: "%.2f", self.beacons[i].spotspeed)
                        let strPrevSpeed = String(format: "%.2f", self.beacons[i].PreviosSpeedwithoutupdate)
                        
                        let ttcData = DataInfo(path: ttcPath, dataString: "\(strTimeToColision)")
                        let distanceData = DataInfo(path: distancePath, dataString: "\(strDistance)")
                        let speedData = DataInfo(path: speedPath, dataString: "\(beaconSpeed)")
                        let accData = DataInfo(path: accPath, dataString: "\(strAcc)")
                        let finalTTCData = DataInfo(path: finalTTCPath, dataString: "\(strFinalTTC)")
                        let spotSpeedData = DataInfo(path: spotSpeedPath, dataString: "\(strSpotSpeed)")
                        let prevSpeedData = DataInfo(path: prevSpeedPath, dataString: "\(strPrevSpeed)")
                        let mTTCData = DataInfo(path: mttcPath, dataString: "\(strmTTC)")

                        
                        FirebaseManager.shared.storeData(data: ttcData)
                        FirebaseManager.shared.storeData(data: distanceData)
                        FirebaseManager.shared.storeData(data: speedData)
                        FirebaseManager.shared.storeData(data: accData)
                        FirebaseManager.shared.storeData(data: finalTTCData)
                        FirebaseManager.shared.storeData(data: mTTCData)
                        FirebaseManager.shared.storeData(data: spotSpeedData)
                        FirebaseManager.shared.storeData(data: prevSpeedData)
                    }
                  
                    DispatchQueue.main.asyncAfter(deadline: .now() +  1.0) {
                        self.beacons[i].isLevelOn = false
                    }
                    

                }

                if speed > 0.3{
                   // print(speed,self.beacons[i].date, self.beacons[i].distance/speed)
                }
                
            }
                dataHelper.buildData(deviceId: self.beacons[i].publicID)
                
                let ttcPath = dataHelper.getTimeToCollisionPath()
                let distancePath = dataHelper.getDistancePath()
                let speedPath = dataHelper.getSpeedPath()
                let spotSpeedPath = dataHelper.getSpotSpeedPath()
                let prevSpeedPath = dataHelper.getPrevSpeedPath()
                let coordinatePath = dataHelper.getBeaconLocationPath()
                let accPath = dataHelper.getAccelarationPath()
                let finalTTCPath = dataHelper.getFinalTTCPath(type: self.beacons[i].finalTTCType)
                let mttcPath = dataHelper.getmTTCPath()
                
                
                let x = HelperUtility.getNumber(requiredDigit: 3, number: Float(value.x ))
                let y = HelperUtility.getNumber(requiredDigit: 3, number: Float(value.y ))
                //let z = HelperUtility.getNumber(requiredDigit: 3, number: self.beacons[i].vector?.z ?? 0.0)
//                let locString = "(\(x), \(y))"
                let locX = String(format:"%.2f",x)
                let locY = String(format:"%.2f",y)
                let locString = "(\(locX), \(locY))"
                
                let timeToColision = self.beacons[i].distance / Float(self.beacons[i].speed)
                let strTimeToColision = String(format: "%.2f", timeToColision)
                let strDistance = String(format:"%.2f", self.beacons[i].distance)
                let beaconSpeed = String(format: "%.2f", self.beacons[i].speed)
                let strAcc = String(format:"%.2f", self.beacons[i].accelaration)
                let strFinalTTC = String(format:"%.2f", self.beacons[i].finalTTC)
                let strmTTC = String(format:"%.2f", self.beacons[i].mTTC)
                let strSpotSpeed = String(format: "%.2f", self.beacons[i].spotspeed)
                let strPrevSpeed = String(format: "%.2f", self.beacons[i].PreviosSpeedwithoutupdate)
                
                let speedData = DataInfo(path: speedPath, dataString: "\(beaconSpeed)")
                let beaconLocationData = DataInfo(path: coordinatePath, dataString: locString)
                let ttcData = DataInfo(path: ttcPath, dataString: "\(strTimeToColision)")
                let distanceData = DataInfo(path: distancePath, dataString: "\(strDistance)")
                let accData = DataInfo(path: accPath, dataString: "\(strAcc)")
                let finalTTCData = DataInfo(path: finalTTCPath, dataString: "\(strFinalTTC)")
                let spotSpeedData = DataInfo(path: spotSpeedPath, dataString: "\(strSpotSpeed)")
                let prevSpeedData = DataInfo(path: prevSpeedPath, dataString: "\(strPrevSpeed)")
                let mTTCData = DataInfo(path: mttcPath, dataString: "\(strmTTC)")
                
                FirebaseManager.shared.storeData(data: speedData)
                //FirebaseManager.shared.storeData(data: beaconLocationData)
                FirebaseManager.shared.storeData(data: ttcData)
                FirebaseManager.shared.storeData(data: distanceData)
                FirebaseManager.shared.storeData(data: accData)
                FirebaseManager.shared.storeData(data: finalTTCData)
                FirebaseManager.shared.storeData(data: mTTCData)
                FirebaseManager.shared.storeData(data: spotSpeedData)
                FirebaseManager.shared.storeData(data: prevSpeedData)

                break
            }
        }
    }
}

import CoreLocation

struct MovingView: View{
    @State var poinwd = [(12.0, 10.0), (22.0, 20.0), (32.0, 30.0),(42.0, 40.0),(52.0, 50.0),(62.0, 60.0)].map({CGPoint(x: $0.0, y: $0.1)})

    var body: some View{
        VStack {
            ForEach(0..<poinwd.count, id: \.self) { item in
                Color.red.frame(width: 10, height: 10).position(x:poinwd[item].x, y: poinwd[item].y)
            }
            
        }
    }
}

func toggleTorch(on: Bool) {
    guard let device = AVCaptureDevice.default(for: .video) else { return }
    if device.hasTorch {
        do {
            try device.lockForConfiguration()

            device.torchMode = on ? .on : .off

            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    } else {
        print("Torch is not available")
    }
}

struct BeaconListView: View {
    @ObservedObject var list: BeaconList
    @State var torch = false

    var body: some View {
        
        VStack{
            
            VStack{
//                let _ = print("List updated")
                
                let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none))
                Text("Date: \(date)")
                HStack{
                    
                    Text("Beacon Id#")
                        .frame(width: UIScreen.main.bounds.size.width/6)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.leading)
                    Text("Distance (m)")
                        .frame(width: UIScreen.main.bounds.size.width/6)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    Text("Speed (m/s) Acc (m/s^2)")
                        .frame(width: UIScreen.main.bounds.size.width/6)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    Text("Mixed Time To Collision (S)")
                        .frame(width: UIScreen.main.bounds.size.width/6)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    Text("Time")
                        .frame(width: UIScreen.main.bounds.size.width/6)
                        .foregroundColor(.black)
                        .padding(.trailing)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
              
            }
            
            List(list.beacons){beacon in
                HStack{
                    let value = beacon.publicID
                    let publicid = String(value.prefix(2))
                    
                    Text(publicid)
                        .frame(width: UIScreen.main.bounds.size.width/6)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.leading)
                    
                    Text("\(String(format: "%.2f",beacon.distance))m")
                        .frame(width: UIScreen.main.bounds.size.width/6)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                    let beaconSpeed = String(format: "%.2f / %.2f", beacon.speed, beacon.accelaration)
                    Text(beaconSpeed)
                        .frame(width: UIScreen.main.bounds.size.width/6)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
//                    let timeToColision = beacon.distance / Float(beacon.speed)
//                    let tempFinalTTC = timeToColision + beacon.mTTC
                    
                    let strTimeToColision = String(format: "%.2f", beacon.finalTTC)
                    Text(strTimeToColision)
                        .frame(width: UIScreen.main.bounds.size.width/6)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                   // let time = String(DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short))
                   
                    let time = Date().formattedStringMiliSec()
                    Text(time)
                        .lineLimit(2)
                        .frame(width: UIScreen.main.bounds.size.width/6)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.trailing)
                }
                .background(beacon.isLevelOn ? beacon.levelColor : .white)
                
            }
            .background(.white)
            .foregroundColor(.white)
            .listRowSeparator(.hidden)
            .listStyle(PlainListStyle())
            
            .id(UUID())
            
        }
       
        //                        print("Avg. Speed", String(format: "%.2f", self.beacons[i].speed),
        //                              "Spot speed", String(format: "%.2f", self.beacons[i].spotspeed),
        //                              "Previous speed", String(format: "%.2f", self.beacons[i].PreviosSpeedwithoutupdate),
        //                              "distance", String(format: "%.2f", self.beacons[i].distance),
        //                              "acceleration", String(format: "%.2f", self.beacons[i].accelaration),
        //                              "finalTTC", String(format: "%.2f", self.beacons[i].finalTTC),
        //                              "timeToColision", String(format: "%.2f", self.beacons[i].timeToColision),
        //                              "MTTC", String(format: "%.2f", self.beacons[i].mTTC))
                                
                                
        //                        "%.2f", String(format: "%.2f", "%.2f", "%.2f", "%.2f", "%.2f", "%.2f", "%.2f", "%.2f",
        
//        ScrollView{
//            VStack {
//                ForEach(list.beacons) { beacon in
////                    let _ = print(beacon.speed)
//                    Button {
////                        print("Clicked on  #\(beacon.publicID)")
//                    } label: {
//                        HStack {
//                            // display string
//
//                            let value = beacon.publicID
//                            let publicid = String(value.prefix(2))
//
////                            print(publicid, beacon.speed)
//
//                            Text("Beacon id# \(publicid) -> \(String(format: "%.2f",beacon.distance))m").padding(.leading, 10.0)
//                            //Text("X \(String(format: "%.2f", beacon.vector?.x ?? 0.0)) Y \(String(format: "%.2f", beacon.vector?.y ?? 0.0)) Z \(String(format: "%.2f", beacon.vector?.z ?? 0.0))")
//
//                            let beaconSpeed = String(format: "%.2f", beacon.speed)
//                            Text("Beacon Speed \(beaconSpeed)")
//
//                            let timeToColision = beacon.distance / Float(beacon.speed)
//                            let strTimeToColision = String(format: "%.2f", timeToColision)
//                            Text("Time To Collision \(strTimeToColision)")
//
//                            Text("Date \(beacon.date)")
//
////                            Text("Beacon Speed \(beacon.speed)")
//
////                            if beacon.speed.sign == .minus {
////                                Text("Beacon is moving away from object")
////                            }
////                            else{
////                                Text("Beacon is moving towards the object")
////                            }
//                            //Text(beacon.speed < 0 ? "Beacon Speed 0" : "Beacon Speed \(beacon.speed)")
//
//
//                            Spacer()
//                        }.padding(.top, 7.0)
//                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.0, brightness: 0.81)/*@END_MENU_TOKEN@*/)
//                    }
//                }
//            }
//        }
        Spacer()
    }
    
//    private func changeBackgroundColor(beacon:BeaconItem) async{
//        try? await Task.sleep(nanoseconds: 1_000_000_000)
//        beacon.isLevelOn = false
//
//    }
    func locationSpeed(x:Float,y:Float){
        let CLocation  = CLLocation(latitude: Double(x), longitude: Double(y))
    }
}

func getview() -> BeaconListView {
    let dataSource: [BeaconItem] = [
        BeaconItem(name: ""),
        BeaconItem(name: ""),
        BeaconItem(name: ""),
        BeaconItem(name: ""),
        BeaconItem(name: ""),
        BeaconItem(name: ""),
        BeaconItem(name: ""),
        BeaconItem(name: ""),
    ]
    
    let dataSourceMulti: [BeaconMulti] = [
        BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
        BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
        BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
        BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
        BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
        BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
        BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
        BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
    ]
    
    let list: BeaconList = BeaconList(items: dataSource, value: dataSourceMulti)
    let TestView: BeaconListView = BeaconListView(list: list)
    return TestView
}



struct UwbList_Previews: PreviewProvider {
    static var previews: some View {
        getview().frame(width: .infinity, height: .infinity, alignment: .top)
    }
}
extension Date{
    func formattedString()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateFormatter.string(from: self)
    }
    
    func formattedStringMiliSec()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss.SSS"
        return dateFormatter.string(from: self)
    }
}
extension String{
    func timeInterval()->TimeInterval{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        
        
        guard let date = dateFormatter.date(from: self)
        else{
            fatalError()
        }
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let st  = dateFormatter1.string(from: date)
        guard let dae = dateFormatter1.date(from: st)
        else{
            fatalError()
        }
        return dae.timeIntervalSince1970
        
    }
}
extension Float {
    var avoidNotation: String {
//        let numberFormatter = NumberFormatter()
//        //numberFormatter.max
//        numberFormatter.numberStyle = .decimal
//        return numberFormatter.string(for: self) ?? ""
        let number = NSNumber(value: self)
        return "\(number.decimalValue)"
    }
}
extension Array where Element == Array<Float> {
    func transposed() -> [[Float]] {
        if self.isEmpty { return [] }
        let count = self[0].count
        var transposed = [[Float]](repeating: [Float](repeating: 0, count: self.count), count: count)
        for (i, row) in self.enumerated() {
            for (j, item) in row.enumerated() {
                transposed[j][i] = Float(item)
            }
        }
        return transposed
    }
}
//extension Array where Element == Array<Float> {
//    func matrixProduct(matrix: [[Float]]) -> [[Float]] {
//        let rowCount = self.count
//        let colCount = matrix[0].count
//        var result = [[Float]](repeating: [Float](repeating: 0, count: colCount), count: rowCount)
//        for i in 0..<rowCount {
//            for j in 0..<colCount {
//                for k in 0..<self[0].count {
//                    result[i][j] += self[i][k] * matrix[k][j]
//                }
//            }
//        }
//        return result
//    }
//}
extension Array where Element == Array<Float> {
    func inverse() -> [[Float]]? {
        guard self.count == self[0].count else { return nil }
        let n = self.count
        var result = self
        var inverse = [[Float]](repeating: [Float](repeating: 0, count: n), count: n)
        for i in 0..<n {
            inverse[i][i] = 1
        }

        for i in 0..<n {
            let pivot = result[i][i]
            if pivot == 0 {
                return nil
            }
            for j in 0..<n {
                result[i][j] /= pivot
                inverse[i][j] /= pivot
            }

            for k in 0..<n {
                if k != i {
                    let temp = result[k][i]
                    for j in 0..<n {
                        result[k][j] -= result[i][j] * temp
                        inverse[k][j] -= inverse[i][j] * temp
                    }
                }
            }
        }
        return inverse
    }
}
extension Array where Element == Array<Float> {
    func matrixProduct(matrix: [[Float]]) -> [[Float]] {
        guard self.count > 0 && self[0].count > 0 && matrix.count > 0 && matrix[0].count > 0 && self[0].count == matrix.count else {
            return [[Float]]()
        }
        let rows = self.count
        let commonDimension = self[0].count
        let columns = matrix[0].count
        var result = [[Float]](repeating: [Float](repeating: 0, count: columns), count: rows)
        for i in 0..<rows {
            for j in 0..<columns {
                for k in 0..<commonDimension {
                    result[i][j] += self[i][k] * matrix[k][j]
                }
            }
        }
        return result
    }
}

extension Array where Element == Array<Float> {
    func vectorProduct(vector: [Float]) -> [Float] {
        //            guard self.count > 0 && self[0].count > 0 && vector.count > 0 && self[0].count == vector.count else {
        //                return [Float]()
        //            }
        let rows = self.count
        let columns = vector.count
        var result = [Float](repeating: 0, count: rows)
        for i in 0..<rows {
            for j in 0..<columns {
                result[i] += self[i][j] * vector[i]
            }
        }
      
//        for i in 0..<rows {
//            for j in 0..<columns {
//                result[j] += self[j][i] * vector[j][i]
//            }
//        }
        
//                for i in 0..<columns {
//                    for j in 0..<rows {
//                        result[i] += self[i][j] * vector[i][j]
//                    }
//                }
        return result
    }
}
