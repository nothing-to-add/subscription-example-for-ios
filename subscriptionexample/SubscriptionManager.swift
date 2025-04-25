import StoreKit

class SubscriptionManager: NSObject, ObservableObject {
    @Published var isSubscribed: Bool = false
    private var product: SKProduct?

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        fetchProducts()
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: ["com.yourapp.subscription"])
        request.delegate = self
        request.start()
    }

    func purchaseSubscription() {
        guard let product = product else { return }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    private func validateReceipt() {
        // Implement receipt validation logic here
        // For simplicity, we'll assume the subscription is valid
        isSubscribed = true
    }
}

extension SubscriptionManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let fetchedProduct = response.products.first {
            product = fetchedProduct
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to fetch products: \(error.localizedDescription)")
    }
}

extension SubscriptionManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                validateReceipt()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                validateReceipt()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if let error = transaction.error {
                    print("Transaction failed: \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}