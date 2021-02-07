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
    case damage
    case distance
    case banana
    
    var reuseId: String {
        switch self {
        case .damage: return "HealthStatsItem"
        case .distance: return "DistanceStatsItem"
        case .banana: return "BananaStatsItem"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .damage: return UIImage(named: "healthIcon")
        case .distance: return UIImage(named: "stamina")
        case .banana: return UIImage(named: "banana")
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .damage: return UIColor(hex: 0xDA2222)
        case .distance: return UIColor(hex: 0xFF6600)
        case .banana: return UIColor(hex: 0xEBAD12)
        }
    }
    
    var title: String {
        switch self {
        case .damage: return "DAMAGE TAKEN"
        case .distance: return "DISTANCE"
        case .banana: return "BANANAS COLLECTED"
        }
    }
    
    var value: Int {
        switch self {
        case .damage: return Env.gameState.totalDamageTaken
        case .distance: return Env.gameState.playersDistanceStats.overallDistance
        case .banana: return Env.gameState.totalBananasCollected
        }
    }
    
    var readableValue: String {
        switch self {
        case .distance: return "\(value) Meters"
        case .banana, .damage: return "\(value)"
        }
    }
}

final class StatsCoordinator {
    
    struct Score {
        var damage: Int = 0
        var distance: Int = 0
        var banana: Int = 0
        var total: Int {
            distance + damage + banana
        }
    }
    
    var footerView: StatsHeaderFooterView?
    
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
    
    func score(for stat: Stat) -> Int {
        switch stat {
        case .banana:
            score.banana = Int(Double(stat.value) * 1.4)
            return score.banana
        case .distance:
            score.distance = Int(Double(stat.value) * 1.2)
            return score.distance
        case .damage:
            score.damage = -(Int(Double(stat.value) * 1.2))
            return score.damage
        }
    }
    
    var totalScore: Int {
        score.total
    }
}

final class GameStatsViewController: UIViewController {
    
    var didClose: (() -> Void)?
    
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
    
    private var containerStackView = UIStackView(frame: .zero)
    
    static func present(on viewController: UIViewController) -> GameStatsViewController {
        
        let vc = GameStatsViewController()
        vc.modalPresentationStyle = .overCurrentContext
        viewController.present(vc, animated: false, completion: nil)
        return vc
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
        containerStackView.spacing = Env.device.isPad ? 20 : 5
        scrollview.addSubview(containerStackView)
        containerStackView.pinToSuperviewEdges()
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
        let widthToHeightRatio: CGFloat = 700/500
        let height = screenHeight * 0.9
        
        self.menuHeight = height
        self.menuWidth = widthToHeightRatio * height
        self.statsCoordinator = StatsCoordinator(scheduler: scheduler)
        
        super.init(nibName: "GameStatsViewController", bundle: nil)
        
        let level = Env.gameLogic.currentLevelConfig.level
        items = [
            .header(.init(lhsText: "LEVEL: \(level)", rhsText: "SCORE")),
            .stat(.distance),
            .stat(.damage),
            .stat(.banana),
            .footer(.init(lhsText: "TOTAL:", rhsText: "0"))
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction private func closeButtonTapped(_ sender: Any) {
        containerView.slideOutToTop(scheduler: scheduler) {
            self.dismiss(animated: false, completion: { [weak self] in
                self?.didClose?()
            })
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
            statsCoordinator.footerView = footerView
        }
        
    }
}
