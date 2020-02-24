//
//  CurrencyAPI.swift
//  CurrencyNBRB
//
//  Created by Dimon on 2/24/20.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation
import Moya

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

var paymentProvider: MoyaProvider<CurrencyRequest> {
    let authProvider = MoyaProvider<CurrencyRequest>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
    return authProvider
}

public enum CurrencyRequest {
    case requestCurrency(comment: String?)
}

extension CurrencyRequest: TargetType {
    
    public var baseURL: URL {
        switch self {
        case .requestCurrency(comment: _):
            return URL(string: Configuration.baseDomain + Configuration.version)!
        default:
            return URL(string: Configuration.baseDomain + Configuration.version)!
        }
    }
    
    public var path: String {
        switch self {
        case .requestCurrency(comment: _):
            return ""
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .requestCurrency(comment: _):
            return .get
        default:
            return .post
        }
    }
    
    public var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case .requestCurrency(comment: _):
            break
            
            //        case .createStripePayment(clientID: let clientID, accountID: _, currency: let currency, paymentAccountReference: let paymentAccountReference, provider: let provider):
            //            params["clientId"] = clientID
            //            params["paymentAccountReference"] = paymentAccountReference
            //            params["provider"] = provider
            //            params["currency"] = currency
            //            break
        }
        return .requestPlain
    }
    
    public var validationType: ValidationType {
        switch self {
        default:
            return .successCodes
        }
    }
    
    public var sampleData: Data {
        switch self {
        default:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        }
    }
    
    public var headers: [String : String]? {
        var headers: [String: String] = [:]
        //        let token = UserDataManager.shared.accessToken
        //        if token.count > 0 {
        //            headers["access-token"] = token
        //        }
        //        headers["App"] = Configuration.application
        return headers
    }
}
