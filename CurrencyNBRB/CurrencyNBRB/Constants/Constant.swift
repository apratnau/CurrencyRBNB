//
//  Constant.swift
//  CurrencyNBRB
//
//  Created by Dimon on 2/24/20.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation

public struct ConstantUserDefaults {
    static let user = "UserDefaultsUserKey"
    //...
}

struct Configuration {
    static let baseDomain = devServerDomain
    
    static let devServerDomain = "http://www.nbrb.by/API/ExRates/Currencies"
    static let version = "v1/"
    //...
}

public struct ConstantFormatter {
    static let dateFormatterServer = "yyyy-MM-dd"
    static let dateFormatterTextField = "dd.MM.yyyy"
    static let dateFormatterReqestsCell = "dd.MM HH:mm"
    static let dateFormatterTransactionDetails = "dd MMM HH:mm"
    static let dateGraphFormatterServer = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let dateFormatterHorizontalCharts = "dd.MM"
    static let dateFormatterFilterButton = "dd.MMM.yy"
    //...
}
