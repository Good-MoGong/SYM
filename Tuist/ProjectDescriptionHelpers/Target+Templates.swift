//
//  Target+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 박서연 on 2023/12/19.
//
 
import ProjectDescription

extension Target {
    public static func makeTarget(name: String,
                                  platform: Platform = .iOS,
                                  product: Product,
                                  deploymentTarget: DeploymentTarget = .iOS(targetVersion: "16.4",
                                                                            devices: [.iphone, .ipad],
                                                                            supportsMacDesignedForIOS: true),
                                  dependencies: [TargetDependency] = [],
                                  scripts: [TargetScript] = [],
                                  //infoPlist: InfoPlist = .default, // 직접추가 말고 추후에 plist 파일 생성해서 경로로 사용하기 .file(path: "Support/Info.plist")
                                  infoPlistPath: String = "",
                                  coreDataModels: [CoreDataModel] = [],
                                  // 리소스는 모든 프로젝트에 필요한게 아님 (리소스 => 에셋 같은거) 그래서 bool 으로 받아야함
                                  isResource: Bool = false
    ) -> [Self] {
        
        let sources: SourceFilesList = ["Sources/**"]
        
        var resources: ResourceFileElements? {
            if isResource {
                return ["Resources/**"]
            } else {
                return nil
            }
        }
        
        let isProductApp = product == .app ? true : false

        var setting: Settings?
        var entitlements: Entitlements?
        
        if isProductApp {
            entitlements = "SYM.entitlements"
//            setting = Settings.settings(base: ["OTHER_LDFLAGS":["-all_load -Objc"]],
            setting = Settings.settings(base: ["OTHER_LDFLAGS":["-Objc"]],
                                        configurations: [
                                            .debug(name: "Debug",
                                                   xcconfig: .relativeToRoot("\(projectFolder)/App/Resources/Config/Secrets.xcconfig")),
                                            .release(name: "Release",
                                                     xcconfig: .relativeToRoot("\(projectFolder)/App/Resources/Config/Secrets.xcconfig")),
                                        ],
                                        defaultSettings: .recommended)
        } else {
            setting = .settings(base: [:],
                                configurations: [.debug(name: .debug),
                                                 .release(name: .release)],
                                defaultSettings: .recommended)
        }
        
        var bundleID: String?
        let bundleId: String = isProductApp ? "com.Mogong.SYM" : "com.Mogong.SYM.\(name)"
        
        //infoPlist 경로로 설정
        var infoPlist: InfoPlist {
            if infoPlistPath.isEmpty {
                return .default
            } else {
                return .file(path: "\(infoPlistPath)")
            }
        }
        
        let addTarget = Target(name: name,
                               platform: platform,
                               product: product,
                               bundleId: bundleId,
                               deploymentTarget: deploymentTarget,
                               infoPlist: infoPlist, // 변경
                               sources: sources,
                               resources: resources,
                               entitlements: entitlements,
                               scripts: scripts,
                               dependencies: dependencies,
                               settings: setting)

        var targets: [Target] = [addTarget]
        
        return targets
    }
}
