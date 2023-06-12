import UIKit

final class TabBarController: UITabBarController {
    
    var trackersViewController: UINavigationController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .ypWhite
        
        trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        trackersViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackersTitle", comment: ""),
            image: UIImage(named: "Trackers TabBar Icon"),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statisticsTitle", comment: ""),
            image: UIImage(named: "Stats TabBar Icon"),
            selectedImage: nil
        )
        
        
        self.viewControllers = [trackersViewController, statisticsViewController]
        
    }
    
}
