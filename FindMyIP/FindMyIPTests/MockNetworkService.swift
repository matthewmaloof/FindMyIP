//
//  MockNetworkService.swift
//  FindMyIPTests
//
//  Created by Matthew Maloof on 10/30/23.
//

import Foundation
@testable import FindMyIP

class MockNetworkService: NetworkServiceProtocol {
    var ipInfo: IPInfo?
    var error: Error?

    func fetchIPInfo(completion: @escaping (Result<IPInfo, Error>) -> Void) {
        if let error = self.error {
            completion(.failure(error))
        } else if let ipInfo = self.ipInfo {
            completion(.success(ipInfo))
        }
    }
}

