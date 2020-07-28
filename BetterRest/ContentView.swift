//
//  ContentView.swift
//  BetterRest
//
//  Created by Chloe Fermanis on 9/7/20.
//  Copyright © 2020 Chloe Fermanis. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount: Double = 8.0
    @State private var coffeeAmount: Double = 1
    
    @State private var alertMessage = ""
    @State private var showingAlert = false
        
    var body: some View {
                    
            ZStack {
            
                LinearGradient(gradient: Gradient(colors: [.white, .yellow, .orange]), startPoint: .top, endPoint: .bottom)
                
                VStack(spacing: 15) {
                    
                    HStack {
                    Text("B E T T E R")
                    Image(systemName: "zzz")
                        .foregroundColor(.orange)

                    Text("R E S T")
                    }
                    .font(Font.custom("Futura", size: 30) )
                    
                    Text("WAKE UP: \(wakeUp, formatter: timeFormatter)")
                        .font(Font.custom("Futura", size: 15) )

                    DatePicker("Enter Date:", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .overlay(RoundedRectangle(cornerRadius: 15.0)
                        .stroke(lineWidth: 2.0)
                        .foregroundColor(Color.black)                        .padding(.leading,20)
                        .padding(.trailing,20))
                    
                    HStack {
                        Text("SLEEP:")
                        Text("\(sleepAmount, specifier: "%g") HOURS")
                            .font(Font.custom("Futura", size: 15) )

                    }
                    .font(Font.custom("Futura", size: 15))

                    HStack {
                       Image(systemName: "bed.double")
                        .font(Font.custom("Futura", size: 20) )

                           // .font(.system(size: 20))
                            .padding(.leading, 10)
                        Slider(value: $sleepAmount, in: 4...12, step: 0.25)
                            .accentColor(Color.black)
                            .padding(.top, 8)
                            .padding(.bottom,8)
                        
                        Image(systemName: "zzz")
                            .font(.system(size: 20))
                            .padding(.trailing, 10)

                    }
                    .overlay(RoundedRectangle(cornerRadius: 15.0)
                    .stroke(lineWidth: 2.0)
                    .foregroundColor(Color.black))
                    .padding(.leading,20)
                    .padding(.trailing,20)
                    
                    HStack {
                    Text("COFFEE:")
                    Text(coffeeAmount == 1 ? "\(coffeeAmount, specifier: "%.g") CUP" : "\(coffeeAmount, specifier: "%.g") CUPS")
                    }
                    .font(Font.custom("Futura", size: 15) )

                    
                    HStack {
                        Slider(value: $coffeeAmount, in: 0...10, step: 1)
                            .accentColor(Color.black)
                            .padding(.top, 8)
                            .padding(.bottom,8)
                            .padding(.leading,10)
                        
                        Image(systemName: "\(Int(coffeeAmount)).circle")
                            .font(.system(size: 30))
                            .padding(.trailing,10)
                    }
                    .overlay(RoundedRectangle(cornerRadius: 15.0)
                    .stroke(lineWidth: 2.0)
                    .foregroundColor(Color.black))
                    .padding(.leading,20)
                    .padding(.trailing,20)

                    
                    Text("GO TO BED AT \(calculateBedtime())")
                        .font(Font.custom("Futura", size: 15) )
                }

        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }

    
    func calculateBedtime() -> String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try
                model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
            
        } catch {
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            return alertMessage
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
