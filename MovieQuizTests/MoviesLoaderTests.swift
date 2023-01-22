import Foundation
import XCTest // для тестирования, импортируем Фреймворк XCTest
@testable import MovieQuiz // а также импортируем наше приложение MovieQuiz
///
///``Покрываем тестами Сервисы
///Обычно самый сложный код, который очень хочется покрыть unit-тестами, находится среди сервисов (папка Services). Давайте покроем тестами один из них. Например, MoviesLoader
///
class MoviesLoaderTests: XCTestCase{
    
    // Тест успешной загрузки данных
    func testSuccessLoading() throws {
        // Given/Дано
        let stubNetworkClient = StubNetworkClient(emulateError: false) // говорим, что НЕ ХОТИМ эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When/Когда
        let expectation = expectation(description: "Loading expectation") // так как функция загрузки фильмов — асинхронная, нужно ожидание
        loader.loadMovies { result in
            
            // Then/Тогда
            switch result {
            case .success(let movies): // сравниваем данные с тем, что мы предполагали
                XCTAssertEqual(movies.items.count, 2) // давайте проверим, что пришло, например, два фильма — ведь в тестовых данных их всего два
                expectation.fulfill()
            case .failure(_): // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                XCTFail("Unexpected failure") // эта функция проваливает тест
            }
            
        }
        waitForExpectations(timeout: 1)
    }
    
    // Тест ошибки загрузки данных
    func testFailureLoading() throws {
        // Given/Дано
        let stubNetworkClient = StubNetworkClient(emulateError: true) // говорим, что ХОТИМ эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When/Когда
        let expectation = expectation(description: "Loading expectation") // так как функция загрузки фильмов — асинхронная, нужно ожидание
        loader.loadMovies { result in
            
            // Then/Тогда
            switch result {
            case .failure(let error): // сравниваем данные с тем, что мы предполагали
                XCTAssertNotNil(error) // давайте проверим, что пришло, например, два фильма — ведь в тестовых данных их всего два
                expectation.fulfill()
            case .success(_): // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                XCTFail("Unexpected failure") // эта функция проваливает тест
            }
            
        }
        waitForExpectations(timeout: 1)
    }
}

///
///Чтобы тест не использовал стандартный NetworkClient и, не делал запросы в сеть. Нам же этого совершенно не надо! Создадим тестовую версию сетевого клиента. Такие реализации протоколов для тестов обычно называют ///``стабами
///
struct StubNetworkClient: NetworkRouting {
    
    enum TestError: Error { // тестовая ошибка
    case test
    }
    
    let emulateError: Bool // этот параметр нужен, чтобы заглушка эмулировала либо ошибку сети, либо успешный ответ
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        if emulateError {
            handler(.failure(TestError.test))
        } else {
            handler(.success(expectedResponse))
        }
    }
    
    private var expectedResponse: Data { // заранее созданный тестовый ответ от сервера в формате Data
        """
        {
           "errorMessage" : "",
           "items" : [
              {
                 "crew" : "Dan Trachtenberg (dir.), Amber Midthunder, Dakota Beavers",
                 "fullTitle" : "Prey (2022)",
                 "id" : "tt11866324",
                 "imDbRating" : "7.2",
                 "imDbRatingCount" : "93332",
                 "image" : "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_Ratio0.6716_AL_.jpg",
                 "rank" : "1",
                 "rankUpDown" : "+23",
                 "title" : "Prey",
                 "year" : "2022"
              },
              {
                 "crew" : "Anthony Russo (dir.), Ryan Gosling, Chris Evans",
                 "fullTitle" : "The Gray Man (2022)",
                 "id" : "tt1649418",
                 "imDbRating" : "6.5",
                 "imDbRatingCount" : "132890",
                 "image" : "https://m.media-amazon.com/images/M/MV5BOWY4MmFiY2QtMzE1YS00NTg1LWIwOTQtYTI4ZGUzNWIxNTVmXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_Ratio0.6716_AL_.jpg",
                 "rank" : "2",
                 "rankUpDown" : "-1",
                 "title" : "The Gray Man",
                 "year" : "2022"
              }
            ]
          }
        """.data(using: .utf8) ?? Data()
    }
}
