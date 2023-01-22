import Foundation
import XCTest // для тестирования, импортируем Фреймворк XCTest
@testable import MovieQuiz // а также импортируем наше приложение MovieQuiz

class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication! // Чтобы эта переменная была проинициализирована на момент использования, присвоим ей значение в методе setUpWithError(), а в метод tearDownWithError() добавим строчку app = nil
    ///`` Класс XCUIApplication позволяет:
    /// - запускать и останавливать работу приложения,
    /// - отслеживать и менять статус приложения при прогоне тестов,
    /// - запускать другое приложение на устройстве (если вы знаете его bundleIdentifier)
    /// - управлять авторизацией в приложении для сброса установленного доступа к содержимому и функциям устройства (например, контактов или камеры).
    // Чтобы после каждого теста приложение прекращало работу, а перед каждым тестом — открывалось заново и обеспечивало чистоту теста, в методы tearDownWithError() и setUpWithError() надо добавить строчки app.terminate() (закроет приложение) и app.launch() (откроет приложение) соответственно
    
    override func setUpWithError() throws {
        // ru Поместите код установки здесь. Этот метод вызывается перед вызовом каждого тестового метода в классе.
        // en Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch() //
        
        // ru В тестах пользовательского интерфейса обычно лучше сразу останавливаться при возникновении сбоя.
        // en In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // ru В тестах пользовательского интерфейса важно установить начальное состояние — например, ориентацию интерфейса — необходимое для ваших тестов до их запуска. Метод setUp — хорошее место для этого.
        // en In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // ru Поместите сюда код демонтажа. Этот метод вызывается после вызова каждого тестового метода в классе.
        // en Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
/*
    func testExample() throws {
        // ru Тесты пользовательского интерфейса должны запускать приложение, которое они тестируют.
        // en UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // ru Используйте XCTAsert и связанные с ним функции, чтобы убедиться, что ваши тесты дают правильные результаты.
        // en Use XCTAssert and related functions to verify your tests produce the correct results.
    }*/
    
    func testScreenCast() throws { // Этот метод будет хранить код теста.
        ///В UI-тестировании на iOS есть несколько подходов. Наиболее простой — прямая запись ваших действий на экране приложения с дальнейшим их воспроизведением при повторе теста.
        ///Чтобы начать запись экрана, нужно поместить курсор в Xcode в тот метод, в который вы хотите записать действия, и ``нажать на темную красную точку "запись"`` в нижнем левом углу
    }
}




/*
final class MovieQuizUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
*/
