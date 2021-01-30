//
//  ContentView.swift
//  swift-router
//
//  Created by Lincoln on 30/1/21.
//

import SwiftUI

struct ContentView: View {
    @State var RouterView: RouterResponder? = nil
    @State var router: SwiftRouter? = nil
    @State var tapcounter: Int = 1
    public init(){
        self.RouterView = nil
    }
    var body: some View {
        VStack(){
            Text("Tap here \(tapcounter)")
            if RouterView != nil{
                RouterView!()
            }
        }.onAppear(perform: {
            self.router = SwiftRouter(routes: [
                SwiftRouterRoute(name: "page1", view: AnyView(Page1())),
                SwiftRouterRoute(name: "page2", view: AnyView(Page2())),
                SwiftRouterRoute(name: "page3", view: AnyView(Page3())),
                SwiftRouterRoute(name: "page4", view: AnyView(Page4())),
                SwiftRouterRoute(name: "page5", view: AnyView(Page5())),
                SwiftRouterRoute(name: "error", view: AnyView(SwiftRouterCriticalErrorView(message: "No more pages (route not found)"))),
            ], RouterView: $RouterView, defaultroute: "page1", errorroute: "error")
        }).onTapGesture {
            tapcounter += 1
            self.router?.PushRoute("page"+String(tapcounter))
        }
    }
}

// Switching between the SAME View (but with different params) is troublesome.
// This is probably due to the optimization from Apple's side - which doesn't fully rerender.
struct Page1: View {
    var body: some View{
        Text("Page 1")
    }
}
struct Page2: View {
    var body: some View{
        Text("Page 2")
    }
}
struct Page3: View {
    var body: some View{
        Text("Page 3")
    }
}
struct Page4: View {
    var body: some View{
        Text("Page 4")
    }
}
struct Page5: View {
    var body: some View{
        Text("Page 5")
    }
}
// END

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
