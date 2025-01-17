import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    //MARK: - Переменные - константы
    
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewController?
    private var correctAnswers: Int = 0
    private let statisticService: StatisticService!
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var alertErrorNetwork: AlertNetworkErrorProtocol?
    
    init(viewController: MovieQuizViewController) {
        // при первом запуске приложения чтобы не было пустого экрана imageView (пока не отработает функция нажатии кнопок ДА или Нет), подключим стек и отобразим его
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
        alertPresenter = AlertPresenter(controller: viewController)
        alertErrorNetwork = AlertNetworkError(controller: viewController)
        
    }
    
    // MARK: -
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func yesButtonClicked() {
        offButtonClicked()
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        offButtonClicked()
        didAnswer(isYes: false)
    }
    
    func offButtonClicked() {
        viewController?.yesButton.isEnabled = false
        viewController?.noButton.isEnabled = false
    }
    
    func onButtonClicked() {
        viewController?.yesButton.isEnabled = true
        viewController?.noButton.isEnabled = true
    }
    
    // MARK: -
    
    func didLoadDataFromServer() {
        viewController?.activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    // MARK: - Делегейт
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Функции - Методы
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() { // DRY заменяем повторения в коде
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
    }
    
    func showNextQuestionOrResults() {
        // - 1 потому что индекс начинается с 0, а длинна массива — с 1
        // показать результат квиза
        if self.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            guard let gamesCount = statisticService?.gamesCount else {return}
            guard let bestGame = statisticService?.bestGame else {return}
            guard let totalAccuracy = statisticService?.totalAccuracy else {return}
            // три кавычки дают возможность переносить строки без знака \n и делать код более читаемым
            let text = """
                Ваш результат: \(correctAnswers)/\(self.questionsAmount)
                Количество сыгранных квизов: \(gamesCount)
                Рекорд: \(bestGame.correct)/\(bestGame.total) \(bestGame.date.dateTimeString)
                Средняя точность: \(String(format: "%.2f", totalAccuracy))%
                """
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                completion: {
                    self.restartGame()
                })
            alertPresenter?.showAlert(result: alertModel)
        } else {
            
            self.switchToNextQuestion() // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
            // показать следующий вопрос
            questionFactory?.requestNextQuestion()
        }
    } // end showNextQuestionOrResults
    
    // Показываем ошибку сети
    func showNetworkError(message: String) {
        viewController?.hideLoadingIndicator()
        
        let model = ErrorAlertModel(errorTitle: "Ошибка",
                                    errorMessage: message,
                                    errorButtonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else {return}
            
            self.restartGame()
            self.questionFactory?.loadData()
            
        }
        alertErrorNetwork?.showErrorAlert(alertResult: model)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        // это код, который будет показывать красную или зелёную рамку
        // исходя из правильности ответа, то есть переменной `isCorrect`.
        
        if isCorrect {
            correctAnswers += 1
        }
        // цвета из папки Helpers файле UIColor+Extensions
        viewController?.imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        viewController?.imageView.layer.borderWidth = 8 // толщина рамки
        viewController?.imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor //если True то делаем рамку зеленой иначе красной
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // запускаем задачу через 1 секунду
            // код, который вы хотите вызвать через 1 секунду,
            // в нашем случае это просто функция showNextQuestionOrResults()
            self.onButtonClicked()
            self.showNextQuestionOrResults()
        }
    }
    
} // end MovieQuizPresenter


