enum TBStateMachineEvents {
    case startStop, timerFired, skipRest
}

enum TBStateMachineStates {
    case idle, work, rest
}

class TBStateMachine {
    private var currentState: TBStateMachineStates
    private var workToRestHandlers: [() -> Void] = []
    private var workToAnyHandlers: [() -> Void] = []
    private var anyToWorkHandlers: [() -> Void] = []
    private var anyToRestHandlers: [() -> Void] = []
    private var restToWorkHandlers: [() -> Void] = []
    private var anyToIdleHandlers: [() -> Void] = []
    private var anyToAnyHandlers: [() -> Void] = []
    
    init(state: TBStateMachineStates) {
        self.currentState = state
    }
    
    func add_workToRest(handler: @escaping () -> Void) {
        workToRestHandlers.append(handler)
    }
    
    func add_workToAny(handler: @escaping () -> Void) {
        workToAnyHandlers.append(handler)
    }
    
    func add_anyToWork(handler: @escaping () -> Void) {
        anyToWorkHandlers.append(handler)
    }
    
    func add_anyToRest(handler: @escaping () -> Void) {
        anyToRestHandlers.append(handler)
    }
    
    func add_restToWork(handler: @escaping () -> Void) {
        restToWorkHandlers.append(handler)
    }
    
    func add_anyToIdle(handler: @escaping () -> Void) {
        anyToIdleHandlers.append(handler)
    }
    
    func add_anyToAny(handler: @escaping () -> Void) {
        anyToAnyHandlers.append(handler)
    }
    
    func tryEvent(_ event: TBStateMachineEvents, condition: (() -> Bool)? = nil) -> Bool {
        let oldState = currentState
        var transitioned = false
        
        switch (currentState, event) {
        case (.idle, .startStop):
            currentState = .work
            transitioned = true
        case (.work, .startStop):
            currentState = .idle
            transitioned = true
        case (.rest, .startStop):
            currentState = .idle
            transitioned = true
        case (.work, .timerFired):
            currentState = .rest
            transitioned = true
        case (.rest, .timerFired):
            if let condition = condition, condition() {
                currentState = .idle
            } else {
                currentState = .work
            }
            transitioned = true
        case (.rest, .skipRest):
            currentState = .work
            transitioned = true
        default:
            break
        }
        
        if transitioned {
            for handler in anyToAnyHandlers {
                handler()
            }
            
            if oldState == .work && currentState == .rest {
                for handler in workToRestHandlers {
                    handler()
                }
            }
            
            if oldState == .work {
                for handler in workToAnyHandlers {
                    handler()
                }
            }
            
            if currentState == .work {
                for handler in anyToWorkHandlers {
                    handler()
                }
            }
            
            if currentState == .rest {
                for handler in anyToRestHandlers {
                    handler()
                }
            }
            
            if oldState == .rest && currentState == .work {
                for handler in restToWorkHandlers {
                    handler()
                }
            }
            
            if currentState == .idle {
                for handler in anyToIdleHandlers {
                    handler()
                }
            }
        }
        
        return transitioned
    }
    
    var state: TBStateMachineStates {
        return currentState
    }
}
