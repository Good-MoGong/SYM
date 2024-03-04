import SwiftUI
import Firebase
import FirebaseCore
import FirebaseMessaging
import KakaoSDKCommon
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Apns에 앱 등록 요청
        application.registerForRemoteNotifications()
        
        // 알림 허용 설정
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

@main
struct SYMApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var container: DIContainer = .init(services: Services())
    
    init() {
        let kakaoKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY")
        KakaoSDK.initSDK(appKey: kakaoKey as? String ?? "")
    }
    
    var body: some Scene {
        WindowGroup {
            AuthenticatedView(authViewModel: .init(container: container))
                .environmentObject(container)
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
                .dismissKeyboardOnTap()
        }
        
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // foreground 일때
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge])
    }
    
    // 푸시를 눌렀을 때 어떤 처리를 할 것인지
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
}
