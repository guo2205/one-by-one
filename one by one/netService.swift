//
//  netService.swift
//  one by one
//
//  Created by 郭凌峰 on 2017/9/27.
//  Copyright © 2017年 郭凌峰. All rights reserved.
//

import Foundation
import Moya

enum netWorkService {
    case list
}
extension netWorkService:TargetType {
    var baseURL: URL {
        let baseUrl = "http://obo.lingfeng.me"
        return URL(string:baseUrl)!
    }
    
    var path: String {
        switch self {
        case .list:
            return "/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .list:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data{
        switch self {
        case .list:
            return "list test data:".utf8Encoded
        }
    }
    
    var task: Task {
        switch  self {
        case .list:
            return .request
        }
    }
}

private extension String {
    var urlEscaped:String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    var utf8Encoded:Data {
        return self.data(using: .utf8)!
    }
}
