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
                                                                            devices: [.iphone],
                                                                            supportsMacDesignedForIOS: true),
                                  dependencies: [TargetDependency] = [],
                                  scripts: [TargetScript] = [],
                                  infoPlistPath: String = "",
                                  coreDataModels: [CoreDataModel] = [],
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

            setting = Settings.settings(base: ["OTHER_LDFLAGS":["-all_load -Objc"]],
                                        configurations: [
                                            .debug(name: "Debug",
                                                   xcconfig: .relativeToRoot("\(projectFolder)/App/Resources/Config/Secrets.xcconfig")),
                                            .release(name: "Release",
                                                     xcconfig: .relativeToRoot("\(projectFolder)/App/Resources/Config/Secrets.xcconfig")),
                                        ],
                                        defaultSettings: .recommended)
        } else {
            setting = Settings.settings(base: ["OTHER_LDFLAGS":["-all_load -Objc"]],
                                configurations: [.debug(name: .debug),
                                                 .release(name: .release)],
                                defaultSettings: .recommended)
        }
        
        let bundleId: String = isProductApp ? "com.Mogong.SYM" : "com.Mogong.SYM.\(name)"
        
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
