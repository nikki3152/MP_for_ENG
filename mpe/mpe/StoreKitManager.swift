//
//  StoreKitManager.swift
//

import UIKit
import StoreKit

protocol StoreKitManagerDelegate {
	//プロダクトのリストアップ
	func storeKitManagerProductListUp(shopov: StoreKitManager, products: [[String:Any]])
	
	//トランザクションのキャンセル
	func storeKitManagerCancelTransaction(shopov: StoreKitManager, isRestore: Bool)
	
	//App Storeに製品の支払い処理
	func storeKitManagerPaymentRequestStart(shopov: StoreKitManager)
	
	//購入取引は完了
	func storeKitManagerFinishTransaction(shopov: StoreKitManager, info: [String:Any], isRestore: Bool)	
	
	//購入取引エラー
	func storeKitManagerErrorTransactio(shopov: StoreKitManager, message: String)
	
	//リストアするアイテムはない
	func storeKitManagerNoRestoreItem(shopov: StoreKitManager)
}

class StoreKitManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate {

	var delegate: StoreKitManagerDelegate?
	var buyProductDic: [String:Any] = [:]
	
	
	override init() {
		super.init()
		SKPaymentQueue.default().add(self)
	}
	
	
	//============================================================
	//MARK: - インスタンスメソッド
	//============================================================
	//App Storeに製品のリクエストをする
	func productRequestStart(productIDs: [String]) {
		
		self.isRestore = false
		var set: Set<String> = []
		for product_id in productIDs {
			set.insert(product_id)
		}
		let request = SKProductsRequest(productIdentifiers: set)
		request.delegate = self
		request.start()
	}
	
	//App Storeに製品の支払い処理
	func paymentRequestStart(productDic: [String:Any], quantity: Int) {
		
		if SKPaymentQueue.canMakePayments() == false {
			return
		}
		let product = productDic["product"] as! SKProduct
		let payment = SKMutablePayment(product: product)
		payment.quantity = quantity
		
		SKPaymentQueue.default().add(payment)
		
		self.delegate?.storeKitManagerPaymentRequestStart(shopov: self)
	}
	
	//リストア
	var isRestore: Bool = false
	func restore() {
		self.isRestore = true
		SKPaymentQueue.default().restoreCompletedTransactions()
	}
	
	
	
	
	//============================================================
	//MARK: - プライベートメソッド
	//============================================================
//	//購入取引は無事完了した
//	private func completeTransaction(transaction: SKPaymentTransaction) {
//		
//		let payment = transaction.payment						// キューに追加された支払いオブジェクト
//		//let data = transaction.transactionReceipt				// 支払い処理された領収書
//		let productID = payment.productIdentifier
//		
//		var dic: [String:Any] = [
//			"product_id":productID,
//		]
//		if let transactionID = transaction.transactionIdentifier {
//			dic["transaction_id"] = transactionID
//		}
//		if let date = transaction.transactionDate {
//			dic["date"] = date
//		}
//		
//		print("complete transaction: productID=\(productID)")
//		
//		self.buyProductDic[productID] = dic
//		
//		SKPaymentQueue.default().finishTransaction(transaction)
//		
//		self.delegate?.storeKitManagerFinishTransaction(shopov: self, info:dic, isRestore: self.isRestore)
//	}
//	//サーバ待ち行列に加えられる前に、トランザクションは、取り消されたか、失敗した。
//	private func failedTransaction(transaction: SKPaymentTransaction) {
//		
//		let payment = transaction.payment						// キューに追加された支払いオブジェクト
//		//let data = transaction.transactionReceipt				// 支払い処理された領収書
//		let productID = payment.productIdentifier
//		
//		var dic: [String:Any] = ["product_id":productID]
//		if let transactionID = transaction.transactionIdentifier {
//			dic["transaction_id"] = transactionID
//		}
//		if let date = transaction.transactionDate {
//			dic["date"] = date
//		}
//		
//		print("failed transaction: productID=\(productID)")
//		
//		self.buyProductDic[productID] = dic
//		
//		SKPaymentQueue.default().finishTransaction(transaction)
//		
//	}
	
	
	
	
	
	//============================================================
	//MARK: - SKProductsRequestDelegate
	//============================================================
	//App Storeが製品の要求に応えたときに呼ばれる
	func productsRequest(_ request: SKProductsRequest, didReceive didReceiveResponse: SKProductsResponse) {
		
		let myProduct = didReceiveResponse.products		//有効な製品のSKProductの配列
		var productsDicArray: [[String:Any]] = []
		
		for product in myProduct {
			let productID = product.productIdentifier
			var isBuy: Bool
			if self.buyProductDic[productID] == nil {
				isBuy = false
			} else {
				isBuy = true
			}
			//プロダクトID、製品名、価格、説明を辞書にラップし、それを配列に入れる
			var dic: [String:Any] = [
				"product_id":product.productIdentifier,
				"name":product.localizedTitle,
				"description":product.localizedDescription,
				"isBuy":isBuy,
				"product":product
			]
			//ローカライズされた製品名(プロダクトID)と製品価格
			let numberFormatter = NumberFormatter()
			numberFormatter.formatterBehavior = .behavior10_4
			numberFormatter.numberStyle = .currency
			numberFormatter.locale = product.priceLocale
			if let formattedString = numberFormatter.string(from: product.price) {
				dic["price"] = formattedString 
			}
			productsDicArray.append(dic)
		}
		
		if myProduct.count > 0 {
			self.delegate?.storeKitManagerProductListUp(shopov: self, products:productsDicArray)
		} else {
			self.delegate?.storeKitManagerCancelTransaction(shopov: self, isRestore: self.isRestore)
		}
	}
	
	
	
	//============================================================
	//MARK: - SKPaymentTransactionObserver
	//============================================================
	//キューのトランザクションがアップデートされた時に呼ばれる
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		
		for transaction in transactions {
			
			// トランザクションはサーバーのキューに追加されている
			if transaction.transactionState == .purchasing {
				print("purchasing.....")
			}
			// 取引は無事完了
			if transaction.transactionState == .purchased {
				let payment = transaction.payment						// キューに追加された支払いオブジェクト
				//let data = transaction.transactionReceipt				// 支払い処理された領収書
				let productID = payment.productIdentifier
				
				var dic: [String:Any] = ["product_id":productID]
				if let transactionID = transaction.transactionIdentifier {
					dic["transaction_id"] = transactionID
				}
				if let date = transaction.transactionDate {
					dic["date"] = date
				}
				
				print("complete transaction: productID=\(productID)")
				
				self.buyProductDic[productID] = dic
				SKPaymentQueue.default().finishTransaction(transaction)
				
				self.delegate?.storeKitManagerFinishTransaction(shopov: self, info:dic, isRestore: self.isRestore)
			}
			// トランザクションはユーザの購買歴から回復
			if transaction.transactionState == .restored {
				let payment = transaction.payment
				let productID = payment.productIdentifier
				print("restore transaction: productID=\(productID)")
				var dic: [String:Any] = ["product_id":productID]
				if let transactionID = transaction.transactionIdentifier {
					dic["transaction_id"] = transactionID
				}
				if let date = transaction.transactionDate {
					dic["date"] = date
				}
				self.delegate?.storeKitManagerFinishTransaction(shopov: self, info:dic, isRestore: self.isRestore)
			}
			// 取り消されたか、または失敗した。
			if transaction.transactionState == .failed {
				
				let payment = transaction.payment						// キューに追加された支払いオブジェクト
				//let data = transaction.transactionReceipt				// 支払い処理された領収書
				let productID = payment.productIdentifier
				
				var dic: [String:Any] = ["product_id":productID]
				if let transactionID = transaction.transactionIdentifier {
					dic["transaction_id"] = transactionID
				}
				if let date = transaction.transactionDate {
					dic["date"] = date
				}
				
				print("failed transaction: productID=\(productID)")
				
				self.buyProductDic[productID] = dic
				
				SKPaymentQueue.default().finishTransaction(transaction)
				self.delegate?.storeKitManagerCancelTransaction(shopov: self, isRestore: self.isRestore)
			}
		}
	}
	//キューからトランザクションを取り除く時に呼ばれる
	func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {

		print("removed transactions: \(transactions)")
	}
	
	// キューにユーザの購入履歴からの処理を追加する間にエラーが発生。
	func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
		
		self.delegate?.storeKitManagerErrorTransactio(shopov: self, message: error.localizedDescription)
	}
	
	// ユーザの購入履歴からの処理がすべてキューに正しく追加された。
	func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
		
		print("payment queue restore completed transactions finished: \(queue)")
		self.delegate?.storeKitManagerNoRestoreItem(shopov: self)
	}
	
	
	
	
	//============================================================
	//MARK: - SKRequestDelegate
	//============================================================
	//リクエストが完了された時に呼ばれる
	func requestDidFinish(_ request: SKRequest) {
		
		print("request did finish: \(request)")
		//self.delegate?.storeKitManagerRequestDidFinish(shopov: self)
	}
	
	//リクエストが実行されなかった時に呼ばれる
	func request(_ request: SKRequest, didFailWithError: Error) {
	
		print("did fail with error: \(didFailWithError.localizedDescription)")
	}
	
	
}
