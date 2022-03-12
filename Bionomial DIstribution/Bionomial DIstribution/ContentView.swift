//
//  ContentView.swift
//  Bionomial DIstribution
//
//  Created by Jessie Zhang on 2022-03-11.
//

import SwiftUI

struct BionDist: Identifiable{
    let id=UUID()
    let x:String
    let r1:String
    let r2:String
    let fontWeightType:Font.Weight
}

func changeList(n:Int,p:Double)->[BionDist]{
    var newBionDist=[BionDist](repeating:BionDist(x:"x",r1:"P(x)",r2:"x*P(x)",fontWeightType: .black), count:n+2)
    for i in 0...n{
        newBionDist[i+1]=BionDist(x:String(i),r1:String(format:"%.7f",bion(n: n, i: i, p: p)),r2:String(format:"%4f",bion(n:n,i:i,p:p)*Double(i)),fontWeightType: .regular)
    }
    return newBionDist
}

func calculateWidth(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geometry.frame(in: .local).width
            }

            return .clear
        }
    }

struct ContentView: View {
    @State var inn:String=""
    @State var inp:String=""
    @State var n:Int=1
    @State var p:Double=0.5
    @State var listView=[
        BionDist(x:"x",r1:"P(x)",r2:"x*P(x)",fontWeightType: .black),
        BionDist(x:String(0),r1:String(format:"%.7f",0.5),r2:String(format:"%.7f",0), fontWeightType: .regular),
        BionDist(x:String(1),r1:String(format:"%.7f",0.5),r2:String(format:"%.7f",0.5), fontWeightType: .regular),
    ]
    @State var width:CGFloat=0
      var body: some View {
          VStack{
              VStack{
                  Text("Bionomial Distributions")
                      .font(.title)
                      .controlSize(.large)
                      .padding()
                  HStack{
                      Text("n:")
                          .padding()
                      TextField("Number of trails",text:$inn,onEditingChanged: {_ in
                          let numberState:(isNumber:Bool,isPositive:Bool,isInteger:Bool)=number(self.inn)
                          if !(numberState.isNumber && numberState.isPositive && numberState.isInteger){
                              inn=String(n)
                              return
                          }
                          let result=Scanner(string: inn).scanInt()!
                          if result<1{
                              n=1
                              inn="1"
                              return
                          }
                          n=result
                          inn=String(n)
                      })
                          .textFieldStyle(.roundedBorder)
                      Text("\tp:")
                          //.padding()
                      TextField("Propotion of success",text:$inp,onEditingChanged: {_ in
                          let numberState:(isNumber:Bool,isPositive:Bool,_:Bool)=number(self.inp)
                          if !(numberState.isNumber && numberState.isPositive){
                              inp=String(p)
                              return
                          }
                          let result=Scanner(string: inp).scanDouble()!
                          if !(result<1&&result>0){
                              p=0.5
                              inp="0.5"
                              return
                          }
                          p=result
                          inp=String(p)
                      })
                          .textFieldStyle(.roundedBorder)
                          .padding()
                      Button("Calculate") {
                          NSApp.keyWindow?.makeFirstResponder(nil)
                          listView=changeList(n:n,p:p)
                      }
                      .padding()
                  }
              }
              
              List(listView){bionDist in
                  HStack{
                      Text(bionDist.x).fontWeight(bionDist.fontWeightType).frame(alignment:.center).frame(width:width*0.33-90,height:20)
                      Text(bionDist.r1).fontWeight(bionDist.fontWeightType).frame(alignment:.center).frame(width:width*0.33+45,height:20)
                      Text(bionDist.r2).fontWeight(bionDist.fontWeightType).frame(alignment:.center).frame(width:width*0.33+45,height:20)
                  }
                  if(bionDist.x != String(n)){
                      Divider()
                  }
              }
          }
          .frame(minWidth: 615, idealWidth: 615, maxWidth: .infinity, minHeight: 275, idealHeight: 600, maxHeight: .infinity, alignment: .center)
          .background(calculateWidth($width))
      }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
