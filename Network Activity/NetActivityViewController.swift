//
//  NetActivityViewController.swift
//  Device Statistic
//
//  Created by Alexsander  on 1/7/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import NotificationCenter
import Charts

class NetActivityViewController: UIViewController, NCWidgetProviding {

    // MARK: - var and let
    let userDefault = NSUserDefaults.standardUserDefaults()
    var boolForChangedValueNet = false
    
    var receivedValueArrayChart: [Double]!
    var receivedDescriptionArrayChart: [String]!
    var sendValueArrayChart: [Double]!
    var sendDescriptionArrayChart: [String]!
    var netActTimer: NSTimer!
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var receivedChartView: LineChartView! {
        didSet {
            receivedChartView.backgroundColor = .clearColor()
            receivedChartView.drawBordersEnabled = true
            receivedChartView.borderColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)
            
            receivedChartView.autoScaleMinMaxEnabled = true
            receivedChartView.descriptionText = "Data Received"
            receivedChartView.drawGridBackgroundEnabled = false
            receivedChartView.xAxis.drawGridLinesEnabled = false
            
            receivedChartView.leftAxis.drawLabelsEnabled = true
            receivedChartView.leftAxis.labelTextColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)

            receivedChartView.rightAxis.drawLabelsEnabled = false
            
            receivedChartView.rightAxis.drawGridLinesEnabled = false
            receivedChartView.leftAxis.drawGridLinesEnabled = false
        }
    }
    
    @IBOutlet weak var sendChartView: LineChartView! {
        didSet {
            sendChartView.backgroundColor = .clearColor()
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
        self.preferredContentSize = CGSize(width: 0, height: 300)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        receivedValueArrayChart = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        receivedDescriptionArrayChart = ["", "", "", "", "", "", "", "", "", ""]
        sendValueArrayChart = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        sendDescriptionArrayChart = ["", "", "", "", "", "", "", "", "", ""]
        boolForChangedValueNet = false
        
        netActTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showChart", userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        netActTimer.invalidate()
    }
    
    // MARK: - set charts
    func showChart() {
        let networkArray = dataNetwork()
        receivedChartView.legend.enabled = false
        sendChartView.legend.enabled = false
        
        receivedLabel.text = "Data received \(networkArray.speed.speedReceivedString)/sec"
        setReceivedChart(networkArray.received.receivedDescriptionArrayChart, value: networkArray.received.receivedValueArrayChart)
        sendLabel.text = "Data sent \(networkArray.speed.speedSendString)/sec"
        setSendChart(networkArray.send.sendDescriptionArrayChart, value: networkArray.send.sendValueArrayChart)
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
        dataSet.circleRadius = 3.0
        dataSet.drawCubicEnabled = true
        dataSet.drawFilledEnabled = true
        dataSet.drawValuesEnabled = true //
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
        dataSet.circleRadius = 3.0
        dataSet.drawCubicEnabled = true
        dataSet.drawFilledEnabled = true
        dataSet.drawValuesEnabled = true //
        dataSet.valueTextColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)
        
        dataSet.fillColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)
        
        let chartData = LineChartData(xVals: description, dataSet: dataSet)
        sendChartView.data = chartData
    }
    
    // MARK: - chart functions
    
    func dataNetwork() -> (received: (receivedValueArrayChart: [Double], receivedDescriptionArrayChart: [String]), send:(sendValueArrayChart: [Double], sendDescriptionArrayChart: [String]), speed: (speedReceivedString: String, speedSendString: String)) {
        let usageData = NetActivityUsage.getDataUsage()
        if boolForChangedValueNet == false {
            savedOriginalValue(usageData)
            boolForChangedValueNet = true
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
        
        // change!
        savedOriginalValue(usageData)
        
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
    
    func savedOriginalValue(digit: (wifi: (sent: UInt32, received: UInt32), wwan: (sent: UInt32, received: UInt32))) {
        let sendForSave = Int(digit.wifi.sent + digit.wwan.sent)
        let receivedSave = Int(digit.wifi.received + digit.wwan.received)
        userDefault.setInteger(receivedSave, forKey: "oldReceivedActNet")
        userDefault.setInteger(sendForSave, forKey: "oldSentActNet")
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: (NCUpdateResult) -> Void) {
        completionHandler(.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

}
