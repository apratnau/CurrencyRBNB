//
//  Error+Currency.swift
//  CurrencyNBRB
//
//  Created by Dimon on 2/24/20.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation
import Moya

enum CurrencyErrorDetails: Int {
    case connectedFailed = -1009
    case connectedTimeOut = -1001
    
    func errorString() -> String? {
        switch self {
        case .connectedFailed:
            return "Please check your internet connection or try again later"
        case .connectedTimeOut:
            return "Превышен лимит времени на запрос"
        }
    }
    
    func returnedScreen() -> ErrorScreenType? {
        switch self {
        case .connectedFailed:
            return .internetConnectionError
        case .connectedTimeOut:
            return .connectiontTimedOutError
        }
    }
}

enum ErrorType: String {
    case repeatFaliedNoStrinpeCard = "REPEAT_FAILED_NO_STRIPE_CARD"
    case topUpAccountForRepeat = "TOP_UP_ACCOUNT_FOR_REPEAT"
    case balanceBellowZero = "BALANCE_BELOW_ZERO"
    
    func returnedScreen() -> ErrorScreenType? {
        switch self {
        case .balanceBellowZero:
            return .insufficientBalanceError
        default:
            return nil
        }
    }
}

public enum CurrencyError: Error {
    case custom(error: MoyaError)
    case onfido(error: MoyaError)
}

public extension Error {
    var errorType: String? {
        return "ERROR"
    }
}

public extension MoyaError {
    /// Depending on error type, returns a `Response` object.
    var errorDetails: NSError? {
        switch self {
        case .imageMapping: return nil
        case .jsonMapping(_): return nil
        case .stringMapping(_): return nil
        case .objectMapping(let error, _): return error as NSError
        case .statusCode(_): return nil
        case .underlying(let error, _): return error as NSError
        case .encodableMapping: return nil
        case .requestMapping: return nil
        case .parameterEncoding: return nil
        }
    }
}

extension CurrencyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .custom(let error):
            if let code = error.errorDetails?.code, let starError = CurrencyErrorDetails(rawValue: code) {
                return starError.errorString()
            }
            do {
                if let body = try error.response?.mapNSDictionary(), let errorString = body["message"] as? String {
                    return errorString
                }
            } catch {}
            return error.localizedDescription
            
        case .onfido(let error):
            do {
                if let body = try error.response?.mapNSDictionary(),
                    let errorDictionary = body["error"] as? NSDictionary,
                    let fieldsDictionary = errorDictionary["fields"] as? NSDictionary,
                    let errorStrings = fieldsDictionary.allValues.first as? [String],
                    let errorString = errorStrings.first {
                    return errorString
                }
            } catch {}
            return error.localizedDescription
        }
    }
    
    public var errorScreen: ErrorScreenType? {
        switch self {
        case .custom(error: let error):
            if let code = error.errorDetails?.code, let starError = CurrencyErrorDetails(rawValue: code) {
                return starError.returnedScreen()
            }
            if let description = self.errorType, let errorScreenType = ErrorType(rawValue: description) {
                return  errorScreenType.returnedScreen()
            }
        default:
            return nil
        }
        return nil
    }
    
    public var errorType: String? {
        switch self {
        case .custom(let error):
            do {
                if let body = try error.response?.mapNSDictionary(), let errorString = body["errorType"] as? String {
                    return errorString
                }
            } catch {
                print(error)
            }
            return "ERROR"
        case .onfido(error: _):
            return "ERROR"
        }
    }
}

public enum ErrorScreenType {
    case internetConnectionError
    case connectiontTimedOutError
    case workingTowardsCreatingError
    case unknownError
    case insufficientBalanceError
}

// MARK: - Response Handlers

extension Moya.Response {
    
    func mapNSDictionary() throws -> NSDictionary {
        let any = try self.mapJSON()
        guard let dictionary = any as? NSDictionary else {
            throw MoyaError.jsonMapping(self)
        }
        return dictionary
    }
    
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
    
    func mapAsObject() throws -> AnyObject {
        let any = try self.mapJSON()
        return any as AnyObject
    }
}
