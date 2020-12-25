//
//  JDGProjectConfiguration.swift
//  JDGFrameworks
//
//  Created by JDGan on 2020/12/24.
//

import Foundation

/// 项目基本配置
public struct JDGProjectConfiguration {
    /// 仅提供默认的项目配置，不允许创建新配置对象
    public static let `default` = JDGProjectConfiguration()
    
    /// 当前本地化的语言，默认或选择系统支持的语言
    public var currentLanguage : String
    
    /// 当前的日志配置
    public var log : JDGLog = JDGLog.default
    
}

extension JDGProjectConfiguration {
    /// 私有初始化方法，不允许外部创建
    private init() {
        if let systemPrefered = Locale.preferredLanguages.first {
            var similarity : Float = 0
            self.currentLanguage = ""
            for language in Self.supportingLanguages {
                let s = systemPrefered.similarityWithAnother(language)
                if s > similarity {
                    self.currentLanguage = language
                    similarity = s
                }
            }
            if similarity <= 0 {
                self.currentLanguage = "Base"
            }
        } else {
            self.currentLanguage = "Base"
        }
    }
}

// 本地化语言相关支持
extension JDGProjectConfiguration {
    /// 获取项目配置的多语言列表，生成了.lproj的文件夹名称
    public static var supportingLanguages : [String] {
        let fm = FileManager.default
        guard let path = Bundle.main.resourcePath, let children = fm.enumerator(atPath: path) else {return []}
        var result : [String] = []
        for dir in children {
            if let subPath = dir as? String,
               subPath ~== "^[^/]+\\.lproj$",
               let name = subPath.components(separatedBy: ".").first {
                result.append(name)
            }
        }
        return result
    }
}
