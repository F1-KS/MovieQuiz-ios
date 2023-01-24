import Foundation
import UIKit

final class MovieQuizPresenter {
    
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
    }


} // end MovieQuizPresenter


