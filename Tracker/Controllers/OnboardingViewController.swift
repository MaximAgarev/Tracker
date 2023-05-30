import UIKit

final class OnboardingViewController: UIPageViewController {
    lazy var pages: [UIViewController] = {
        
        let blueOnboardingScreen = makeOnboardingPage(
            image: "OnboardingBlue",
            text: "Отслеживайте только то, что хотите"
        )
        
        let redOnboardingScreen = makeOnboardingPage(
            image: "OnboardingRed",
            text: "Даже если это \n не литры воды и йога"
        )

        return [blueOnboardingScreen, redOnboardingScreen]
    }()
    
    lazy var pageControl: UIPageControl = {
            let pageControl = UIPageControl()
            pageControl.numberOfPages = pages.count
            pageControl.currentPage = 0
            
            pageControl.currentPageIndicatorTintColor = .ypBlack
            pageControl.pageIndicatorTintColor = .ypBlack?.withAlphaComponent(0.3)
            
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            return pageControl
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
                
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        view.addSubview(pageControl)
                
                NSLayoutConstraint.activate([
                    pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168),
                    pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                ])
    }
    
    func makeOnboardingPage(image: String, text: String) -> UIViewController {
        let onboardingPage = UIViewController()
        
        let backgroundImageView: UIImageView = {
            let backgroundImage = UIImage(named: image)
            let backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            return backgroundImageView
        }()
        
        let textLabel: UILabel = {
            let textLabel = UILabel()
            textLabel.text = text
            textLabel.lineBreakMode = .byWordWrapping
            textLabel.numberOfLines = 0
            textLabel.textAlignment = .center
            textLabel.font = .boldSystemFont(ofSize: 32)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            return textLabel
        }()
        
        let dismissButton: UIButton = {
            let dismissButton = UIButton()
            dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
            dismissButton.layer.cornerRadius = 16
            dismissButton.layer.masksToBounds = true
            dismissButton.backgroundColor = .ypBlack
            dismissButton.setTitle("Вот это технологии!", for: .normal)
            dismissButton.setTitleColor(.ypWhite, for: .normal)
            dismissButton.titleLabel?.font = .systemFont(ofSize: 16)
            dismissButton.translatesAutoresizingMaskIntoConstraints = false
            return dismissButton
        }()
        
        guard let view = onboardingPage.view else { return UIViewController() }
        
        view.addSubview(backgroundImageView)
        view.addSubview(textLabel)
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 432),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            dismissButton.heightAnchor.constraint(equalToConstant: 60),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
         return onboardingPage
    }
    
    @objc
    func didTapDismissButton() {
        self.dismiss(animated: true)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }
        
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
