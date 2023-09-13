//
//  EventView.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct EventView: View {
    //View Properties
    @State private var currentDay: Date = .init()
    @State private var tasks: [Event] = sampleEvents
    @State private var addNewTask: Bool = false
    
    @State private var showDelete: Bool = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            TimeLineView()
                .padding(15)
        }
        .onAppear{
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        .safeAreaInset(edge: .top, spacing: 0){
            HeaderView()
        }
        .fullScreenCover(isPresented: $addNewTask) {
            AddEventView{ task in
                //Simply Add To Task
                tasks.append(task)
            }
        }
    }
    
    //TimeLine View
    @ViewBuilder
    func TimeLineView()-> some View{
        ScrollViewReader { proxy in
            let hours = Calendar.current.hours
            let midHour = hours[hours.count / 2]
            VStack{
                ForEach(hours, id: \.self){hour in
                    TimeLineViewRow(hour)
                        .id(hour)
                }
            }
            .onAppear{
                //ScrollViewReader to set timeline to 12 PM Midday instead of 12 AM
                proxy.scrollTo(midHour)
            }
        }
    }
    
    //TimeLine View Row
    @ViewBuilder
    func TimeLineViewRow(_ date: Date)-> some View{
        HStack(alignment: .top){
            Text(date.toString("h a"))
                .font(.system(size: 14))
                .fontWeight(.regular)
                .frame(width: 45, alignment: .leading)
            
            //Filtering Tasks
            let calendar = Calendar.current
            let filteredTask = tasks.filter{
                if let hour = calendar.dateComponents([.hour], from: date).hour,
                   let taskHour = calendar.dateComponents([.hour], from: $0.dateAdded).hour,
                   hour == taskHour && calendar.isDate($0.dateAdded, inSameDayAs: currentDay){
                    
                    return true
                }
                return false
            }
            
            if filteredTask.isEmpty{
                Rectangle()
                    .stroke(.gray.opacity(0.5), style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel, dash: [5], dashPhase: 5))
                    .frame(height: 0.5)
                    .offset(y:10)
            }else{
                //Task View
                VStack(spacing: 10){
                    ForEach(filteredTask) { task in
                        TaskRow(task)
                    }
                }
            }
            }
        .hAlign(.leading)
        .padding(.vertical, 15)
        }

    // Task Row
    @ViewBuilder
    func TaskRow(_ task: Event)-> some View{
        VStack(alignment: .leading, spacing: 8) {
            Text(task.taskName.uppercased())
                .font(.system(size: 16))
                .fontWeight(.regular)
                .foregroundColor(task.taskCategory.color)
            
                if task.taskDescription != ""{
                    Text(task.taskDescription)
                        .font(.system(size: 14))
                        .fontWeight(.regular)
                        .foregroundColor(task.taskCategory.color.opacity(0.8))
                }
        }
        .hAlign(.leading)
        .padding(12)
        .background{
            ZStack(alignment: .leading){
                Rectangle()
                    .fill(task.taskCategory.color)
                    .frame(width: 4)
                
                Rectangle()
                    .fill(task.taskCategory.color.opacity(0.25))
            }
        }
        .onTapGesture {
            showDelete.toggle()
        }
        if showDelete{
            Button{
                
            }label: {
                Image(systemName: "trash")
                    .font(.caption2)
                    .foregroundColor(Color("Vermilion"))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    //Header View
    @ViewBuilder
    func HeaderView()-> some View{
        VStack{
            HStack{
                VStack(alignment: .leading, spacing: 6){
                    Text("Today")
                        .font(.system(size: 30))
                        .fontWeight(.light)
                    
                    
                    Text("Schedule Your Day")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                }
                .hAlign(.leading)
                
                Button{
                    addNewTask.toggle()
                }label: {
                    HStack(spacing: 10){
                    Image(systemName: "plus")
                        
                        Text("Add Task")
                            .font(.system(size: 15))
                            .fontWeight(.regular)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background{
                        Capsule()
                            .fill(Color("Cobalt").gradient)
                    }
                    .foregroundColor(Color.white)
                }
            }
            
            //Today Date in String
            Text(Date().toString("MMM YYYY"))
                .font(.system(size: 16))
                .fontWeight(.medium)
                .hAlign(.leading)
                .padding(.top, 15)
            
            //Current Week Row
            WeekRow()
        }
        .padding(15)
        .background{
            VStack(spacing: 0){
                Color.white
                
                //Gradient Opacity Background
                Rectangle()
                    .fill(.linearGradient(colors:[.white, .clear], startPoint: .top, endPoint: .bottom))
                    .frame(height: 20)
            }
            .ignoresSafeArea()
        }
    }
    
    //Week Row
    @ViewBuilder
    func WeekRow()-> some View{
        HStack(spacing: 0){
            ForEach(Calendar.current.currentWeek){weekDay in
                let status = Calendar.current.isDate(weekDay.date, inSameDayAs: currentDay)
                VStack(spacing: 6){
                    Text(weekDay.string.prefix(3))
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                    
                    Text(weekDay.date.toString("dd"))
                        .font(.system(size: 16))
                        .fontWeight(status ? .medium : .regular)
                }
                .foregroundColor(status ? Color("Cobalt"): Color.gray)
                .hAlign(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.3 )){
                        currentDay = weekDay.date
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, -15)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}



//Date Extensions
extension Date{
    func toString(_ format: String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

//Calendar Extension
extension Calendar{
    //Returns 24 Hours in A Day
    var hours: [Date]{
        let startOfDay = self.startOfDay(for: Date())
        var hours: [Date] = []
        for index in 0..<24{
            if let date = self.date(byAdding: .hour, value: index, to: startOfDay){
                hours.append(date)
            }
        }
        return hours
    }
    
    //Returns Current Week In Array Format
    var currentWeek : [WeekDay]{
        guard let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: Date())?.start
        else {return[]}
        
        var week: [WeekDay] = []
        for index in 0..<7{
            if let day = self.date(byAdding: .day, value: index, to: firstWeekDay){
                let weekDaySymbol: String = day.toString("EEEE")
                let isToday = self.isDateInToday(day)
                week.append(.init(isToday: isToday, string: weekDaySymbol, date: day))
            }
        }
        return week
    }
    
    // Store Date Of Each WeekDay
    struct WeekDay: Identifiable{
        var id: UUID = .init()
        var isToday: Bool = false
        var string: String
        var date: Date
    }
}
