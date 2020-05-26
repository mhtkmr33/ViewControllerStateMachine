import UIKit

enum ViewStates: String {
    case loading
    case error
    case noContent
    case none
}

protocol StateBehaviourProvider {
    var containerToPresentAllViews: UIView { get }
    var currentState: ViewStates { get set }
    var loadingView: UIView { get }
    var errorView: UIView { get }
    var noContentView: UIView { get }
    init(containerToPresentAllViews: UIView)
}

extension StateBehaviourProvider {
    mutating func changeStateTo(state: ViewStates) {
        removeContainerSubviews()
        switch state {
        case .loading:
            setUpAndAddView(identifier: state.rawValue, view: loadingView)
            currentState = .loading
        case .error:
            setUpAndAddView(identifier: state.rawValue, view: errorView)
            currentState = .error
        case .noContent:
            setUpAndAddView(identifier: state.rawValue, view: noContentView)
            currentState = .noContent
        case .none:
            currentState = .none
            break
        }
    }
    
    private func setUpAndAddView(identifier: String, view: UIView) {
        containerToPresentAllViews.addSubview(view)
        view.addConstraintsToSuperView()
        view.accessibilityIdentifier = identifier
    }
    
    @discardableResult private func removeContainerSubviews() -> [Void] {
        let subviews = containerToPresentAllViews.subviews.filter {( $0.accessibilityIdentifier == currentState.rawValue)}
        return subviews.map {( $0.removeFromSuperview() )}
    }
}


struct StateProvider: StateBehaviourProvider {
    
    var currentState: ViewStates = .none
    
    let containerToPresentAllViews: UIView
    
    let loadingView: UIView = {
        let container = UIView()
        container.backgroundColor = .yellow
        return container
    }()
    
    let errorView: UIView = {
        let container = UIView()
        container.backgroundColor = .red
        return container
    }()
    
    let noContentView: UIView = {
        let container = UIView()
        container.backgroundColor = .cyan
        return container
    }()
    
    init(containerToPresentAllViews: UIView) {
        self.containerToPresentAllViews = containerToPresentAllViews
    }
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    lazy var stateBehaviourProvider: StateBehaviourProvider = {
        return StateProvider(containerToPresentAllViews: self.stackView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
    }
    
    //USAGE
    @IBAction func noContentTapped(_ sender: Any) {
        stateBehaviourProvider.changeStateTo(state: .noContent)
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        stateBehaviourProvider.changeStateTo(state: .none)
    }
    
    @IBAction func errorTapped(_ sender: Any) {
        stateBehaviourProvider.changeStateTo(state: .error)
    }
    
    @IBAction func button(_ sender: Any) {
        stateBehaviourProvider.changeStateTo(state: .loading)
    }
    
    
}

extension UIView {
    
    func addConstraintsToSuperView() {
        guard let superView = self.superview else {
            fatalError("No superview present")
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(self.topAnchor.constraint(equalTo: superView.topAnchor))
        constraints.append(self.bottomAnchor.constraint(equalTo: superView.bottomAnchor))
        constraints.append(self.leftAnchor.constraint(equalTo: superView.leftAnchor))
        constraints.append(self.rightAnchor.constraint(equalTo: superView.rightAnchor))
        NSLayoutConstraint.activate(constraints)
    }
}

