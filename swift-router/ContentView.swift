//
//  ContentView.swift
//  swift-router
//
//  Created by Lincoln on 30/1/21.
//

import SwiftUI

struct ContentView: View {
    @State var RouterView: AnyView? = nil
    @State var router: SwiftRouter? = nil
    @State var counter: Int? = 0
    @State var tapcounter: Int = 0
    public init(){
        self.RouterView = nil
    }
    var body: some View {
        VStack(){
            Text("Click Here")
            Text("TapCounter \(tapcounter)")
            Text("Counter from Router \(counter ?? 0)")
            RouterView
        }.onAppear(perform: {
            self.router = SwiftRouter(routes: [], RouterRenderedViewBinding: $RouterView, counter: $counter)
//            self.router?.PushRoute("test")
        }).onTapGesture {
            tapcounter += 1
            self.router?.PushRoute("test"+String(tapcounter))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
