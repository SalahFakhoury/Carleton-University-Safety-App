//
//  ContentView.swift
//  uwbtestapp
//
//

import SwiftUI
import EstimoteProximitySDK
import CoreLocation

func zoneBuilder(tag: String, range: ProximityRange, onEnterCallBack: @escaping ((ProximityZoneContext) -> Void), onExitCallBack: @escaping ((ProximityZoneContext) -> Void), onContextChangeCallBack: @escaping ((Set<ProximityZoneContext>) -> Void)) -> ProximityZone {
    let zone = ProximityZone(tag: tag, range: range)
    zone.onEnter = onEnterCallBack
    zone.onEnter = onExitCallBack
    zone.onContextChange = onContextChangeCallBack
    return zone
}

struct ContentView: View {
    let points = [(12.0, 10.0), (22.0, 20.0), (32.0, 30.0),(42.0, 40.0),(52.0, 50.0),(62.0, 60.0)].map({CGPoint(x: $0.0, y: $0.1)})

    let beaconList: BeaconList
    let uwbManger: UWBManager
    init(beaconList: BeaconList) {
        self.beaconList = beaconList
        self.uwbManger = UWBManager { arg in
            let dist = Float(round(1000 * arg.distance) / 1000)
            if (beaconList.contains(publicID: arg.publicId)) {
                beaconList.updateBeaconDistance(publicID: arg.publicId, distance: dist)
                beaconList.updateBeaconVector(publicID: arg.publicId, vector: arg.vector)
            } else {
                var newBeaconItem: BeaconItem = BeaconItem()
                newBeaconItem.publicID = arg.publicId
                newBeaconItem.distance = dist
                newBeaconItem.vector = arg.vector
                let CLocation  = CLLocation(latitude: Double(arg.vector?.x ?? 0.0), longitude: Double(arg.vector?.y ?? 0.0))
                newBeaconItem.speed = CLocation.speed.magnitude
                beaconList.addBeacon(beacon: newBeaconItem)
            }
        } beaconDisconnectCallBack: { arg in
            beaconList.removeBeacon(publicID: arg)
        }
    }
    var body: some View {
        VStack {
            HStack(){
                Spacer();
                Text("Carleton University Safety App").font(.system(size: 20)).fontWeight(.bold)
                Spacer();
            }
            .padding(.bottom, 10.0)
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.yellow/*@END_MENU_TOKEN@*/)
            Spacer();
            VStack{
                //            ZStack(){
                UwbRadar(circleGroup: UwbRadarCircleGroup(numCircles: 20, baseRadius: 15), baseRadius: 15)
                
                //                for point in points {
                //                    Color.red.frame(width: 10, height: 10).position(x:point.x, y: point.y)
                //
                //                }
                
                //            }
                
                BeaconListView(list: beaconList)
            }
            Spacer()
            HStack(){
                Button {
        
                } label: {
                    Image("road").resizable().frame(width: 25.0, height: 25.0)
                }.padding(.bottom);
                Spacer();
                Button {
                } label: {
                    Image("radar").resizable().frame(width: 25.0, height: 25.0)
                }.padding(.bottom);
                Spacer();
                Button {
                } label: {
                    Image("blueprint").resizable().frame(width: 25.0, height: 25.0)
                }.padding(.bottom);
            }.padding([.leading, .trailing], 40.0)
        }
        .background(.white)
        .onAppear {
            FirebaseManager.shared.getBeaconData(id: "1ea6a7e2141bb5de129ba4e6ad04a001")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(beaconList: BeaconList(items: [
                BeaconItem(name: ""),
                BeaconItem(name: ""),
                BeaconItem(name: ""),
                BeaconItem(name: ""),
                BeaconItem(name: ""),
                BeaconItem(name: ""),
                BeaconItem(name: ""),
                BeaconItem(name: ""),
        ], value: [
            BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
            BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
            BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
            BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
            BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
            BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
            BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
            BeaconMulti(x:0.0, y: 0.0, distance: 0.0),
        ]))
    }
}
