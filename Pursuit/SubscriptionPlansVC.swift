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
import SimpleAlert
import SwiftyStoreKit
import StoreKit
import SwiftDate


class SubscriptionPlansVC: UIViewController {
    
    //MARK: Enums
    
    enum TierType: Int {
        case one        = 0
        case two        = 1
        case three      = 2
        case four       = 3
        case five       = 4
        case oneD       = 5
        case twoD       = 6
        case threeD     = 7
        case fourD      = 8
        case fiveD      = 9
        
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
            case .oneD:
                return "$20/month"
            case .twoD:
                return "$35/month"
            case .threeD:
                return "$48/month"
            case .fourD:
                return "$72/month"
            case .fiveD:
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
            case .oneD:
                return "up to 5 clients"
            case .twoD:
                return "up to 10 clients"
            case .threeD:
                return "up to 15 clients"
            case .fourD:
                return "up to 25 clients"
            case .fiveD:
                return "up to 50 clients"
            }
        }
        
        var serverSub: String {
            switch self {
            case .one:
                return "pro-5"
            case .two:
                return "pro-10"
            case .three:
                return "pro-15"
            case .four:
                return "pro-25"
            case .five:
                return "pro-50"
            case .oneD:
                return "pro-5"
            case .twoD:
                return "pro-10"
            case .threeD:
                return "pro-15"
            case .fourD:
                return "pro-25"
            case .fiveD:
                return "pro-50"
            }
        }
        
        var tier: Int {
            switch self {
            case .one:
                return 1
            case .two:
                return 2
            case .three:
                return 3
            case .four:
                return 4
            case .five:
                return 5
            case .oneD:
                return 1
            case .twoD:
                return 2
            case .threeD:
                return 3
            case .fourD:
                return 4
            case .fiveD:
                return 5
            }
        }
    }
    
    //MARK: Constants
    
    struct Constants {
        static let SharedKey = "83eca0dc70e3437d8cd7d0e968594f24"
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var clientsCountLabel: UILabel!
    @IBOutlet weak var tierLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var tierSlider: PaymentsTierSlider!
    
    @IBOutlet weak var promoCodeTextField: UITextField!
    //MARK: Variables
    
    var tierType: TierType = .one {
        didSet {
            tierLabel.text         = "TIER \(tierType.tier)"
            rateLabel.text         = tierType.rate
            clientsCountLabel.text = tierType.clients
            tierSlider.value       = Float(tierType.rawValue)
        }
    }
    
    var produstIds: [String] = ["com.HealthPursuit.pro1", "com.HealthPursuit.pro2", "com.HealthPursuit.pro3", "com.HealthPursuit.pro4", "com.HealthPursuit.pro5", "com.HealthPursuit.pro1discount", "com.HealthPursuit.pro2discount", "com.HealthPursuit.pro3discount", "com.HealthPursuit.pro4discount", "com.HealthPursuit.pro5discount"]
    var productDiscountIds: [String] = ["com.HealthPursuit.pro1discount", "com.HealthPursuit.pro2discount", "com.HealthPursuit.pro3discount", "com.HealthPursuit.pro4discount", "com.HealthPursuit.pro5discount"]
    var products: Set<SKProduct> = []
    
    //MARK: IBActions
    
    @IBAction func tierSliderValueChanged(_ sender: PaymentsTierSlider) {
        let selectedIndex = Int(sender.value)
        tierType = TierType(rawValue: selectedIndex) ?? .one
        sender.value = Float(Int(selectedIndex))
    }
    
    @IBAction func subscribeButtonPressed(_ sender: Any) {
        subscribe()
    }
    
    @IBAction func expireTest(_ sender: Any) {
        let dateFormatter = DateFormatters.ianPurchaseFormat
        var date = DateInRegion(absoluteDate: Date())
        date = date + 2.minutes
        let converted = dateFormatter.string(from: date.absoluteDate)
        subscribeTo(type: tierType.serverSub, validUntil: converted)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCodeImage()
        
        enableKeyboardManager(true)
        
        requestproductInfo()
        
        tierType = .one
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
         enableKeyboardManager(false)
        navigationController?.navigationBar.isHidden = false
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
    
    private func showAlert() {
        let alert = PSAlert(title: "Ooops", message: "Something went wrong please try again later.", style: .alert).addActionHandler(action: AlertAction(title: "Ok", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func subscribeTo(type: String, validUntil: String) {
        showProgressHud()
        Trainer.subscribeTo(type: type, valid_until: validUntil) { (error) in
            self.dismissProgressHud()
            if let error = error {
                let alert = error.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }else {
                let alert = PSAlert(title: "Success", message: "Subscription successful", style: .alert).addActionHandler(action: AlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func subscribeTo(item: ReceiptItem?, expireDate: Date) {
        guard let item = item else { return }
        let dateFormatter = DateFormatters.ianPurchaseFormat
        
        let stringDate = dateFormatter.string(from: expireDate)
    
        let subscriptionPlan = tierType.serverSub
        
        subscribeTo(type: subscriptionPlan, validUntil: stringDate)
    }
}

private extension SubscriptionPlansVC {
    func setUpCodeImage() {
        if let image = UIImage(named: "gift")?.withRenderingMode(.alwaysTemplate) {
            giftImageView.image = image
            giftImageView.tintColor = UIColor.lightGray
        }
    }
    
    func setTypeWith(item: ReceiptItem) {
        let itemId = item.productId
        let index = produstIds.index(of: itemId)
        tierType = TierType(rawValue: index ?? 0) ?? .one
    }
}

private extension SubscriptionPlansVC {
    
     func requestproductInfo() {
        showProgressHud()
        let produstsIdies = Set(produstIds)
        SwiftyStoreKit.retrieveProductsInfo(produstsIdies) { result in
            self.dismissProgressHud()
            self.products = result.retrievedProducts
            self.verifySubscription()
        }
    }
    
    private func subscribe() {
        let code = (promoCodeTextField.text ?? "")
        if code.uppercased() == "Pursuit40".uppercased() {
            let idscoundProductId = productDiscountIds[Int(tierSlider.value)]
            makePaymentWith(productId: idscoundProductId)
        }else {
            let selectedProduct = produstIds[Int(tierSlider.value)]
            makePaymentWith(productId: selectedProduct)
        }
    }
    
    func makePaymentWith(productId: String) {
        showProgressHud()
        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
            self.dismissProgressHud()
            if case .success(let purchase) = result {
                self.validateReceipt(productId: productId)
            } else if case .error(let error) = result {
                
            }
        }
    }
    
    func validateReceipt(productId: String) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: Constants.SharedKey)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            
            if case .success(let receipt) = result {
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable,
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate, let receiptItems):
                    self.subscribeTo(item: receiptItems.first, expireDate: expiryDate)
                case .expired(let expiryDate, let receiptItems):
                    break
                case .notPurchased:
                    break
                }
                
            } else {
                // receipt verification error
            }
        }
    }
    
    func verifySubscription() {
        showProgressHud()
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: Constants.SharedKey)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            self.dismissProgressHud()
            switch result {
            case .success(let receipt):
                
                let productIds = Set(self.produstIds)
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: productIds, inReceipt: receipt, validUntil: Date())
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    if let item = items.first {
                        self.setTypeWith(item: item)
                    }
                case .expired(let expiryDate, let items):
                    if let item = items.first {
                        self.setTypeWith(item: item)
                    }
                    break
                case .notPurchased:
                    break
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
}
