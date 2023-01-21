import Foundation

// Отвечает за загрузку данных по URL
struct NetworkClient {

    //Сетевая ошибка
    private enum NetworkError: Error {
        case codeError
    }
   
    //Функция запроса
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) /*Эта функция, которая будет загружать что-то по заранее заданному URL. (отдаёт результат асинхронно через замыкание handler)*/{
        
        //Создаём запрос
        let request = URLRequest(url: url) // создаём запрос из url
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in // в ответе все аргументы data, response, error — опциональные: чтобы понять, какой ответ нам пришёл, надо их распаковать.
            // Проверяем, пришла ли ошибка
            if let error = error { //распаковываем ошибку с помощью оператора if.
                handler(.failure(error))
                return // дальше продолжать не имеет смысла, так что заканчиваем выполнение этого кода
            }
            
            // Проверяем, что нам пришёл успешный код ответа (Обрабатываем код ответа - Если мы дошли до этого кода, значит, сервер прислал нам ответ.)
            //Код ответа 200 (и любой код меньше 300 только с дополнительными комментариями) — это успешный ответ.
            //
            if let response = response as? HTTPURLResponse, //response имеет тип URLResponse — это базовый тип ответа на все сетевые протоколы, не только на HTTP. Для этого в Swift есть тип под названием HTTPURLResponse
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Возвращаем данные (Обрабатываем успешный ответ)
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
