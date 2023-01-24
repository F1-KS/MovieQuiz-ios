import Foundation
import UIKit

final class MovieQuizPresenter {
    
    //MARK: - Переменные - константы
    
    private var currentQuestionIndex: Int = 0
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    
    // MARK: -
    
    func yesButtonClicked(_ sender: UIButton) {
        viewController?.yesButton.isEnabled = false
        viewController?.noButton.isEnabled = false
        //let currentQuestion = questions[currentQuestionIndex] // -
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func noButtonClicked(_ sender: UIButton) {
        viewController?.yesButton.isEnabled = false
        viewController?.noButton.isEnabled = false
        //let currentQuestion = questions[currentQuestionIndex] // -
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    
    // MARK: - Функции - Методы
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
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
    
    
} // end MovieQuizPresenter


