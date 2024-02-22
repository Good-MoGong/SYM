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
    
    // device token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

@main
struct SYMApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var container: DIContainer = .init(services: Services())
    
    // 카카오로그인 작업
    init() {
        // Kakao SDK 초기화
        let kakaoKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY")
        KakaoSDK.initSDK(appKey: kakaoKey as? String ?? "")
    }
    
    var body: some Scene {
        WindowGroup {
            AuthenticatedView(authViewModel: .init(container: container))
                .environmentObject(container)
                .onOpenURL { url in // 뷰가 속한 Window에 대한 URL을 받았을 때 호출할 Handler를 등록하는 함수
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
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
