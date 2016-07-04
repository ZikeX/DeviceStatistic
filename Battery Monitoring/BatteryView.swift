//
//  BatteryView.swift
//  Device statistic
//
//  Created by Alexsander  on 12/5/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import DrawKit

@IBDesignable
class BatteryView: UIView {
    
    // MARK: - var and let 
    let arc = Arc()
    var timer: NSTimer!
//    var boolAddLabel = false
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var openWidget = false
    
    // MARK: - IBOutlet
    var batteryLabel: UILabel!
    
    // MARK: - colors
    @IBInspectable var blackColor: UIColor = .blackColor()
    @IBInspectable var greenColor: UIColor = .greenColor()
    @IBInspectable var redColor: UIColor = .redColor()
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "drawBatteryArc", userInfo: nil, repeats: true)
        notificationCenter.addObserver(self, selector: "turnOffBatteryTimerWidget", name: "turnOffBatteryWidgetTimer", object: nil)
    }
    
    //
    
    func drawBatteryArc() {
        self.layer.sublayers?.removeAll()
        let batteryState = BatteryState().batteryState()
    
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: 50.0, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI*2 - M_PI_2), clockwise: true)
        
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: greenColor, strokeStart: 0.0, strokeEnd: CGFloat(batteryState.batteryLevelForArc), lineWidth: 8.0, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: redColor, strokeStart: CGFloat(batteryState.batteryLevelForArc), strokeEnd: 1.0, lineWidth: 8.0, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        

        batteryLabel = UILabel(frame: CGRect(x: frame.size.width/2-25, y: frame.size.height/2-10.5, width: 50, height: 21.0))
        batteryLabel.textColor = greenColor
        batteryLabel.textAlignment = .Center
        batteryLabel.font = UIFont(name: "System", size: 17.0)
        batteryLabel.text = "\(batteryState.percentForLabel) %"
        self.addSubview(batteryLabel)
    }
  
    func turnOffBatteryTimerWidget(){
        timer.invalidate()
    }
 
}
