import XCTest

struct ArithmeticOperationsSync {
    func addition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
    
    func subtraction(num1: Int, num2: Int) -> Int {
        return num1 - num2
    }
    
    func multiplication(num1: Int, num2: Int) -> Int {
        return num1 * num2
    }
}

struct ArithmeticOperationsAsync {
    func addition(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 + num2)
        }
    }
    
    func subtraction(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 - num2)
        }
    }
    
    func multiplication(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 * num2)
        }
    }
    
    
}


class MovieQuizTests: XCTestCase {
    
    ///``Синхронные тесты`` (функции наших арифметических операций — синхронные, то есть результат их выполнения известен сразу. При работе с синхронными функциями принято использовать методологию Given — When — Then)
    func testAdditionSync() throws {
        // Given/Дано — это состояние, когда мы получаем начальные данные, с которыми будем работать. (Дана структура для совершения арифметических операций и два числа, 1 и 2;)
        let arithmeticOperationsSync = ArithmeticOperationsSync()
        let num1 = 7
        let num2 = 2
        
        // When/Когда — действие, которое мы собираемся тестировать, когда оно уже произошло. (Когда мы получили результат сложения этих двух чисел,)
        let result = arithmeticOperationsSync.addition(num1: num1, num2: num2)
        
        // Then/Тогда — проверка действия, которое произошло.
        XCTAssertEqual(result, 9) // сравниваем результат выполнения функции и наши ожидания (функцию XCTAssertEqual, которая сравнивает два значения и маркирует тест как пройденный или как не пройденный) (Тогда сравниваем их с нашим ожиданием — числом 3.)
    }
    
    ///``Асинхронные тесты`` (Но что делать, если функция возвращает результат не сразу — то есть асинхронно? Наверняка при работе с асинхронными функциями есть какие-то тонкости. Давайте немного перепишем структуру для арифметических операций)
    func testAdditionAsync() throws {
        // Given/Дано
        let arithmeticOperationsAsync = ArithmeticOperationsAsync()
        let num1 = 1
        let num2 = 2
        
        // When/Когда
        let expectation = expectation(description: "Addition function expectation") // Чтобы тест подождал, пока функция вернёт результат, надо воспользоваться инструментом под названием expectation
        arithmeticOperationsAsync.addition(num1: num1, num2: num2) { result in
            
            // Then/Тогда
            XCTAssertEqual(result, 3) // сравниваем результат выполнения функции и наши ожидания
            expectation.fulfill() // Когда же результат функции будет получен, мы скажем, что ожидание было выполнено
        }
        //
        waitForExpectations(timeout: 2) // просим тест подождать 2 секунды, пока функция вернёт результат
    }
    
}



/*
 final class MovieQuizTests: XCTestCase {
 
 override func setUpWithError() throws {
 // Put setup code here. This method is called before the invocation of each test method in the class.
 }
 
 override func tearDownWithError() throws {
 // Put teardown code here. This method is called after the invocation of each test method in the class.
 }
 
 func testExample() throws {
 // This is an example of a functional test case.
 // Use XCTAssert and related functions to verify your tests produce the correct results.
 // Any test you write for XCTest can be annotated as throws and async.
 // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
 // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
 }
 
 func testPerformanceExample() throws {
 // This is an example of a performance test case.
 measure {
 // Put the code you want to measure the time of here.
 }
 }
 
 }
 */
