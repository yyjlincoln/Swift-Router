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

struct SwiftRouterRoute {
    var name : String
    var view : AnyView
}

class SwiftRouter{
    @Binding var RouterRenderedView: AnyView?
    @Binding var counter: Int?
    private var routes: [SwiftRouterRoute]
    public init(routes: [SwiftRouterRoute], RouterRenderedViewBinding : Binding<AnyView?>, counter: Binding<Int?>){
        self.routes = routes
        self._RouterRenderedView = RouterRenderedViewBinding
        self._counter = counter
    }
    func MatchRoute(_ name:String) -> SwiftRouterRoute{
        for route in self.routes{
            if route.name==name{
                return route
            }
        }
        return SwiftRouterRoute(name: "Critical Error", view: AnyView( SwiftRouterCriticalErrorView(message: "Could not match route: \(name)")))
    }
    func PushRoute(_ name: String) {
//        let VC = UIHostingController(rootView: RouterRenderedView)
//        VC.addChild(UIHostingController(rootView: MatchRoute(name).view))
//        guard RouterRenderedView==nil else {
//            RouterRenderedView=nil
//            return
//        }
        self.counter? += 1
        RouterRenderedView = MatchRoute(name).view
        
    }

}


//struct SwiftRouter: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct SwiftRouter_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftRouter()
//    }
//}
