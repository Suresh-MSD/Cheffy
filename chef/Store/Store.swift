//
//  Store.swift
//  chef
//
//  Created by Oluha group on 2019/09/27.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//s

import Foundation
import ReSwift

struct State: StateType, Codable {
    var token: String?
    var loginUser: User?
    var newPlates: [PlateType]
    var nearPlates: [PlateType]
    var popularPlates: [PlateType]
}

struct Actions {
    struct login: Action {
        var loginUser: User
        var token: String
    }
    struct signup: Action {
        var loginUser: User
        var token: String
    }
    struct logout: Action {}
    struct setNewPlates: Action { var plates: [PlateType] }
    struct setPopularPlates: Action { var plates: [PlateType] }
    struct setNearPlates: Action { var plates: [PlateType] }
}

let initial = State(
    token: nil,
    loginUser: nil,
    newPlates: [],
    nearPlates: [],
    popularPlates: []
)

func reducer(action: Action, state: State?) -> State {
    var state = state ?? initial

    switch action {
    case let action as Actions.login:
            state.loginUser = action.loginUser
            state.token = action.token
    case _ as Actions.logout:
            state.loginUser = nil
    case let action as Actions.setNewPlates:
        state.newPlates = action.plates
    case let action as Actions.setPopularPlates:
        state.popularPlates = action.plates
    case let action as Actions.setNearPlates:
        state.newPlates = action.plates
    default: break
    }

    return state
}

struct ReSwiftPersist {
    static let persistenceKey = "ReSwiftPersistence"
    static func initState(initial: State) -> State {
        guard let data = UserDefaults.standard.data(forKey: persistenceKey) else { return initial }
        let state = try? JSONDecoder().decode(State.self, from: data)
        return state ?? initial
    }
    
    static var middleware: Middleware<State> {
        return { dispatch, getState in { next in return { action in
            next(action)
            let data = try? JSONEncoder().encode(getState())
            UserDefaults.standard.set(data, forKey: persistenceKey)
        }}}
    }
}

let LoggerMiddleware: Middleware<State> = { dispatch, getState in
    return { next in return { action in
        print("#ReSwift Action Log")
        dump(action)
        next(action)
    }}
}

let store = Store(
    reducer: reducer,
    state: ReSwiftPersist.initState(initial: initial),
    middleware: [LoggerMiddleware, ReSwiftPersist.middleware])


