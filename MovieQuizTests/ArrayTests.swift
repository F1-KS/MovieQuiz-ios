import Foundation
import XCTest // для тестирования, импортируем Фреймворк XCTest
@testable import MovieQuiz // а также импортируем наше приложение MovieQuiz

///``Покрываем тестами код проекта
///В первую очередь — с того, что тяжело протестировать руками. Например, со вспомогательных функций. В папке Helpers находится расширение Array+Extensions. Оно содержит всего один сабскрипт для безопасного получения элемента массива по индексу
///
class ArrayTests: XCTestCase {
    // функция тест на успешное взятие элемента по индексу
    func testGetValueInRange() throws {
        // Given/Дано
        let array = [1, 1, 2, 3, 5]
        
        // When/Когда
        let value = array[safe: 2]
        
        // Then/Тогда
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    // функция тест на взятие элемента по неправильному индексу
    func testGetValueOutOfRange() {
        // Given/Дано
        let array = [1, 1, 2, 3, 5]
        
        // When/Когда
        let value = array[safe: 20]
        
        // Then/Тогда
        XCTAssertNil(value)
    }
    
}
