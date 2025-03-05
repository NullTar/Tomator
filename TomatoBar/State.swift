// 状态机事件枚举
enum TBStateMachineEvents {
    case startStop, timerFired, skipRest
}

// 状态机状态枚举
enum TBStateMachineStates {
    case idle, work, rest
}

// 番茄钟状态机类
class TBStateMachine {
    private var currentState: TBStateMachineStates
    // 各种状态转换处理器数组
    private var workToRestHandlers: [() -> Void] = []    // 工作到休息的处理器
    private var workToAnyHandlers: [() -> Void] = []     // 工作到任意状态的处理器
    private var anyToWorkHandlers: [() -> Void] = []     // 任意状态到工作的处理器
    private var anyToRestHandlers: [() -> Void] = []     // 任意状态到休息的处理器
    private var restToWorkHandlers: [() -> Void] = []    // 休息到工作的处理器
    private var anyToIdleHandlers: [() -> Void] = []     // 任意状态到空闲的处理器
    private var anyToAnyHandlers: [() -> Void] = []      // 任意状态转换的处理器
    
    // 初始化状态机
    init(state: TBStateMachineStates) {
        self.currentState = state
    }
    
    // 添加工作到休息的状态转换处理器
    func add_workToRest(handler: @escaping () -> Void) {
        workToRestHandlers.append(handler)
    }
    
    // 添加工作到任意状态的转换处理器
    func add_workToAny(handler: @escaping () -> Void) {
        workToAnyHandlers.append(handler)
    }
    
    // 添加任意状态到工作的转换处理器
    func add_anyToWork(handler: @escaping () -> Void) {
        anyToWorkHandlers.append(handler)
    }
    
    // 添加任意状态到休息的转换处理器
    func add_anyToRest(handler: @escaping () -> Void) {
        anyToRestHandlers.append(handler)
    }
    
    // 添加休息到工作的状态转换处理器
    func add_restToWork(handler: @escaping () -> Void) {
        restToWorkHandlers.append(handler)
    }
    
    // 添加任意状态到空闲的转换处理器
    func add_anyToIdle(handler: @escaping () -> Void) {
        anyToIdleHandlers.append(handler)
    }
    
    // 添加任意状态转换的处理器
    func add_anyToAny(handler: @escaping () -> Void) {
        anyToAnyHandlers.append(handler)
    }
    
    // 尝试触发事件并执行状态转换
    func tryEvent(_ event: TBStateMachineEvents, condition: (() -> Bool)? = nil) -> Bool {
        let oldState = currentState
        var transitioned = false
        
        // 根据当前状态和事件确定下一个状态
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
            // 根据条件决定是进入空闲状态还是工作状态
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
        
        // 如果状态发生转换，执行相应的处理器
        if transitioned {
            // 执行任意状态转换的处理器
            for handler in anyToAnyHandlers {
                handler()
            }
            
            // 执行工作到休息的处理器
            if oldState == .work && currentState == .rest {
                for handler in workToRestHandlers {
                    handler()
                }
            }
            
            // 执行工作到任意状态的处理器
            if oldState == .work {
                for handler in workToAnyHandlers {
                    handler()
                }
            }
            
            // 执行任意状态到工作的处理器
            if currentState == .work {
                for handler in anyToWorkHandlers {
                    handler()
                }
            }
            
            // 执行任意状态到休息的处理器
            if currentState == .rest {
                for handler in anyToRestHandlers {
                    handler()
                }
            }
            
            // 执行休息到工作的处理器
            if oldState == .rest && currentState == .work {
                for handler in restToWorkHandlers {
                    handler()
                }
            }
            
            // 执行任意状态到空闲的处理器
            if currentState == .idle {
                for handler in anyToIdleHandlers {
                    handler()
                }
            }
        }
        
        return transitioned
    }
    
    // 获取当前状态
    var state: TBStateMachineStates {
        return currentState
    }
}
