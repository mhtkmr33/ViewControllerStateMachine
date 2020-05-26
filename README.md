# ViewControllerStateMachine

1. On hitting api in most of the cases we need to take care of three states i.e loading, no-content and error state.
2. Created a StateMachine mechanism which help us to deal with all the cases efficiently.
3. Implemented it with protocols in order to make it more testable, mockable and reusable

# Usage
1. Create a StateProvider provider using StateBehaviourProvider protocol and provide the desired behaviour to it.

example: 
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

2. Inside your view controller just initialise you stateProvider i.e. 

lazy var stateBehaviourProvider: StateBehaviourProvider = {
        return StateProvider(containerToPresentAllViews: self.stackView)
    }()
    
3. Simple change the state with a inline query i.e. stateBehaviourProvider.changeStateTo(state: .noContent)
