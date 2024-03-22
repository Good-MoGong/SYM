import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    
    public static func makeProject(
        targets: [Target],
        name: String,
        isXcconfigSet: Bool = false,
        packages: [Package]
    ) -> Project {
        
        let orgaizationName = "Mogong"
        var setting: Settings?
        var schemes: [Scheme] = []
        
        // 타겟중에 app인 얘만 뽑기
        let isProductApp = targets.contains { target in
            target.product == .app
        }
        
        // 메인일때만 메인용 스킴 생성
        if isProductApp {
            schemes = [.makeScheme(target: .debug, name: name)]
        }
        
        if isProductApp, isXcconfigSet {
            setting = Settings.settings(base: ["OTHER_LDFLAGS":["-ObjC"]],
                                        configurations: [
                                            .debug(name: "Debug",
                                                   xcconfig:.relativeToRoot("\(projectFolder)/App/Resources/Config/Secrets.xcconfig")),
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
        
        return Project(name: name,
                       organizationName: orgaizationName,
                       options: .options(
                        defaultKnownRegions: ["en", "ko"],
                        developmentRegion: "ko"
                       ),
                       packages: packages,
                       settings: setting,
                       targets: targets,
                       schemes: schemes)
    }
}


