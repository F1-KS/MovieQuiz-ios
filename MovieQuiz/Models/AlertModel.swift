import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> Void

}

struct ErrorAlertModel {
    let errorTitle: String
    let errorMessage: String
    let errorButtonText: String
    var completion: () -> Void

}
