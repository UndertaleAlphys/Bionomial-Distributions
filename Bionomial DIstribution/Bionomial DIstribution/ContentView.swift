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
        newBionDist[i+1]=BionDist(x:String(i),r1:String(format:"%.\(7+n/10)lf",bion(n: n, i: i, p: p)),r2:String(format:"%.\(7+n/10)lf",bion(n:n,i:i,p:p)*Double(i)),fontWeightType: .regular)
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
    @State private var inn:String=""
    @State private var inp:String=""
    @State private var n:Int=1
    @State private var p:Double=0.5
    @State private var listView=[
        BionDist(x:"x",r1:"P(x)",r2:"x*P(x)",fontWeightType: .black),
        BionDist(x:String(0),r1:String(format:"%.7lf",0.5),r2:String(format:"%.7lf",0), fontWeightType: .regular),
        BionDist(x:String(1),r1:String(format:"%.7lf",0.5),r2:String(format:"%.7lf",0.5), fontWeightType: .regular),
    ]
    @State private var width:CGFloat=0
    @State private var old_n=1
      var body: some View {
          VStack{
              VStack{
                  Text("Bionomial Distributions")
                      .font(.title)
                      .padding()
                  HStack{
                      Text("n:")
                          .padding()
                      TextField("Number of trails",text:$inn,onEditingChanged: {_ in
                          let numberState:(isNumber:Bool,isPositive:Bool,isInteger:Bool)=number(self.inn)
                          if !(numberState.isNumber && numberState.isInteger){
                              inn=String(n)
                              return
                          }
                          let result=Scanner(string: inn).scanInt()!
                          if result<1{
                              n=1
                              inn="1"
                              return
                          }
                          if result>60{
                              n=60
                              inn="60"
                              return
                          }
                          n=result
                          inn=String(n)
                      })
                          .textFieldStyle(.roundedBorder)
                      Text("\tp:")
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
                          NSApp.keyWindow?.makeFirstResponder(nil) //Set focus state to update the value of n&p
                          old_n=n
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
                  let xValue=Int(bionDist.x)
                  if xValue==nil||xValue! < old_n{
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
