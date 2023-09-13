//
//  AddEventView.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct AddEventView: View {
    //CallBack
    var onAdd: (Event)->()
    
    @State private var scheduleNotification = false
    
    //View Properties
    @Environment(\.dismiss) private var dismiss
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskTime: Date = .init()
    @State private var taskCategory: Category = .Study
    @State private var selectedHour: Int = Calendar.current.component(.hour, from: Date())
    @State private var selectedMinute: Int = Calendar.current.component(.minute, from: Date())
    
    @State private var checkmark: Bool = false
    //Category Animation Properties
    @State private var animateColor: Color = Category.Study.color
    @State private var animate: Bool = false
    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    dismiss()
                }label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.white)
                        .contentShape(Rectangle())
                }
                Text("Create New Task")
                    .font(.system(size: 28))
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 15)
                
                TitleView("NAME")
                
                TextField("Title", text: $taskName)
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .tint(Color.white)
                    .padding(.top, 2)
                
                Rectangle()
                    .fill(Color.white.opacity(0.7))
                    .frame(height: 1)
                
                TitleView("DATE")
                    .padding(.top, 15)
                
                HStack(alignment: .bottom, spacing: 12){
                    HStack(spacing: 12){
                        Text(taskDate.toString("EEEE dd, MMMM"))
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                        
                        //Custom Date Picker
                        Image(systemName: "calendar")
                            .font(.title3)
                            .foregroundColor(Color.white)
                            .overlay{
                                DatePicker("", selection: $taskDate, displayedComponents: [.date])
                                    .blendMode(.destinationOver)
                            }
                    }
                    .offset(y: -5)
                    .overlay(alignment: .bottom){
                        Rectangle()
                            .fill(Color.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                    
                    HStack(spacing: 12){
                        Text(taskDate.toString("hh:mm a"))
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                        
                        //Custom Time Picker
                        Image(systemName: "clock")
                            .font(.title3)
                            .foregroundColor(Color.white)
                            .overlay{
                                DatePicker("", selection: $taskDate, displayedComponents: [.hourAndMinute])
                                    .blendMode(.destinationOver)
                            }
                    }
                    .offset(y: -5)
                    .overlay(alignment: .bottom){
                        Rectangle()
                            .fill(Color.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                    
                    HStack(spacing: 5){
                        //Custom Reminder
                        Button{
                            
                        }label: {
                            Image(systemName: "alarm.waves.left.and.right.fill")
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .overlay{
                                    DatePicker("Reminder", selection: Binding(get: {
                                        let calendar = Calendar.current
                                        return calendar.date(bySettingHour: selectedHour, minute: selectedMinute, second: 0, of: Date()) ?? Date()
                                    }, set: { date in
                                        let calendar = Calendar.current
                                        let components = calendar.dateComponents([.hour, .minute], from: date)
                                        selectedHour = components.hour ?? 0
                                        selectedMinute = components.minute ?? 0
                                    }), displayedComponents: .hourAndMinute)
                                        .blendMode(.destinationOver)
                                }
                        }
                        Button(action: {
                            checkmark.toggle()
                            Notification()
                        }){
                            Image(systemName: checkmark ? "checkmark.square.fill" : "square")
                                .foregroundColor(checkmark ? Color.green : Color.white.opacity(0.5))
                                //.font(.title3)
                        }
                        
                       
                    }
                    .offset(y: -5)
                    //.padding(.leading, 25)
                }
                //.padding(.bottom, 15)
            }
            .onAppear{
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            .environment(\.colorScheme, .dark)
            .hAlign(.leading)
            .padding(15)
            .background {
                ZStack{
                    taskCategory.color
                    
                    GeometryReader{
                        let size = $0.size
                        Rectangle()
                            .fill(animateColor)
                            .mask{
                                Circle()
                            }
                            .frame(width: animate ? size.width * 2 : 0, height: animate ? size.height * 2 : 0)
                            .offset(animate ? CGSize(width: -size.width / 2, height: -size.height / 2) : size)
                    }
                    .clipped()
                }
                    .ignoresSafeArea()
            }
            VStack(alignment: .leading, spacing: 10){
                TitleView("DESCRIPTION", Color.gray)
                
                TextField("About Your Task", text: $taskDescription)
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .padding(.top, 2)
                
                Rectangle()
                    .fill(.black.opacity(0.2))
                    .frame(height: 1)
                
                TitleView("CATEGORY", Color.gray)
                    .padding(.top, 15)
                
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 20), count: 3), spacing: 5){
                    ForEach(Category.allCases, id: \.rawValue){category in
                        Text(category.rawValue.uppercased())
                            .font(.system(size: 12))
                            .fontWeight(.regular)
                            .hAlign(.center)
                            .padding(.vertical, 5)
                            .background{
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(category.color.opacity(0.25))
                            }
                            .foregroundColor(category.color)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                guard !animate else{return}//Avoid Simultaneous taps
                                animateColor = category.color
                                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 1, blendDuration: 1)){
                                    animate = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
                                    animate = false
                                    taskCategory = category
                                }
                            }
                    }
                }
                .padding(.top, 5)
                
                Button {
                    //Creating Task And Passing IT To Callback
                    let task = Event(dateAdded: taskDate, taskName: taskName, taskDescription: taskDescription, taskCategory: taskCategory)
                    onAdd(task)
                    dismiss()
                }label: {
                    Text("Create Task")
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 15)
                        .hAlign(.center)
                        .background{
                            Capsule()
                                .fill(animateColor.gradient)
                        }
                }
                .vAlign(.bottom)
                .disabled(taskName == "" || animate)
                .opacity(taskName == "" ? 0.6 : 1)
            }
            .padding(15)
        }
        .vAlign(.top)
    }
    
    @ViewBuilder
    func TitleView(_ value: String,_ color: Color = Color.white.opacity(0.7))-> some View{
        Text(value)
            .font(.system(size: 12))
            .fontWeight(.regular)
            .foregroundColor(color)
    }
    func Notification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            success, error in
            if success {
                print("All Set!")
            }else if let error = error {
                print(error.localizedDescription)
            }
        }
        //Creating Content of Notification
        let content = UNMutableNotificationContent()
        content.title = "\(taskCategory) Reminder: \(taskName)"
        content.subtitle = "\(taskDescription)"
        content.sound = UNNotificationSound.default
        content.badge = 1
        //Creating a Trigger
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        var dateComponents = DateComponents()
        dateComponents.hour = selectedHour
        dateComponents.minute = selectedMinute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //Creating a Request
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }

}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView{task in
            
        }
    }
}

