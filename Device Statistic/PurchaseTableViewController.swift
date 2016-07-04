//
//  PurchaseTableViewController.swift
//  Device Statistic
//
//  Created by Alexsander  on 2/6/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseTableViewController: UITableViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    //MARK: - var and let
    var activityView: UIActivityIndicatorView!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    // for purchases
    var purchaseIdArray = [String]()
    var productArray = [SKProduct]()
    var refreshController: UIRefreshControl!
    var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - IBOutlet
    
    //MARK: - life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.tableView.delegate = self
        refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshController)
        refreshController.beginRefreshing()

        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
        
        // setting table view
//        self.tableView.userInteractionEnabled = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        purchaseLaunch()
//        refreshController = UIRefreshControl()
//        refreshController.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//        self.tableView.addSubview(refreshController)
//        refreshController.beginRefreshing()
    }
    
    deinit {
        refreshController.endRefreshing()
        self.tableView.endUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> PurchaseTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("purchaseCell", forIndexPath: indexPath) as! PurchaseTableViewCell
//        cell.selectionStyle = .None
//        cell.selected = false
        let product = productArray[indexPath.row]

        let numberFormatter = NSNumberFormatter()
        numberFormatter.locale = product.priceLocale
        numberFormatter.numberStyle = .CurrencyStyle
        
        let price = numberFormatter.stringFromNumber(product.price)
        print(price)
        
        cell.titleLabel.text = product.localizedTitle
        cell.descriptionLabel.text = product.localizedDescription
        if price != nil {
            cell.priceLabel.text = price!
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = tableView.indexPathForSelectedRow!
        switch index {
        case NSIndexPath(forRow: 0, inSection: 0):
            buy(index)
        default: break
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    //MARK: - table fucntions
    
    func refresh() {
        print("refreshTableView")
        purchaseLaunch()
    }
    
    // MARK: - IBAction

    
    // MARK: - SK setting
    func purchaseLaunch() {
        purchaseIdArray.removeAll()
        productArray.removeAll()
        purchaseIdArray.append("devicestatistic_remove_advertising")
        let productRequest = SKProductsRequest(productIdentifiers: NSSet(array: purchaseIdArray) as! Set<String>)
        productRequest.delegate = self
        productRequest.start()
    }
    
    // MARK: - store kit delegates
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        for product in response.products {
            productArray.append(product)
        }
    }
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    func requestDidFinish(request: SKRequest) {
        refreshController.endRefreshing()
        self.tableView.userInteractionEnabled = true
        self.tableView.reloadData()
    }
    
    // MARK: - buy functions
//    func callBuyAlert() {
//        let alertController = UIAlertController(title: nil, message: "Do you want to make a purchase?", preferredStyle: .Alert)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
//        alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
//            self.buy()
//        }))
//        self.presentViewController(alertController, animated: true, completion: nil)
//    }
    
    func buy(index: NSIndexPath) {
        if SKPaymentQueue.canMakePayments() {
            print("canMakePayments")
//            let index = self.tableView.indexPathForSelectedRow!.row
            let product = productArray[index.row]
            print(product.localizedTitle)
            let payment = SKPayment(product: product)
            SKPaymentQueue.defaultQueue().addPayment(payment)
            userDefaults.setBool(true, forKey: "removePurchaseCompleted")
        } else {
            print("cannnot MakePayments")
            let alertController = UIAlertController(title: "Error", message: "This device is not able or allowed to make payments", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            }))
            self.presentViewController(alertController, animated: true, completion: { () -> Void in
                let digit = 10 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(digit))
                dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
            })
        }
    }
    
    // MARK: - payment
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction, transaction.payment.applicationUsername, transaction.transactionState, transaction.transactionDate)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
