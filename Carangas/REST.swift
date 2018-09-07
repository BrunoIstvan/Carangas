//
//  REST.swift
//  Carangas
//
//  Created by Usuário Convidado on 18/08/2018.
//  Copyright © 2018 Eric Brito. All rights reserved.
//

import Foundation

enum RESTOperation: String {
    
    case save = "POST"
    case delete = "DELETE"
    case update = "PUT"
    
}

class REST {
    
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    // classe usada para criar a configuração de uma sessão de requisições do App para esse Serviço Rest
    private static let configuration: URLSessionConfiguration = {
        
        let config = URLSessionConfiguration.default
    
        // confifgurar se o serviço será acessado via rede móvel ou apenas via WI-FI
        // config.allowsCellularAccess = true // false
        
        // configurar timeout para fazer a requisião
        config.timeoutIntervalForRequest = 15.0
        
        // configurar timeout para receber a resposta
        // config.timeoutIntervalForResource = ??
        
        // máximo de conexões
        config.httpMaximumConnectionsPerHost = 5
        
        // incluir um header para a requisição
        config.httpAdditionalHeaders = [ "Content-Type" : "application/json" ]
        
        return config
        
    }()
    
    
    // classe usada criar a sessão
    private static let session = URLSession(configuration: configuration)
    // singleton com uma sessão criada já toda configurada ...
    // private static let session = URLSession.shared
    
    
    /*
    // Método que pode ser usado para fazer requisições enviando e recebendo objetos genericos
    class func request<T: Codable>(element: T, operation: RESTOperation, onComplete: @escaping([T]) -> Void) {
        
        let urlString = basePath
        guard let url = URL(string: urlString) else {
            print("Não foi possível construir uma URL")
            onComplete([])
            return
        }
        
        session.dataTask(with: url) { (data, _, _) in
            let elements = try! JSONDecoder().decode([T].self, from: data!)
            
        }
        
    }
    */
    
    
    class func request(car: Car, operation: RESTOperation, onComplete: @escaping (Bool) -> Void ) {
        
        let urlString = basePath + "/" + (car._id ?? "")
        guard let url = URL(string: urlString) else {
            print("Não foi possível construir uma URL")
            onComplete(false)
            return
        }
        
        // cria uma URL de requisição montada acima
        var urlRequest = URLRequest(url: url)
        
        // prepara o metodo da requisição
        urlRequest.httpMethod = operation.rawValue
        
        // caso precise incluir um token
        // urlRequest.allHTTPHeaderFields = ["AppToken": "dfssdfsdfsf" ]
        do {
            urlRequest.httpBody = try JSONEncoder().encode(car)
        } catch {
            print("Erro ao preencher o body da requisição")
            onComplete(false)
            return
        }
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                onComplete(false)
                print("Erro na conexão: ", error!.localizedDescription)
                return
            }
            
            // tentar recuperar uma resposta e converter para uma HTTPURLResponse
            guard let response = response as? HTTPURLResponse else {
                onComplete(false)
                print("Erro na resposta")
                return
            }
            
            // se a resposta não for httpCode 200 ... exibir mensagem e sair
            if response.statusCode != 200 {
                onComplete(false)
                print("Status Code Inválido: ", response.statusCode)
                return
            }
            
            guard let _ = data else {
                onComplete(false)
                print("Sem dados")
                return
            }
            
            onComplete(true)
            
        }
        
        dataTask.resume()
        
    }
    
    
    
    // class tem a mesma função de um class static, mas permissão sobreescrever o método...
    class func loadCars( onComplete: @escaping ([Car]) -> Void ) {
        
        guard let url = URL(string: basePath) else {
            print("Erro de URL")
            return
        }
        
        // criar um objeto que vai fazer uma requisição
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Erro na conexão: ", error!.localizedDescription)
                return
            }
            
            // tentar recuperar uma resposta e converter para uma HTTPURLResponse
            guard let response = response as? HTTPURLResponse else {
                print("Erro na resposta")
                return
            }
            
            // se a resposta não for httpCode 200 ... exibir mensagem e sair
            if response.statusCode != 200 {
                print("Status Code Inválido: ", response.statusCode)
                return
            }
 
            guard let data = data else {
                print("Sem dados")
                return
            }
            
            do {
                // converte o retorno em JSON para uma lista de carros
                let cars = try JSONDecoder().decode([Car].self, from: data)
                
                // imprimindo o nome dos carros
                cars.forEach({ print($0.name) })
                
                // executa função passada por parâmetro
                onComplete(cars)
                
            } catch {
                print("Erro ao converter JSON: ", error.localizedDescription)
            }
            
        }
        
        dataTask.resume()
        
    }
    
    
}
