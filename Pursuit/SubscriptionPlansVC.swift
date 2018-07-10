//
//  SubscriptionPlansVC.swift
//  Pursuit
//
//  Created by ігор on 7/3/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MBProgressHUD
import StoreKit

class SubscriptionPlansVC: UIViewController {
    
    //MARK: Enums
    
    enum TierType: Int {
        case one        = 1
        case two        = 2
        case three      = 3
        case four       = 4
        case five       = 5
        
        var rate: String {
            switch self {
            case .one:
                return "$20/month"
            case .two:
                return "$35/month"
            case .three:
                return "$48/month"
            case .four:
                return "$72/month"
            case .five:
                return "$130/month"
            }
        }
        
        var clients: String {
            switch self {
            case .one:
                return "up to 5 clients"
            case .two:
                return "up to 10 clients"
            case .three:
                return "up to 15 clients"
            case .four:
                return "up to 25 clients"
            case .five:
                return "up to 50 clients"
            }
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var clientsCountLabel: UILabel!
    @IBOutlet weak var tierLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var tierSlider: PaymentsTierSlider!
    
    //MARK: Variables
    
    var tierType: TierType = .one {
        didSet {
            tierLabel.text         = "TIER \(tierType.rawValue)"
            rateLabel.text         = tierType.rate
            clientsCountLabel.text = tierType.clients
        }
    }
    
    var produstIds: [String] = ["com.HealthPursuit.pro1", "com.HealthPursuit.pro2", "com.HealthPursuit.pro3", "com.HealthPursuit.pro4", "com.HealthPursuit.pro5"]
    var products: [SKProduct] = []
    
    //MARK: IBActions
    
    @IBAction func tierSliderValueChanged(_ sender: PaymentsTierSlider) {
        tierType = TierType(rawValue: Int(sender.value)) ?? .one
    }
    
    @IBAction func subscribeButtonPressed(_ sender: Any) {
        subscribe()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCodeImage()
        
        setType()
        
        enableKeyboardManager(true)
        
        requestproductInfo()
        
        subscribeForPaymentObserver()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
         enableKeyboardManager(false)
    }
    
    private func enableKeyboardManager(_ enable: Bool) {
        IQKeyboardManager.sharedManager().enable = enable
    }
    
    fileprivate func showProgressHud() {
        let window :UIWindow = UIApplication.shared.keyWindow!
        MBProgressHUD.showAdded(to: window, animated: true)
    }
    
    fileprivate func dismissProgressHud() {
        let window :UIWindow = UIApplication.shared.keyWindow!
        MBProgressHUD.hide(for: window, animated: true)
    }
    

}

private extension SubscriptionPlansVC {
    func setUpCodeImage() {
        if let image = UIImage(named: "gift")?.withRenderingMode(.alwaysTemplate) {
            giftImageView.image = image
            giftImageView.tintColor = UIColor.lightGray
        }
    }
    
    func setType() {
        tierType = .one
    }
}

private extension SubscriptionPlansVC {
    
    private func subscribeForPaymentObserver() {
        SKPaymentQueue.default().add(self)
    }
    
     func requestproductInfo() {
        if SKPaymentQueue.canMakePayments() {
            
            showProgressHud()
            let productRequest = SKProductsRequest(productIdentifiers: Set(produstIds))
            productRequest.delegate = self
            productRequest.start()
        }
    }
    
    private func subscribe() {
        let selectedProduct = products[Int(tierSlider.value)]
        let payment = SKPayment(product: selectedProduct)
        makePaymentWith(payment: payment)
    }
    
    func makePaymentWith(payment: SKPayment) {
        SKPaymentQueue.default().add(payment)
    }
}

extension SubscriptionPlansVC: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in  response.products {
            product.isDownloadable
            self.products.append(product as SKProduct)
        }
        dismissProgressHud()
    }
}

extension SubscriptionPlansVC: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing:
                break
            case .restored:
                break
            case .deferred:
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
}
