import UIKit

enum AppFactory {
    static func makeMainTabBarController() -> UITabBarController {
        let context = CoreDataStack.shared.context
        
        let trackerStore = TrackerStore(context: context)
        let trackerCategoryStore = TrackerCategoryStore(context: context, trackerStore: trackerStore)
        let trackerRecordStore = TrackerRecordStore(context: context)
        
        let trackersVC = TrackersViewController(
            trackerCategoryStore: trackerCategoryStore,
            trackerStore: trackerStore,
            trackerRecordStore: trackerRecordStore
        )
        
        let trackersNavController = UINavigationController(rootViewController: trackersVC)
        trackersNavController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .trackers1),
            selectedImage: .trackers2
        )
        
        let statisticVC = StatisticViewController()
        statisticVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .stat1),
            selectedImage: .stat2
        )
        
        let tabBarController = UITabBarController()
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = UIColor.lightGray
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        tabBarController.viewControllers = [
            trackersNavController,
            statisticVC
        ]
        
        return tabBarController
    }
}

