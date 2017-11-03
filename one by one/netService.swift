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
    case miss
    case signlist
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
            case .miss:
                return "/miss"
            case .signlist:
                return "/queryMiss"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .list:
            return .get
        case .miss:
            return .get
            
        case .signlist:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .list:
            return nil
        case .miss:
            return nil
        case .signlist:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list:
            return URLEncoding.default
        case .miss:
            return URLEncoding.default
        case .signlist:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data{
        switch self {
        case .list:
            return "list test data:".utf8Encoded
        case .miss:
            return "miss test data:".utf8Encoded
        case .signlist:
            return "signlist test dasta".utf8Encoded
        }
    }
    
    var task: Task {
        switch  self {
        case .list:
            return .request
        case .miss:
            return .request
        case .signlist:
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
