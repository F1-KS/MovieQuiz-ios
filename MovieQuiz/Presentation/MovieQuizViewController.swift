import Foundation
import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    // MARK: - Делегейт
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
        
    }
    
    // MARK: - Жизненный цикл
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // при первом запуске приложения чтобы не было пустого экрана imageView (пока не отработает функция нажатии кнопок ДА или Нет), подключим стек и отобразим его
        presenter.viewController = self
        presenter.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        presenter.alertPresenter = AlertPresenter(controller: self)
        alertErrorNetwork = AlertNetworkError(controller: self)
        presenter.questionFactory?.loadData()
        presenter.statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
    }
    
    // MARK: - Привязка пользовательского интерфейса
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    //Обработка ответа от пользователя
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Переменные и константы
    
    private let presenter = MovieQuizPresenter()
    private var alertErrorNetwork: AlertNetworkErrorProtocol?
    
    // MARK: - Функции
    
    func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = nil //корректный сброс цвета обводки imageView - вместо функции resetAnswerResult() {imageView.layer.borderColor = UIColor.clear.cgColor}
    }
    
    func showAnswerResult(isCorrect: Bool) {
        // это код, который будет показывать красную или зелёную рамку
        // исходя из правильности ответа, то есть переменной `isCorrect`.
        
        if isCorrect {
            presenter.correctAnswers += 1
        }
        // цвета из папки Helpers файле UIColor+Extensions
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor //если True то делаем рамку зеленой иначе красной
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // запускаем задачу через 1 секунду
            // код, который вы хотите вызвать через 1 секунду,
            // в нашем случае это просто функция showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        presenter.questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
        activityIndicator.stopAnimating() // выключаем анимацию
    }
    
    // Показываем ошибку сети
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = ErrorAlertModel(errorTitle: "Ошибка",
                                    errorMessage: message,
                                    errorButtonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else {return}
            
            self.presenter.resetQuestionIndex()
            self.presenter.correctAnswers = 0
            self.presenter.questionFactory?.loadData()
            
        }
        alertErrorNetwork?.showErrorAlert(alertResult: model)
    }
    
    
} // end MovieQuizViewController
