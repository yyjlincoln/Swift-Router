//
//  SwiftRouter.swift
//  swift-router
//
//  Created by Lincoln on 30/1/21.
//

import SwiftUI


struct SwiftRouterCriticalErrorView: View {
    @State var message: String
    var body: some View{
        Text("\(message)")
    }
}

struct RouteHandlers {
    var willCreate: RouterJudge?
    var willDestroy: RouterJudge?
}

struct SwiftRouterRoute {
    var name : String
    var view : AnyView
    var handlers : RouteHandlers = RouteHandlers()
}

typealias RouterResponder = () -> AnyView?
typealias RouterJudge = (SwiftRouterRoute) -> Void


class SwiftRouter{
    @Binding var RouterView: RouterResponder?
    private var routes: [SwiftRouterRoute]
    private var defaultroute: String?
    private var errorroute: String?
    private var current: SwiftRouterRoute?
    
    public init(routes: [SwiftRouterRoute], RouterView : Binding<RouterResponder?>){
        self.routes = routes
        self._RouterView = RouterView

        // Default route
        if self.defaultroute != nil {
            self.PushRoute(defaultroute!)
        }
        
    }
    func MatchRoute(_ name:String) -> SwiftRouterRoute?{
        for route in self.routes{
            if route.name==name{
                return route
            }
        }
        // Error - Could not match route
        if self.errorroute != nil && name != self.errorroute{
            return MatchRoute(self.errorroute!)
        }
        // Error - Could not even match the error route
        return nil
    }
    func PushRoute(_ name: String) {
        // When PushRoute is called, it changes the binded RouteView(),
        // which will result in an UI Update and call RouterView().
        // RouterView() will then match the route, and return the corresponding AnyView()
        // or Nil, as well as invoking the handlers.
        
        RouterView = {()->AnyView? in
            if let destinationRoute = self.MatchRoute(name) {
                // Route matched, check handlers
                if self.current != nil {
                    // Invoke willDestroy for previous route
                    if self.current!.handlers.willDestroy != nil {
                        self.current!.handlers.willDestroy!(self.current!)
                    }
                }
                // Invoke willCreate for previous route
                if destinationRoute.handlers.willCreate != nil {
                    destinationRoute.handlers.willCreate!(destinationRoute)
                }
                //
                self.current = destinationRoute
                return destinationRoute.view
            }
            return self.current?.view
        }
    }

}
