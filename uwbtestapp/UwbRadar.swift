//
//  UwbRadar.swift
//  uwbapp
//
//

import SwiftUI

let COLOR_OFF = Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1))
let COLOR_ON = Color(uiColor: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5))

class ColorWatcher: ObservableObject {
    @Published var isOn: Bool
    init() {
        self.isOn = false
    }
    
    func toggle() {
        self.isOn = !self.isOn
    }
}

struct UwbRadarCircleView: View, Identifiable {
    var id = UUID()
    var index: Int
    var baseRadius: Int
    var limit: Int
    init(index: Int, baseRadius: Int, limit: Int) {
        self.index = index
        self.baseRadius = baseRadius
        self.limit = limit
    }
    @ObservedObject var colorWatcher = ColorWatcher()
    var body: some View {
        if index == 1 {
            Circle().fill(colorWatcher.isOn ? COLOR_ON : COLOR_OFF).frame(width: CGFloat(index * baseRadius), height: CGFloat(index * baseRadius), alignment: .center)
        } else {
            Circle().strokeBorder(colorWatcher.isOn ? COLOR_ON : COLOR_OFF, lineWidth: 2).frame(width: CGFloat(index * baseRadius), height: CGFloat(index * baseRadius), alignment: .center)
        }
    }
    
    func toggleColor() {
        self.colorWatcher.toggle()
    }
}

class UwbRadarCircleGroup: ObservableObject {
    @Published private var _numCircles: Int
    private var baseRadius: Int
    private var circleArr: [UwbRadarCircleView]
    private var indexToAlter: Int
    private var animationInterval: Float
    
    init(numCircles: Int, baseRadius: Int){
        self._numCircles = numCircles
        self.baseRadius = baseRadius
        self.circleArr = []
        self.indexToAlter = 0
        self.animationInterval = 0.0
        for index in (0..<self._numCircles){
            let circleView = UwbRadarCircleView(index: index, baseRadius: baseRadius, limit: self._numCircles - 1)
            circleArr.append(circleView)
        }
    }

    public func getCircles() -> [UwbRadarCircleView] {
        return circleArr.reversed()
    }
    
    @objc func toggleColor(){
        let prev = self.indexToAlter > 0 ? self.indexToAlter - 1 : self._numCircles - 1
        if self.circleArr[prev].colorWatcher.isOn {
            self.circleArr[prev].toggleColor()
        }
        self.circleArr[self.indexToAlter].toggleColor()
        self.indexToAlter += 1
        var interval: DispatchTimeInterval
        if self.indexToAlter == self._numCircles {
            self.indexToAlter = 0
        }
        interval = DispatchTimeInterval.milliseconds(Int(ceil(self.animationInterval)))
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.toggleColor()
        }
        
    }
    
    public func startAnimation(animationSpeed: Float) {
        if self.animationInterval == 0.0 {
            self.animationInterval = (animationSpeed * 1000.0) / Float((self._numCircles + 1))
            toggleColor()
        } else {
//            print("Already Animating!")
        }
    }
}


struct UwbRadar: View {
    @ObservedObject var circleGroup: UwbRadarCircleGroup
    let baseRadius: Int
    private let path: Path
    init(circleGroup: UwbRadarCircleGroup,  baseRadius: Int){
        self.circleGroup = circleGroup
        self.baseRadius = baseRadius
        self.path = Path { p in
            p.move(to: CGPoint(x: 0, y: 0))
        }
        self.circleGroup.startAnimation(animationSpeed: 1.5)
    }
    var body: some View {
        ZStack{
            ForEach(circleGroup.getCircles()){circle in
                circle
            }
        }
    }
}

struct UwbRadar_Previews: PreviewProvider {
    static var previews: some View {
        UwbRadar(circleGroup: UwbRadarCircleGroup(numCircles: 1, baseRadius: 15), baseRadius: 15)
    }
}
