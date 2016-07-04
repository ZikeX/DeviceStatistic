//
//  PurchaseClass.swift
//  Device Statistic
//
//  Created by Alexsander  on 2/6/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//


import Foundation
import StoreKit

class PurchaseClass: NSObject, SKProductsRequestDelegate {
    
    // for purchases
    var purchaseIdArray = [String]()
    var productArray = [SKProduct]()
    
    //MARK: - for remove ad in app
    func purchaseLaunch() {
        purchaseIdArray.append("devicestatistic_remove_advertising")
        print(purchaseIdArray)
        let productRequest = SKProductsRequest(productIdentifiers: NSSet(array: purchaseIdArray) as! Set<String>)
        productRequest.delegate = self
        productRequest.start()
    }
    
    // MARK: - store kit delegates
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        for product in response.products {
            print(product.localizedTitle, product.localizedDescription, product.price, product.downloadable, product.downloadContentLengths, product.priceLocale.localeIdentifier)
            productArray.append(product)
        }
        print(productArray, productArray.count)
    }
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    func requestDidFinish(request: SKRequest) {
        print("did finish")
    }
}