//
//  JDGLog.swift
//  JDGFrameworks
//
//  Created by JDG on 2020/12/25.
//  Copyright © 2020年 JDG. All rights reserved.
//

import Foundation

public class JDGLog {
    /// 单例创建的Log配置对象，默认level:information,space:all
    public static let `default` = JDGLog()
    private init() {
        self.displayLevel = .information
        self.displaySpace = []
        self._logDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    /// 默认时间格式为：yyyy-MM-dd HH:mm:ss.SSS
    public var logDateFormatter : String {
        set {
            _logDateFormatter.dateFormat = newValue
        }
        get {
            return _logDateFormatter.dateFormat
        }
    }
    /// 设置需要输出的最高Level
    public var displayLevel : Level
    /// 设置需要输出的的Space,当数组为空时以及包含all时，默认为all
    public var displaySpace : [Space] {
        didSet {
            var containAll = false
            _spaceNames = displaySpace.reduce([]) { (arr, obj) -> [String] in
                if containAll {return []}
                if case .all = obj {
                    containAll = true
                    return []
                }
                var array : [String] = []
                array.append(contentsOf: arr)
                if case .specific(let name) = obj {
                    array.append(name)
                }
                return array
            }
        }
    }
    /// 需要输出的Space的文本数组，在displaySpace修改后会自动更新
    fileprivate var _spaceNames : [String] = []
    /// 日志输出的时间格式器
    private let _logDateFormatter = DateFormatter()
    
    /// 输出日志的主方法
    /// - Parameters:
    ///   - items: 本次需要输出的对象数组
    ///   - level: 本次输出的等级，如果大于需要输出的level，则会忽略掉
    ///   - space: 本次输出所属的space，如果不在需要输出的space中，则会忽略掉
    ///   - style: 本次输出的方式，自定义方式需要满足JDGLogCustomizeProtocol
    ///   - time: 本次输出的时间，默认为当前时间，nil时不会输出
    ///   - file: 调用本次输出的代码所在文件，nil时不会输出
    ///   - selector: 调用本次输出的代码所在方法，nil时不会输出
    ///   - line: 调用本次输出的代码所在文件的行数，nil时不会输出
    public func logOutput(_ items: CustomStringConvertible...
                          , level: Level
                          , space: Space
                          , style: Style
                          , time: Date? = Date()
                          , file: String? = #file
                          , selector: String? = #function
                          , line: Int? = #line
    ) {
        // 如果日志level超过需要显示的level，忽略该条日志
        guard level.rawValue <= displayLevel.rawValue else {return}
        guard displaySpace.containSpace(space) else {return}

        var logToShow = ""
        if let t = time {
            logToShow += _logDateFormatter.string(from: t)
            logToShow += " "
        }
        // 判断是否需要显示文件
        if let f = file {
            logToShow += "\(f.components(separatedBy: "/").last ?? "NOT FOUND") "
        }
        // 判断是否需要显示方法
        if let s = selector {
            logToShow += "[\(s.components(separatedBy: "(").first ?? "NOT FOUND")] "
        }
        // 判断是否需要显示行数
        if let l = line {
            logToShow += "(\(l)) "
        }
        // 遍历组装输出的日志
        logToShow += items.reduce(""){ (result, obj) -> String in
            return result + obj.description
        }
        // 根据style实现输出
        switch style {
        case .customize(let customizeStyle):
            customizeStyle.showJDGLogOutput(logToShow)
        case .file(let path):
            do {
                try logToShow.write(toFile: path, atomically: true, encoding: .utf8)
            } catch let err {
                print(err.localizedDescription)
            }
        case .alert:
            UIAlertController(title: nil, message: nil, preferredStyle: .alert).showJDGLogOutput(logToShow)
        default:
            print(logToShow)
        }
    }
}

extension JDGLog {
    public enum Level : Int {
        case off = 0
        case critical
        case error
        case warning
        case information
        case trace
        case verbose
    }

    public enum Space {
        case all
        case specific(name:String)
    }

    public enum Style {
        case console
        case alert
        case file(path:String)
        case customize(customizeStyle: JDGLogUICustomizeProtocol)
    }
}

extension Array where Element == JDGLog.Space {
    fileprivate func containSpace(_ target: JDGLog.Space) -> Bool {
        var contain = false
        // spaceNames为空时，默认为all
        if JDGLog.default._spaceNames.count == 0 {
            contain = true
        } else {
            if case .specific(let name) = target {
                contain = JDGLog.default._spaceNames.contains(name)
            } else {
                contain = false
            }
        }
        return contain
    }
}

public func JLError(_ items: CustomStringConvertible...
                    , level: JDGLog.Level = .error
                    , space: JDGLog.Space = .all
                    , style: JDGLog.Style = .console
                    , time: Date? = Date()
                    , file: String? = #file
                    , selector: String? = #function
                    , line: Int? = #line) {
    let logToShow = items.reduce(""){ (result, obj) -> String in
        return result + obj.description
    }
    JDGLog.default.logOutput(logToShow, level: level, space: space, style: style, time: time, file: file, selector: selector, line: line)
}

public func JLMessage(_ items: CustomStringConvertible...
                      , level: JDGLog.Level = .information
                      , space: JDGLog.Space = .all
                      , style: JDGLog.Style = .console
                      , time: Date? = Date()
                      , file: String? = #file
                      , selector: String? = #function
                      , line: Int? = #line) {
    let logToShow = items.reduce(""){ (result, obj) -> String in
        return result + obj.description
    }
    JDGLog.default.logOutput(logToShow, level: level, space: space, style: style, time: time, file: file, selector: selector, line: line)
}

public protocol JDGLogUICustomizeProtocol {
    func showJDGLogOutput(_ logToShow: String)
}

extension UIAlertController : JDGLogUICustomizeProtocol {
    public func showJDGLogOutput(_ logToShow: String) {
        message = logToShow
        addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }
}
