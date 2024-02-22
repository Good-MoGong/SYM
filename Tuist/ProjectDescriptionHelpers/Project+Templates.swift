import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    
    // 타켓을 모아서 프로젝트를 만드는 것 -> 타겟 매개변수로 받기
    public static func makeProject(
        targets: [Target],
        name: String,
        isXcconfigSet: Bool = false,
        packages: [Package]
    ) -> Project {

        // 프로젝트 이름은 프로젝트마다 달라야함 이렇게 되면 의존성 프로젝트까지 SPM으로 가져가게 됨
//        let name = "SYM"
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
        
        // 메인 앱일때만 시크릿 키가 필요할때 적용해주면 됨
        if isProductApp, isXcconfigSet {
            // 빌드 세팅 (xcconfig 있을경우)
//            setting = Settings.settings(configurations: [
//            setting = Settings.settings(base: ["OTHER_LDFLAGS":"-Xlinker -no_warn_duplicate_libraries"],
            setting = Settings.settings(base: ["OTHER_LDFLAGS":["-ObjC"]],
                                        configurations: [
                                            .debug(name: "Debug",
                                                   xcconfig:.relativeToRoot("\(projectFolder)/App/Resources/Config/Secrets.xcconfig")),
                                            .release(name: "Release",
                                                     xcconfig: .relativeToRoot("\(projectFolder)/App/Resources/Config/Secrets.xcconfig")),
                                        ],
                                        defaultSettings: .recommended)
        } else {
            // 빌드 세팅 (기본)
            setting = .settings(base: [:],
                                configurations: [.debug(name: .debug),
                                                 .release(name: .release)],
                                defaultSettings: .recommended)
        }
        
        return Project(name: name,
                       organizationName: orgaizationName,
                       options: Project.Options.options(),
                       packages: packages, // -> project 자체에 라이브러리 주입 x -> 타겟 단위로 라이브러리 주입하여 타겟끼리 의존성 생성해야함
                       settings: setting,
                       targets: targets,
                       schemes: schemes)
    }
}
