import SwiftUI




@main
struct Tomator: App {
    // 将StatusItem作为应用程序的代理
    @NSApplicationDelegateAdaptor(MenuBarController.self) var appDelegate
   
    init() {
        // 初始化共享实例
        MenuBarController.shared = appDelegate
        // 记录应用启动事件
        logger.append(event: AppStart())
        // 开机自启
        let appSetter = AppSetter.shared
        let shouldLaunchAtLogin = appSetter.launchAtLogin
        DispatchQueue.main.async {
            if shouldLaunchAtLogin {
                appSetter.setLaunchAtLogin(true)
                logger.append(event: SetLaunch(value: true))
            }
        }
    }

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}


