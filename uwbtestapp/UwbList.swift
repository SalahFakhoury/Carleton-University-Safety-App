//
//  UwbRadar.swift
//  uwbapp
//
//

import SwiftUI
import EstimoteUWB

struct BeaconItem: Identifiable {
    let id = UUID()
    var publicID: String = ""
    var distance: Float = 0
    var vector: EstimoteUWB.Vector?
    var name: String = ""
    var speed : Double = 0.0
    var date:String = Date().formattedString()
    var distanceOverTime : Float = 0
    
}

class BeaconList: ObservableObject {
    @Published var beacons: [BeaconItem]
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
    
    
    init(items: [BeaconItem]) {
        beacons = items
    }
    
    func addBeacon(beacon: BeaconItem) {
        self.beacons.append(beacon)
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
                let distanceTravel = self.beacons[i].distance - distance
                //debugPrint("Old Distance",self.beacons[i].distance)
               // debugPrint("Old distan,New Distance",self.beacons[i].distance,distance)
                //debugPrint("Distance over time",distanceTravel)
                
                
                self.beacons[i].distance = distance
                self.beacons[i].distanceOverTime = distanceTravel
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
                let y2 = ((Z - 2*x*(c.x-b.x)) / (2*(c.y-b.y))) + 2

                let y3 = (y + y2) / 2;

                let value = CGPointMake(x, y2)
//                print(value)
            }
            
            
            
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
                //                let CLocation  = CLLocation(latitude: Double(vector?.x ?? 0.0), longitude: Double(vector?.y ?? 0.0))
                //                self.beacons[i].speed = CLocation.speedAccuracy
                self.beacons[i].date = Date().formattedString()
                let diatance = self.beacons[i].distanceOverTime
                //                print(diatance)
                
                //print(oldTime,Date())
                let tempDate = Date()
                let elapsed = Date().timeIntervalSince(oldTime)
                oldTime = tempDate
                
                
                // print(elapsed)
                let tempElapsed = Int(elapsed * 10)
               // print(tempElapsed)
                if tempElapsed > 0{
                    
                
                
                let time = elapsed //self.beacons[i].date.timeInterval()
                //0.673 - 0.655 / 0.5
                
                let speed = diatance/Float(time)
                // debugPrint("Beacon vector \(vector?.x)" )
                //debugPrint("Beacon Speed \(speed.avoidNotation)")
                if speed != 0{
                    
                    self.beacons[i].speed = Double(speed) //Double(speed.avoidNotation) ?? 0.000
                    
                    
                   // print(elapsed, Double(speed))
                }
                
                let timeToColision = self.beacons[i].distance/speed
                let tempDistance = self.beacons[i].distance
                    
                if tempDistance < 1.0 && timeToColision < 3.0{
                    print(timeToColision,tempDistance)
                        NotificationService.shared.createNotifcation()
                }

                if speed > 0.3{
                   // print(speed,self.beacons[i].date, self.beacons[i].distance/speed)
                }
                
            }
                
                
                
                
                
                
                
                
                break
            }
        }
    }
}
import CoreLocation
struct BeaconListView: View {
    @ObservedObject var list: BeaconList
    
    var body: some View {
        ScrollView{
            VStack {
                ForEach(list.beacons) { beacon in
//                    let _ = print(beacon.speed)
                    Button {
//                        print("Clicked on  #\(beacon.publicID)")
                    } label: {
                        HStack {
                            // display string
                            
                            let value = beacon.publicID
                            let publicid = String(value.prefix(2))
                            
//                            print(publicid, beacon.speed)
                            
                            Text("Beacon id# \(publicid) -> \(String(format: "%.2f",beacon.distance))m").padding(.leading, 10.0)
                            //Text("X \(String(format: "%.2f", beacon.vector?.x ?? 0.0)) Y \(String(format: "%.2f", beacon.vector?.y ?? 0.0)) Z \(String(format: "%.2f", beacon.vector?.z ?? 0.0))")
                            
                            
                            Text("Beacon Speed \(String(format: "%.2f", beacon.speed))")
                            
                            let timeToColision = beacon.distance / Float(beacon.speed)
                            
                            Text("Time To Collision \(String(format: "%.2f", timeToColision))")
//                            Text("Beacon Speed \(beacon.speed)")
                            
//                            if beacon.speed.sign == .minus {
//                                Text("Beacon is moving away from object")
//                            }
//                            else{
//                                Text("Beacon is moving towards the object")
//                            }
                            //Text(beacon.speed < 0 ? "Beacon Speed 0" : "Beacon Speed \(beacon.speed)")
                            
                            Text("Date \(beacon.date)")
                            Spacer()
                        }.padding(.top, 7.0)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.0, brightness: 0.81)/*@END_MENU_TOKEN@*/)
                    }
                }
            }
        }
        Spacer()
    }
    
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
    let list: BeaconList = BeaconList(items: dataSource)
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
