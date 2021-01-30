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
    @State var tapcounter: Int = 0
    public init(){
        self.RouterView = nil
    }
    var body: some View {
        VStack(){
            Text("Tap here")
            if RouterView != nil{
                RouterView!()
            }
        }.onAppear(perform: {
            self.router = SwiftRouter(RouterView: $RouterView)
            self.router?.PushRoute("test")
        }).onTapGesture {
            tapcounter += 1
            self.router?.PushRoute("test"+String(tapcounter))
        }
    }
}

struct TestX: View {
    var body: some View{
        Text("Hello!!!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
