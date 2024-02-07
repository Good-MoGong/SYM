//
//  Scheme+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 박서연 on 2023/12/19.
//

import ProjectDescription

extension Scheme {
    /// https://baegteun.tistory.com/2 Extenstion Scheme 아예 가져왔음
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
            return Scheme(
                name: name,
                shared: true,
                buildAction: .buildAction(targets: ["\(name)"]),
                // 테스트 코드 관련인듯? 딱히 필요없어보임
                testAction: .targets(
                    ["\(name)Tests"],
                    configuration: target,
                    options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
                ),
                runAction: .runAction(configuration: target),
                archiveAction: .archiveAction(configuration: target),
                profileAction: .profileAction(configuration: target),
                analyzeAction: .analyzeAction(configuration: target)
            )
        }
}
