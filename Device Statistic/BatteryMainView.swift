//
//  BatteryMainView.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/24/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation

class BatteryMainView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - var and let
    let arc = Arc()
    var boolAddLabel = false
    var notificationCenter = NSNotificationCenter.defaultCenter()
    
    var boolForBatteryTimer = false
    
    var radiusArc: CGFloat!
    var lineWidth: CGFloat!
    
    // label in the center of arc
    var widthLabel: CGFloat!
    var heightLabel: CGFloat!
    var sizeWidthLabel: CGFloat!
    var sizeHeightLabel: CGFloat!
    var fontForCenterLabel: UIFont!
    var path: UIBezierPath!
    
    // MARK: - IBOutlet
    var batteryLabel: UILabel!
    
    // MARK: - colors
    @IBInspectable var blackColor: UIColor = .blackColor()
    @IBInspectable var greenColor: UIColor = .greenColor()
    @IBInspectable var redColor: UIColor = .redColor()
    
    override func drawRect(rect: CGRect) {
        if boolForBatteryTimer == false {
            drawBatteryArc()
            turnOnBatteryInformation()
            boolForBatteryTimer = true
        }
        
        notificationCenter.addObserver(self, selector: "turnOnBatteryInformation", name: "TurnOnMainBatteryTimer", object: nil)
    
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            notificationCenter.addObserver(self, selector: "checkOrientation", name: "changeOrientationBattery", object: nil)
        }
    }
    
    func drawBatteryArc() {
        self.layer.sublayers?.removeAll()

        let batteryState = BatteryStateMain().batteryState()

        let device = CheckDevice().returnResult(self)
        radiusArc = device.radiusArc
        lineWidth = device.lineWidth
            
        let infoLabel = CheckDevice().returnInfoBatteryLabel(self)
        widthLabel = infoLabel.widthLabel
        heightLabel = infoLabel.heightLabel
        sizeWidthLabel = infoLabel.sizeWidthLabel
        sizeHeightLabel = infoLabel.sizeHeightLabel
        fontForCenterLabel = infoLabel.fontLabel
 
        batteryLabel = UILabel(frame: CGRect(x: frame.size.width/2-sizeWidthLabel, y: frame.size.height/2-sizeHeightLabel, width: widthLabel!, height: heightLabel))
        batteryLabel.textColor = greenColor
        batteryLabel.font = fontForCenterLabel
        batteryLabel.textAlignment = .Center
        batteryLabel.adjustsFontSizeToFitWidth = true
        batteryLabel.text = "\(batteryState.percentForLabel) %"
        
        path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: radiusArc, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI*2 - M_PI_2), clockwise: true)

        arc.addFigure(path.CGPath, fillColor: blackColor, strokeColor: greenColor, strokeStart: 0.0, strokeEnd: CGFloat(batteryState.batteryLevelForArc), lineWidth: lineWidth, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: redColor, strokeStart: CGFloat(batteryState.batteryLevelForArc), strokeEnd: 1.0, lineWidth: lineWidth, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        self.addSubview(batteryLabel)
    }
    
    func turnOnBatteryInformation() {
        if GlobalTimer.sharedInstance.viewTimer != nil {
            GlobalTimer.sharedInstance.viewTimer?.invalidate()
        }
        GlobalTimer.sharedInstance.viewTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "drawBatteryArc", userInfo: nil, repeats: true)
    }
    
    func checkOrientation() {
        GlobalTimer.sharedInstance.orientationTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "drawBatteryArc", userInfo: nil, repeats: false)
        GlobalTimer.sharedInstance.orientationTimer = nil
        turnOnBatteryInformation()
    }
}
