//
//  ContentView.swift
//  ROK-Helper
//
//  Created by Gi Pyo Kim on 8/2/20.
//  Copyright © 2020 gipgip. All rights reserved.
//

import SwiftUI

let TIMENAMES = ["1m", "5m", "10m", "15m", "30m", "60m", "3h", "8h", "15h", "24h", "3d", "7d", "30d"]

struct ContentView: View {
    
    @ObservedObject var speedupListVM: SpeedupListViewModel
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 5)
    
    init() {
        self.speedupListVM = SpeedupListViewModel()
    }
    
    var body: some View {
        Background {
            ZStack {
                
                Color("CoolGray")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(.vertical) {
                    
                    VStack(spacing: 8) {
                        Text("Speedup Calculator")
                            .bold()
                            .font(.title)
                            .foregroundColor(Color("DeepOrange"))
                            .padding(.top, 32)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                UIApplication.shared.endEditing()
                            }
                        
                        ChartButtonView(speedupListVM: self.speedupListVM)
                            .padding()
                        
                        BSpeedupView(speedupListVM: self.speedupListVM, kGuardian: self.kGuardian)
                            .cornerRadius(8)
                        TSpeedupView(speedupListVM: self.speedupListVM, kGuardian: self.kGuardian)
                            .cornerRadius(8)
                        RSpeedupView(speedupListVM: self.speedupListVM, kGuardian: self.kGuardian)
                            .cornerRadius(8)
                        HSpeedupView(speedupListVM: self.speedupListVM, kGuardian: self.kGuardian)
                            .cornerRadius(8)
                        USpeedupView(speedupListVM: self.speedupListVM, kGuardian: self.kGuardian)
                            .cornerRadius(8)
                        
                        Spacer()
                            .frame(height: 4)
                        
                        SpeedupTotalView(speedupListVM: self.speedupListVM)
                            .padding(.bottom, 16)
                    }.offset(y: self.kGuardian.slide).animation(.easeInOut(duration: 0.35))
                }.onAppear { self.kGuardian.addObserver() }
                .onDisappear { self.kGuardian.removeObserver() }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ChartButtonView: View {
    
    @ObservedObject var speedupListVM: SpeedupListViewModel
    
    @State private var showingAlert = false
    @State private var presentChart = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Button(action: {
                    self.speedupListVM.SaveAndUpdateTotals()
                    self.showingAlert = true
                }) {
                    Text("Save")
                        .frame(width: geometry.size.width/2 - 16, height: nil, alignment: .center)
                        .padding(4)
                        .foregroundColor(Color.black)
                        .background(Color.white)
                        .cornerRadius(4)
                }.alert(isPresented: self.$showingAlert) {
                    UIApplication.shared.endEditing()
                    return Alert(title: Text("All speedups saved!"), message: Text("Check out the charts!"), dismissButton: .default(Text("R\"OK\"")))
                }
                
                Button(action: {
                    self.speedupListVM.UpdateAllTotals()
                    self.presentChart = true
                }) {
                    Text("Chart")
                        .frame(width: geometry.size.width/2 - 16, height: nil, alignment: .center)
                        .padding(4)
                        .foregroundColor(Color.black)
                        .background(Color.white)
                        .cornerRadius(4)
                }.sheet(isPresented: self.$presentChart) {
                    SpeedupChartView(speedupListVM: self.speedupListVM)
                }
            }
        }
    }
}

