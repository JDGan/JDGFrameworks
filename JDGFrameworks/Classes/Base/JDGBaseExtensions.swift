//
//  JDGBaseExtensions.swift
//  JDGFrameworks
//
//  Created by JDG on 2020/12/25.
//  Copyright © 2020年 JDG. All rights reserved.
//

import Foundation

// MARK:- 字符串相关扩展
// MARK:正则表达式
fileprivate struct JDGRegexHelper {
    let regexExpression : NSRegularExpression
    init(_ pattern: String) throws {
        try regexExpression = NSRegularExpression(pattern: pattern)
    }
    
    func matchResult(_ input: String) -> [NSTextCheckingResult] {
        let ocString = NSString(string: input)
        let matches = regexExpression.matches(in: input, options: [], range: NSMakeRange(0, ocString.length))
        return matches
    }
}

public struct JDGRegexCheckingResult {
    var sourceString : NSString
    var pattern : String
    var matchedResults : [NSTextCheckingResult]
    public var stringResults : [String] {
        return matchedResults.map{ sourceString.substring(with: $0.range) }
    }
}

// 返回符合正则表达式的所有内容的数组
infix operator ~~> : ComparisonPrecedence
public func ~~> (lhs: CustomStringConvertible, pattern:String) -> JDGRegexCheckingResult {
    do {
        let result = try JDGRegexHelper(pattern).matchResult(lhs.description)
        return JDGRegexCheckingResult(sourceString: lhs.description as NSString, pattern: pattern, matchedResults: result)
    } catch _ {
        return JDGRegexCheckingResult(sourceString: lhs.description as NSString, pattern: pattern, matchedResults: [])
    }
}

// 判断是否符合正则表达式，能匹配则返回True
infix operator ~== : ComparisonPrecedence
public func ~== (lhs: CustomStringConvertible, pattern:String) -> Bool {
    return (lhs ~~> pattern).matchedResults.count > 0
}

extension String {
    /// 字符串相似度
    /// - Parameter otherString: 进行比较的字符串
    /// - Returns: 0~1的相识度
    public func similarityWithAnother(_ otherString: String) -> Float {
        var equalCount : Float = 0
        for (c1, c2) in zip(self, otherString) {
            if c1 == c2 {
                equalCount += 1
            }
        }
        return equalCount/Float(count)
    }
}
