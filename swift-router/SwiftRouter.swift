//
//  SwiftRouter.swift
//  swift-router
//
//  Created by Lincoln on 30/1/21.
//

import SwiftUI


struct SwiftRouterCriticalErrorView: View {
    @EnvironmentObject var router: SwiftRouter
    @EnvironmentObject var route: SwiftRouterRouteInstance
    @State var message: String
    var body: some View{
        Text("\(message)")
//        Text("Current route: \(route.name)")
//        Text("Previous route: \(router.Previous?.name ?? "<None>")")
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
    var meta: Dictionary<String, Any>? = [:]
}

class SwiftRouterRouteInstance: ObservableObject {
    public var name: String
    public var view : AnyView
    public var handlers : RouteHandlers = RouteHandlers()
    public var meta: Dictionary<String, Any>? = [:]
    public var data: Dictionary<String, Any>? = [:]
    init(name: String, view: AnyView, handlers: RouteHandlers, meta: Dictionary<String, Any>?, data: Dictionary<String, Any>?) {
        self.name=name
        self.view=view
        self.handlers=handlers
        self.meta=meta
        self.data=data
    }
}

typealias RouterResponder = () -> AnyView?
typealias RouterJudge = (SwiftRouterRouteInstance) -> Void


class SwiftRouter: ObservableObject{
    // Now the handlers
    @Binding var RouterView: RouterResponder?
    private var routes: [SwiftRouterRoute]
    private var defaultroute: String?
    private var errorroute: String?
    private var current: SwiftRouterRouteInstance?
    private var previous: SwiftRouterRouteInstance?
    public var Current: SwiftRouterRouteInstance? {
        get{
            return current
        }
    }
    public var Routes: [SwiftRouterRoute]? {
        get{
            return routes
        }
    }
    public var Previous: SwiftRouterRouteInstance? {
        get{
            return previous
        }
    }
    
    public init(routes: [SwiftRouterRoute] = [SwiftRouterRoute(name: "error", view: AnyView(SwiftRouterCriticalErrorView(message: "SwiftRouter Default Error Page: An error occured. Did you define 'routes' when init? Does the destination route exist?")))], RouterView : Binding<RouterResponder?>, defaultroute: String? = nil, errorroute: String? = "error"){
        self.routes = routes
        self._RouterView = RouterView
        self.errorroute = errorroute
        self.defaultroute = defaultroute

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
    func PushRoute(_ name: String, _ data: Dictionary<String, Any>? = [:]) {
        // When PushRoute is called, it changes the binded RouteView(),
        // which will result in an UI Update and call RouterView().
        // RouterView() will then match the route, and return the corresponding AnyView()
        // or Nil, as well as invoking the handlers.
        
        RouterView = {()->AnyView? in
            if let destinationRoute = self.MatchRoute(name) {
                let destinationInstance = SwiftRouterRouteInstance(name: destinationRoute.name, view: destinationRoute.view, handlers: destinationRoute.handlers, meta: destinationRoute.meta, data: data)
                
                // Route matched, check handlers
                if self.current != nil {
                    // Invoke willDestroy for previous route
                    if self.current!.handlers.willDestroy != nil {
                        self.current!.handlers.willDestroy!(self.current!)
                    }
                }
                // Invoke willCreate for previous route
                if destinationRoute.handlers.willCreate != nil {
                    destinationRoute.handlers.willCreate!(destinationInstance)
                }
                //
                self.previous = self.current
                self.current = destinationInstance
                
                return AnyView(destinationRoute.view.environmentObject(self).environmentObject(destinationInstance))
            }
            return self.current?.view
        }
    }

}
