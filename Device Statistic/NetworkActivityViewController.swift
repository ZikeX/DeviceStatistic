//
//  NetworkActivityViewController.swift
//  Device Statistic
//
//  Created by Alexsander  on 1/5/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import Charts

class NetworkActivityViewController: UIViewController, ChartViewDelegate {
    
    // MARK: - var and let
    private let userDefault = NSUserDefaults.standardUserDefaults()
    
    var receivedValueArrayChart: [Double]!
    var receivedDescriptionArrayChart: [String]!
    var sendValueArrayChart: [Double]!
    var sendDescriptionArrayChart: [String]!

    // MARK: - IBOutlet
    
    @IBOutlet weak var receivedChartView: LineChartView! {
        didSet {
            receivedChartView.delegate = self
            receivedChartView.backgroundColor = .whiteColor()
            //
            receivedChartView.drawBordersEnabled = true
            receivedChartView.borderColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)
            
            receivedChartView.autoScaleMinMaxEnabled = true
            receivedChartView.descriptionText = "Data Received"
            receivedChartView.drawGridBackgroundEnabled = false
            receivedChartView.xAxis.drawGridLinesEnabled = false
            
            // labels
            receivedChartView.leftAxis.drawLabelsEnabled = true
            receivedChartView.leftAxis.labelTextColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)
            receivedChartView.rightAxis.drawLabelsEnabled = false
            //
            receivedChartView.rightAxis.drawGridLinesEnabled = false
            receivedChartView.leftAxis.drawGridLinesEnabled = false //  false
          
            receivedChartView.legend.enabled = false
        }
    }
    
    @IBOutlet weak var sendChartView: LineChartView! {
        didSet {
            sendChartView.delegate = self
            sendChartView.backgroundColor = .whiteColor()
            sendChartView.drawBordersEnabled = true
            sendChartView.borderColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)
                        
            sendChartView.autoScaleMinMaxEnabled = true
            sendChartView.descriptionText = "Data Sent"            
            sendChartView.drawGridBackgroundEnabled = false
            sendChartView.xAxis.drawGridLinesEnabled = false
            
            sendChartView.leftAxis.drawLabelsEnabled = true
            sendChartView.leftAxis.labelTextColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)
            sendChartView.rightAxis.drawLabelsEnabled = false
            sendChartView.leftAxis.drawGridLinesEnabled = false
            sendChartView.rightAxis.drawGridLinesEnabled = false
            sendChartView.legend.enabled = false
        }
    }
    
    @IBOutlet weak var receivedLabel: UILabel! {
        didSet {
            receivedLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var sendLabel: UILabel! {
        didSet {
            sendLabel.adjustsFontSizeToFitWidth = true
        }
    }

    // MARK: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        receivedValueArrayChart = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        receivedDescriptionArrayChart = ["", "", "", "", "", "", "", "", "", ""]
        sendValueArrayChart = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        sendDescriptionArrayChart = ["", "", "", "", "", "", "", "", "", ""]
        GlobalTimer.sharedInstance.boolForChangedValue = false
        if GlobalTimer.sharedInstance.controllerTimer != nil {
            GlobalTimer.sharedInstance.controllerTimer?.invalidate()
            GlobalTimer.sharedInstance.orientationTimer?.invalidate()
            GlobalTimer.sharedInstance.viewTimer?.invalidate()
        }
        GlobalTimer.sharedInstance.controllerTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showChart", userInfo: nil, repeats: true)
        setDescriptionSetting()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setDescriptionSetting", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        userDefault.setInteger(0, forKey: "oldReceivedActNet")
        userDefault.setInteger(0, forKey: "oldSentActNet")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - set charts
    func showChart() {
        let networkArray = dataSpeedNetwork()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.receivedLabel.text = "Data Received \(networkArray.speed.speedReceivedString)/sec"
            self.setReceivedChart(networkArray.received.receivedDescriptionArrayChart, value: networkArray.received.receivedValueArrayChart)
            self.sendLabel.text = "Data Sent \(networkArray.speed.speedSendString)/sec"
            self.setSendChart(networkArray.send.sendDescriptionArrayChart, value: networkArray.send.sendValueArrayChart)
        }
    }
    
    func setReceivedChart(description: [String], value: [Double]) {
        var chartDataEntryArray = [ChartDataEntry]()
        for item in 0..<description.count {
            let chartEntry = ChartDataEntry(value: value[item], xIndex: item)
            chartDataEntryArray.append(chartEntry)
        }
        
        let dataSet = LineChartDataSet(yVals: chartDataEntryArray, label: "")
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawCirclesEnabled = true
        dataSet.drawCubicEnabled = true
        dataSet.drawFilledEnabled = true
        dataSet.circleRadius = currentRadiusCircle()
        dataSet.drawValuesEnabled = true
        dataSet.valueTextColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)
        // set color 47 206 255
        dataSet.fillColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)
        let chartData = LineChartData(xVals: description, dataSet: dataSet)
        receivedChartView.data = chartData
    }
    
    func setSendChart(description: [String], value: [Double]) {
        var chartDataEntryArray = [ChartDataEntry]()
        
        for item in 0..<description.count {
            let chartEntry = ChartDataEntry(value: value[item], xIndex: item)
            chartDataEntryArray.append(chartEntry)
        }
        
        let dataSet = LineChartDataSet(yVals: chartDataEntryArray, label: "")
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawCirclesEnabled = true
        dataSet.drawCubicEnabled = true
        dataSet.drawFilledEnabled = true
        dataSet.drawValuesEnabled = true
        dataSet.circleRadius = currentRadiusCircle()
        dataSet.valueTextColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)

        dataSet.fillColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)
 
        let chartData = LineChartData(xVals: description, dataSet: dataSet)
        sendChartView.data = chartData
    }
    
    // MARK: - chart functions
    
    func dataSpeedNetwork() -> (received: (receivedValueArrayChart: [Double], receivedDescriptionArrayChart: [String]), send:(sendValueArrayChart: [Double], sendDescriptionArrayChart: [String]), speed: (speedReceivedString: String, speedSendString: String)) {
        let usageData = WiFiMainClass.getDataUsage()
        if GlobalTimer.sharedInstance.boolForChangedValue == false {
            NetworkActivityViewController.savedOriginalValue(usageData)
            GlobalTimer.sharedInstance.boolForChangedValue = true
        }
        
        let byteFormatter = NSByteCountFormatter()
        byteFormatter.countStyle = .Binary
        byteFormatter.allowedUnits = .UseAll

        let oldReceived = userDefault.integerForKey("oldReceivedActNet")
        let oldSend = userDefault.integerForKey("oldSentActNet")
        let nowReceived = Int(usageData.wifi.received + usageData.wwan.received)
        let nowSend = Int(usageData.wifi.sent + usageData.wwan.sent)
        
        let received = nowReceived - oldReceived
        let send = nowSend - oldSend
   
        NetworkActivityViewController.savedOriginalValue(usageData)
    
        let receivedString = byteFormatter.stringFromByteCount(Int64(received))
        let sendString = byteFormatter.stringFromByteCount(Int64(send))
        
        let receivedArray = receivedString.componentsSeparatedByString(" ")
        let sendArray = sendString.componentsSeparatedByString(" ")

        if receivedValueArrayChart.count == 10 {
            receivedValueArrayChart.removeFirst()
            receivedDescriptionArrayChart.removeFirst()
            receivedDescriptionArrayChart.append(receivedArray.last!)
            receivedValueArrayChart.append(Double(received))
            //
            sendValueArrayChart.removeFirst()
            sendDescriptionArrayChart.removeFirst()
            sendDescriptionArrayChart.append(sendArray.last!)
            sendValueArrayChart.append(Double(send))
        }
        
        return (received: (receivedValueArrayChart: receivedValueArrayChart, receivedDescriptionArrayChart: receivedDescriptionArrayChart), send:(sendValueArrayChart: sendValueArrayChart, sendDescriptionArrayChart: sendDescriptionArrayChart), speed: (speedReceivedString: receivedString, speedSendString: sendString))
    }
    
    static private func savedOriginalValue(digit: (wifi: (sent: UInt32, received: UInt32), wwan: (sent: UInt32, received: UInt32))) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let sendForSave = Int(digit.wifi.sent + digit.wwan.sent)
        let receivedSave = Int(digit.wifi.received + digit.wwan.received)
        userDefault.setInteger(receivedSave, forKey: "oldReceivedActNet")
        userDefault.setInteger(sendForSave, forKey: "oldSentActNet")
        userDefault.synchronize()
    }
    
    private func currentRadiusCircle() -> CGFloat {
        let currentDevice = UIDevice.currentDevice().userInterfaceIdiom
        switch currentDevice {
        case .Phone:
            return 4.0
        case .Pad:
            return 8.0
        default: return 8.0
        }
    }
    
    func setDescriptionSetting() {
        var font: UIFont!
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            font = UIFont(name: "HelveticaNeue", size: 12)
            receivedChartView.descriptionFont = font
            sendChartView.descriptionFont = font
            receivedChartView.descriptionTextPosition = CGPoint(x: receivedChartView._viewPortHandler.chartWidth - 20.0, y: receivedChartView._viewPortHandler.chartHeight - 30.0 - (font?.lineHeight ?? 0))
            sendChartView.descriptionTextPosition = CGPoint(x: sendChartView._viewPortHandler.chartWidth - 20.0, y: sendChartView._viewPortHandler.chartHeight - 30.0 - (font?.lineHeight ?? 0))
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            font = UIFont(name: "HelveticaNeue", size: 20)
            receivedChartView.descriptionFont = font
            sendChartView.descriptionFont = font
            receivedChartView.descriptionTextPosition = CGPoint(x: receivedChartView._viewPortHandler.chartWidth - 20.0, y: receivedChartView._viewPortHandler.chartHeight - 30.0 - (font?.lineHeight ?? 0))
            sendChartView.descriptionTextPosition = CGPoint(x: sendChartView._viewPortHandler.chartWidth - 20.0, y: sendChartView._viewPortHandler.chartHeight - 30.0 - (font?.lineHeight ?? 0))
        }
    }
    
    class func updateTraffic() {
        let usageData = WiFiMainClass.getDataUsage()
        NetworkActivityViewController.savedOriginalValue(usageData)
    }
}
