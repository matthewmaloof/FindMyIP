//
//  FindMyIPViewModelTests.swift
//  FindMyIPTests
//
//  Created by Matthew Maloof on 10/30/23.
//

import XCTest
@testable import FindMyIP

class FindMyIPViewModelTests: XCTestCase {

    // MARK: - Properties

    private var viewModel: FindMyIPViewModel!
    private var mockNetworkService: MockNetworkService!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = FindMyIPViewModel(networkService: mockNetworkService)
    }

    // MARK: - Test Cases

    func testFetchIPInfoSuccess() {
        // 1. Create an expectation object.
        let expectation = self.expectation(description: "Fetch IP Info")

        let ipInfo = createMockIPInfo()
        configureMockService(ipInfo: ipInfo)
        
        // 2. Call the async method
        viewModel.fetchIPInfo()
        
        // 3. Fulfill the expectation in the async callback
        DispatchQueue.main.async {
            expectation.fulfill()
        }

        // 4. Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)
        
        // 5. Continue with your asserts
        XCTAssertEqual(viewModel.ipInfo, ipInfo, "IPInfo should match the mock data")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil")
    }

    func testErrorScenarios() {
        let errorTestCases = [
            (code: 404, message: "Network error"),
            (code: 408, message: "Network Timeout"),
            (code: 500, message: "Server error")
        ]

        for testCase in errorTestCases {
            let expectation = self.expectation(description: "Fetch IP Info with error")

            configureMockService(ipInfo: nil, errorCode: testCase.code, errorDescription: testCase.message)

            viewModel.fetchIPInfo {
                expectation.fulfill()
            }

            waitForExpectations(timeout: 5, handler: nil)
            assertErrorMessage(testCase.message)
        }
    }



    func testFetchIPInfoDeprecatedIP() {
        // Setup
        let expectation = self.expectation(description: "Fetch deprecated IP Info")
        let deprecatedIPInfo = createDeprecatedIPInfo()
        configureMockService(ipInfo: deprecatedIPInfo)

        // Exercise
        viewModel.fetchIPInfo {
            expectation.fulfill()
        }

        // Verify
        waitForExpectations(timeout: 5, handler: nil)
        assertErrorMessage("Deprecated IP version")
    }



    // MARK: - Helper Methods

    private func configureMockService(ipInfo: IPInfo?, errorCode: Int? = nil, errorDescription: String? = nil) {
        mockNetworkService.ipInfo = ipInfo
        if let code = errorCode, let description = errorDescription {
            mockNetworkService.error = makeNetworkError(code: code, description: description)
        } else {
            mockNetworkService.error = nil as Error?
        }
    }



    private func assertErrorMessage(_ expectedMessage: String) {
        XCTAssertNotNil(viewModel.errorMessage, "Error message should not be nil")
        XCTAssertEqual(viewModel.errorMessage, expectedMessage, "Error message should be \(expectedMessage)")
    }
    
    private func makeNetworkError(code: Int, description: String) -> Error {
        switch code {
        case 404: return NetworkError.networkError
        case 408: return NetworkError.networkTimeout
        case 500: return NetworkError.serverError
        default: return NSError(domain: description, code: code, userInfo: nil)
        }
    }

    
    // MARK: - Mock Data Creation

    private func createMockIPInfo() -> IPInfo {
        return IPInfo(
            ip: "1.1.1.1",
            network: "Test Network",
            version: "IPv4",
            city: "Test City",
            region: "Test Region",
            region_code: "TR",
            country: "TC",
            country_name: "Test Country",
            country_code: "TC",
            country_code_iso3: "TST",
            country_capital: "Test Capital",
            country_tld: ".test",
            continent_code: "TT",
            in_eu: false,
            postal: "12345",
            latitude: 1.2345,
            longitude: 5.6789,
            timezone: "Test/Timezone",
            utc_offset: "+0000",
            country_calling_code: "+99",
            currency: "TTD",
            currency_name: "Test Dollar",
            languages: "en,test",
            country_area: 123456.0,
            country_population: 123456789,
            asn: "AS1234",
            org: "Test Org"
        )
    }

    private func createInvalidIPInfo() -> IPInfo {
        return IPInfo(
            ip: "",
            network: "",
            version: "",
            city: "",
            region: "",
            region_code: "",
            country: "",
            country_name: "",
            country_code: "",
            country_code_iso3: "",
            country_capital: "",
            country_tld: "",
            continent_code: "",
            in_eu: false, // it's a Bool, so technically can't be empty, using default false
            postal: "",
            latitude: -9999.0, // unrealistic value
            longitude: -9999.0, // unrealistic value
            timezone: "",
            utc_offset: "",
            country_calling_code: "",
            currency: "",
            currency_name: "",
            languages: "",
            country_area: -1.0, // unrealistic value
            country_population: -1, // unrealistic value
            asn: "",
            org: ""
        )
    }

    private func createDeprecatedIPInfo() -> IPInfo {
        return IPInfo(
            ip: "1.1.1.1",
            network: "Test Network",
            version: "IPv3",  // Non-existent but for the sake of the test
            city: "Test City",
            region: "Test Region",
            region_code: "TR",
            country: "TC",
            country_name: "Test Country",
            country_code: "TC",
            country_code_iso3: "TST",
            country_capital: "Test Capital",
            country_tld: ".test",
            continent_code: "TT",
            in_eu: false,
            postal: "12345",
            latitude: 1.2345,
            longitude: 5.6789,
            timezone: "Test/Timezone",
            utc_offset: "+0000",
            country_calling_code: "+99",
            currency: "TTD",
            currency_name: "Test Dollar",
            languages: "en,test",
            country_area: 123456.0,
            country_population: 123456789,
            asn: "AS1234",
            org: "Test Org"
        )
    }

}
