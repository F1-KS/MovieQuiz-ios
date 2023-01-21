import Foundation
import UIKit

protocol AlertPresenterProtocol {
    func showAlert(result: AlertModel)
}

class AlertPresenter: AlertPresenterProtocol {
    
    private weak var controller: UIViewController?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func showAlert(result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Сыграть еще раз",
            style: .default,
            handler: { _ in result.completion() }
        )
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil)
    }
}


protocol AlertNetworkErrorProtocol {
    func showErrorAlert(alertResult: ErrorAlertModel)
}

class AlertNetworkError: AlertNetworkErrorProtocol {
    private weak var controllerError: UIViewController?
    
    init(controllerError: UIViewController) {
        self.controllerError = controllerError
    }
    
    func showErrorAlert(alertResult: ErrorAlertModel) {
        let alertError = UIAlertController(
            title: alertResult.errorTitle,
            message: alertResult.errorMessage,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Попробовать ещё раз",
            style: .default,
            handler: { _ in alertResult.completion() }
        )
        alertError.addAction(action)
        controllerError?.present(alertError, animated: true, completion: nil)
    }
}
