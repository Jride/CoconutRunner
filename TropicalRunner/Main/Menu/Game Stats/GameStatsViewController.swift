//
//  GameStatsViewController.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 10/07/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit
import TweenKit

protocol Animating: class {
    var stat: Stat { get }
    func runAnimation(with scheduler: ActionScheduler, completion: @escaping () -> Void)
}

enum Stat: CaseIterable {
    case health
    case distance
    case banana
    
    var reuseId: String {
        switch self {
        case .health: return "HealthStatsItem"
        case .distance: return "DistanceStatsItem"
        case .banana: return "BananaStatsItem"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .health: return UIImage(named: "healthIcon")
        case .distance: return UIImage(named: "stamina")
        case .banana: return UIImage(named: "banana")
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .health: return .red
        case .distance: return .orange
        case .banana: return .yellow
        }
    }
    
    var title: String {
        switch self {
        case .health: return "DAMAGE TAKEN"
        case .distance: return "DISTANCE"
        case .banana: return "BANANAS COLLECTED"
        }
    }
}

class StatsCoordinator {
    
    struct Score {
        var damage: Int = 0
        var distance: Int = 0
        var banana: Int = 0
        var total: Int {
            distance + damage + banana
        }
    }
    
    private var score = Score()
    private var animatingObjects = [Animating]()
    private var completionHandler: (() -> Void)?
    private let actionScheduler: ActionScheduler
    
    init(scheduler: ActionScheduler) {
        actionScheduler = scheduler
    }
    
    private func runAnimation(atIndex index: Int) {
        
        guard let animatingObject = animatingObjects[maybe: index] else {
            completionHandler?()
            return
        }
        
        animatingObject.runAnimation(with: actionScheduler) { [weak self] in
            self?.runAnimation(atIndex: index+1)
        }
    }
}

extension StatsCoordinator {
    func addAnimatingObject(_ object: Animating) {
        animatingObjects.append(object)
    }
    
    func startAnimation(complete: @escaping () -> Void) {
        completionHandler = complete
        runAnimation(atIndex: 0)
    }
    
    func score(for stat: Stat) -> (value: Int, score: Int) {
        switch stat {
        case .banana:
            let val = 50
            score.banana = Int(Double(val) * 1.4)
            return (value: val, score: score.banana)
        case .distance:
//            let val = Env.gameState.playersDistanceStats.overallDistance
            let val = 500
            score.distance = Int(Double(val) * 1.2)
            return (value: val, score: score.distance)
        case .health:
            let val = 80
            score.damage = -(Int(Double(val) * 1.2))
            return (value: val, score: score.damage)
        }
    }
}

class GameStatsViewController: UIViewController {
    
    enum Item {
        case header(StatsHeaderFooterView.Config)
        case stat(Stat)
        case footer(StatsHeaderFooterView.Config)
    }
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var scrollview: UIScrollView!
    @IBOutlet private var closeButton: UIButton!
    
    private let screenHeight = UIScreen.main.bounds.height
    private let menuHeight: CGFloat
    private let menuWidth: CGFloat
    private let scheduler = ActionScheduler()
    
    private var items = [Item]()
    private let statsCoordinator: StatsCoordinator
    private var statItems = [StatsItemView]()
    private var cons_containerOffset: NSLayoutConstraint?
    
    var containerStackView = UIStackView(frame: .zero)
    
    static func present(on viewController: UIViewController) {
        
        let vc = GameStatsViewController()
        vc.modalPresentationStyle = .overCurrentContext
        viewController.present(vc, animated: false, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollview.contentSize.width = scrollview.bounds.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.isHidden = true
        closeButton.alpha = 0
        view.backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        containerView.pinWidth(menuWidth)
        containerView.pinHeight(menuHeight)
        containerView.pinToSuperviewCenterX()
        cons_containerOffset = containerView.pinToSuperviewCenterY(offset: -screenHeight, priority: nil)
        
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.axis = .vertical
        scrollview.addSubview(containerStackView)
        containerStackView.pinToSuperviewEdges()
        
        scrollview.alwaysBounceVertical = true
        scrollview.contentInset = .init(top: 30, left: 0, bottom: 0, right: 0)
        
        items.forEach(setupView(forItem:))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerView.slideInFromTop(scheduler: scheduler, parent: view) { [unowned self] in
            self.cons_containerOffset?.constant = 0
            self.statsCoordinator.startAnimation {
                self.closeButton.isHidden = false
                self.closeButton.fadeIn()
            }
        }
        
    }
    
    init() {
        let widthToHeightRatio: CGFloat = 720.0/720.0
        let height = screenHeight * 0.9
        
        self.menuHeight = height
        self.menuWidth = widthToHeightRatio * height
        self.statsCoordinator = StatsCoordinator(scheduler: scheduler)
        
        super.init(nibName: "GameStatsViewController", bundle: nil)
        
        items = [
            .header(.init(lhsText: "LEVEL: 1", rhsText: "SCORE")),
            .stat(.distance),
            .stat(.health),
            .stat(.banana),
            .footer(.init(lhsText: "TOTAL:", rhsText: "2323124"))
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction private func closeButtonTapped(_ sender: Any) {
        containerView.slideOutToTop(scheduler: scheduler) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func setupView(forItem item: Item) {
        
        switch item {
        case .header(let config):
            let headerView = StatsHeaderFooterView(frame: .zero)
            containerStackView.addArrangedSubview(headerView)
            headerView.pinWidthToSameAsView(scrollview)
            headerView.lhsText = config.lhsText
            headerView.rhsText = config.rhsText
            
        case .stat(let stat):
            let view = StatsItemView(frame: .zero)
            statItems.append(view)
            containerStackView.addArrangedSubview(view)
            view.pinWidthToSameAsView(scrollview)
            view.configure(with: .init(statsCoordinator: statsCoordinator, stat: stat))
            statsCoordinator.addAnimatingObject(view)
            
        case .footer(let config):
            let footerView = StatsHeaderFooterView(frame: .zero)
            containerStackView.addArrangedSubview(footerView)
            footerView.pinWidthToSameAsView(scrollview)
            footerView.lhsText = config.lhsText
            footerView.rhsText = config.rhsText
        }
        
    }
}
