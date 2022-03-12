//
//  Math functions.swift
//  Bionomial DIstribution
//
//  Created by Jessie Zhang on 2022-03-11.
//

import Foundation

func comb(_ num1: Int, _ num2:Int)->Int{
    func nona(_ num: Int)->Decimal{
        var result:Decimal=1
        if num<0{
            return -1
        }
        else if num==0{
            return 1
        }
        else{
            for i in stride(from:num,to:1,by:-1){
                result=Decimal(i)*result
            }
            return result
        }
    }
    return NSDecimalNumber(decimal:nona(num1)/nona(num2)/nona(num1-num2)).intValue
}
func pow(_ num1:Double, _ num2:Int)->Double{
    var result:Double=1
    if num2==0{
        return result
    }
    for _ in 1...num2{
        result=result*num1
    }
    return result
}
func bion(n:Int, i:Int, p:Double)->Double{
    return Double(comb(n,i))*pow(p,i)*pow(1.0-p,n-i)
}

func number(_ inputString:String)->(Bool,Bool,Bool/*Is number, is positive, is integer*/){
    let characters=Array(inputString)
    let numberArray=["0","1","2","3","4","5",
                     "6","7","8","9","-","."]
    var bContainMinusSign=false
    var bContainDot=false
    if characters.isEmpty{
    //print("Empty")
    return (false,false,false)
    }
    if inputString=="."||inputString=="-"||inputString=="-."{
        return (false,false,false)
    }
    for c in characters{
        var bIsInNumberArray=false
        for c2 in numberArray{
            if c2==String(c){
                bIsInNumberArray=true
            }
        }
        if !bIsInNumberArray{
            //print("Contain text")
            return (false,false,false)
        }
        if String(c)=="-"{
            if bContainMinusSign==true{
                //print("Contain multiple minus signs")
                return (false,false,false)
            }
            bContainMinusSign=true
        }
        if String(c)=="."{
            if bContainDot==true{
                //print("Contain multiple dots")
                return (false,false,false)
            }
            bContainDot=true
        }
    }
    if bContainMinusSign&&String(characters[0]) != "-"{
        //print("\"-\" in the wrong place")
        return (false,false,false)
    }
    return (true,!bContainMinusSign,!bContainDot)
}


