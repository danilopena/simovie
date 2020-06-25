//
//  NetworkLayer.swift
// 
//
//  Created by Danilo Pena on 19/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import Foundation
import UIKit

typealias NetworkCompletionHandler = (Data?, URLResponse?, Error?) -> Void
typealias ErrorHandler = (String) -> Void

final class NetworkLayer {
    static let genericError = NetworkLayer.Localizable.genericError.localized

    init() {}

    func get<T: Decodable>(urlString: String,
                                headers: [String: String] = [:],
                                successHandler: @escaping (T) -> Void,
                                errorHandler: @escaping ErrorHandler) {
        let completionHandler: NetworkCompletionHandler = { (data, urlResponse, error) in
            guard let _ = error else {
                if self.isSuccessCode(urlResponse) {
                    guard let data = data else {
                        return errorHandler(NetworkLayer.genericError)
                    }
                    do {
                        let test = try JSONDecoder().decode(T.self, from: data)
                        successHandler(test)
                        return
                    } catch {
                        errorHandler(NetworkLayer.genericError)
                    }
                }
                return
            }
            errorHandler(NetworkLayer.genericError)
        }

        guard let url = URL(string: urlString) else {
            return errorHandler(urlProblemStr)
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    func getImage(urlString: String, successHandler: @escaping (UIImage) -> Void, errorHandler: @escaping ErrorHandler) {
        let completionHandler: NetworkCompletionHandler = { (data, urlResponse, error) in
            guard let _ = error else {
                if self.isSuccessCode(urlResponse) {
                    guard
                    let httpURLResponse = urlResponse as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = urlResponse?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                    
                    successHandler(image)
                }
                return
            }
            errorHandler(NetworkLayer.genericError)
        }

        guard let url = URL(string: urlString) else {
            return errorHandler(urlProblemStr)
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }

    func post<T: Encodable>(urlString: String,
                                 body: T,
                                 headers: [String: String] = [:],
                                 errorHandler: @escaping ErrorHandler) {

        let completionHandler: NetworkCompletionHandler = { (data, urlResponse, error) in
            guard let _ = error else {
                if !self.isSuccessCode(urlResponse) {
                    errorHandler(NetworkLayer.genericError)
                    return
                }
                return
            }
            errorHandler(NetworkLayer.genericError)
        }

        guard let url = URL(string: urlString) else {
            return errorHandler(urlProblemStr)
        }
        
        guard let data = try? JSONEncoder().encode(body) else {
            return errorHandler(encodeErrorStr)
        }
        URLSession.shared
            .uploadTask(with: mountPostRequest(url, headers, data),
                        from: data,
                        completionHandler: completionHandler)
            .resume()
    }
    
    private func mountPostRequest(_ url: URL,_  headers: [String: String],_ data: Data) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 90
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.allHTTPHeaderFields?["Content-Type"] = "application/json"
        request.httpBody = data
        
        return request
    }

    private func isSuccessCode(_ statusCode: Int) -> Bool {
        return statusCode >= 200 && statusCode < 300
    }

    private func isSuccessCode(_ response: URLResponse?) -> Bool {
        guard let urlResponse = response as? HTTPURLResponse else {
            return false
        }
        return isSuccessCode(urlResponse.statusCode)
    }
}

extension NetworkLayer {
    enum Constants {
        static let baseUrl = "https://api.themoviedb.org/3/"
        static let baseUrlImage = "http://image.tmdb.org/t/p/"
        static let language = "&language=" + (NSLocale.preferredLanguages.first ?? "pt-BR")
        static let apiKey = "2bcbd525660a5fa9b2301d133e308dda"
    }
    
    enum Localizable {
        static let genericError = "GENERIC_ERROR"
        static let urlProblem = "URL_PROBLEM"
        static let encodeError = "ENCODE_ERROR"
    }
    
    var urlProblemStr: String {
       return Localizable.urlProblem.localized
    }
    
    var encodeErrorStr: String {
       return Localizable.encodeError.localized
    }
}
