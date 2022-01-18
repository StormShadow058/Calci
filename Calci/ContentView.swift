//
//  ContentView.swift
//  Calci
//
//  Created by Vansh Maheshwari on 16/01/22.
//

import SwiftUI

struct ContentView: View {
    
    var arrayOfButtons = [ ["AC", "C", "%", "/"], ["7", "8", "9", "x"], ["4", "5", "6", "-"], ["1", "2", "3", "+"], ["Back", "0", ".", "="] ]
    
    var ops = ["+","x", "/", "%", "="]
    
    @State var result = ""
    @State var operation = ""
    @State var alerting = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Calci")
                    .font(.system(size: 60, weight: .heavy))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Spacer()
                Text(operation)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color.white)
                    .padding()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Spacer()
                Text(result)
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(Color.white)
                    .padding()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            ForEach(arrayOfButtons, id: \.self) {
                
                row in
                HStack {
                ForEach(row, id: \.self) {
                    cell in
                    Button(action: { pressButton(cell)}, label: {
                        Text(cell)
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(colorOfButton(cell))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .cornerRadius(35)
                        })
                    }
                }
            }
        }.background(Color.black)
            .alert(isPresented: $alerting) {
                Alert(title: Text("Please Enter Valid Input"), message: Text(operation), dismissButton: .default(Text("Cool")))
            }
    }
    
    func pressButton(_ a: String) {
        
        switch (a) {
        case "AC":
            result = ""
            operation = ""
            
        case "C":
            result = ""
            
        case "%", "/", "x", "+":
            operatorUsed(a)
            
        case "-":
            minus()
        
        case "Back":
            operation = String(operation.dropLast())
            
        case "=":
            result = calcRes()
        
        default:
            operation += a
        }
        
    }
    
    func operatorUsed(_ str: String) {
        if(!operation.isEmpty) {
            let end = String(operation.last!)
            
            if(end == "-" || ops.contains(end)) {
                operation.removeLast()
            }
            
            operation += str
        }
    }
    
    func minus() {
        if(operation.isEmpty || operation.last! != "-") {
            operation = operation + "-"
        }
    }
    
    func calcRes() -> String {
        if(validInput()) {
            var work = operation.replacingOccurrences(of: "%", with: "*0.01")
            work = operation.replacingOccurrences(of: "x", with: "*")
            
            let final = NSExpression(format: work)
            let answer = final.expressionValue(with: nil, context: nil) as! Double
            
            return format(answer)
        }
        
        alerting = true
        
        return ""
    }
    
    func validInput() -> Bool {
        
        if(operation.isEmpty) {
            return false
        }
        
        let end = String(operation.last!)
        
        if(end == "-" || ops.contains(end)) {
            if(end != "%" || operation.count == 1) {
                return false
            }
        }
        
        return true
    }
    
    func format(_ a: Double) -> String {
        if(a.truncatingRemainder(dividingBy: 1) == 0) {
            return String(format: "%.0f", a)
        }
        
        else {
            return String(format: "%.2f", a)
        }
        
    }
    
    
    
    func colorOfButton(_ b: String) -> Color {
        
        if(b == "AC" || b == "C" || b == "Back") {
            return .red
        }
        
        else if(b == "-" || ops.contains(b)) {
            return .blue
        }
        
        else {
            return .white
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
