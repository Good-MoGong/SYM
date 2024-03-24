//
//  DatePicker.swift
//  SYM
//
//  Created by 전민돌 on 2/19/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI
import UIKit
import DesignSystem

struct DatePicker: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    
//    @Binding var selectedYear: Int
//    @Binding var selectedMonth: Int
//    @Binding var currentMonth: Int
    @Binding var isShowingDateChangeSheet: Bool
//    @Binding var currentDate: Date
    
    var body: some View {
        VStack {
            CustomDatePicker(selectedYear: $calendarViewModel.selectedYear, selectedMonth: $calendarViewModel.selectedMonth)

            Button {
                let selectedDate = createNewDate(year: calendarViewModel.selectedYear, month: calendarViewModel.selectedMonth)
                let difference = Calendar.current.dateComponents([.month], from: Calendar.current.startOfDay(for: Date()), to: selectedDate).month ?? 0
                
                calendarViewModel.currentMonth = difference
                calendarViewModel.currentDate = selectedDate
                isShowingDateChangeSheet.toggle()
            } label: {
                Text("완료")
            }
            .buttonStyle(MainButtonStyle(isButtonEnabled: true))
            .padding(20)
        }
    }
    
    private func createNewDate(year: Int, month: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        guard let selectDate = Calendar.current.date(from: components) else {
            fatalError("Failed to create a new date.")
        }
        return selectDate
    }
}

struct CustomDatePicker: UIViewRepresentable { // UIKit의 UIView를 SwiftUI에서 사용하기 위한 Protocol
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int
    
    func makeUIView(context: UIViewRepresentableContext<CustomDatePicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        
        picker.selectRow(selectedYear - 1, inComponent: 0, animated: false)
        picker.selectRow(selectedMonth - 1, inComponent: 1, animated: false)
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: UIViewRepresentableContext<CustomDatePicker>) {
    }
    
    func makeCoordinator() -> CustomDatePicker.Coordinator {
        return CustomDatePicker.Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        let formatterYear = DateFormatter()
        let formatterMonth = DateFormatter()
        var availableYear: [Int] {
            get {
                var years: [Int] = []
                for i in 2024...Int(todayYear)! {
                    years.append(i)
                }
                return years
            }
        }
        let allMonth: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        var selectedYear: Int = Calendar.current.component(.year, from: .now)
        var selectedMonth: Int = Calendar.current.component(.month, from: .now)
        var todayYear: String {
            get {
                formatterYear.dateFormat = "yyyy"
                return formatterYear.string(from: Date())
            }
        }
        var todayMonth: String {
            get {
                formatterMonth.dateFormat = "MM"
                return formatterMonth.string(from: Date())
            }
        }
        
        var parent: CustomDatePicker
        init(_ pickerView: CustomDatePicker) {
            self.parent = pickerView
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0:
                return availableYear.count
            case 1:
                return allMonth.count
            default:
                return 0
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            case 0:
                return "\(availableYear[row])년"
            case 1:
                return "\(allMonth[row])월"
            default:
                return ""
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0:
                parent.selectedYear = availableYear[row]
            case 1:
                parent.selectedMonth = allMonth[row]
            default:
                break
            }
            
            if (Int(todayYear)! <= parent.selectedYear && Int(todayMonth)! < parent.selectedMonth) {
                pickerView.selectRow(Int(todayMonth)!-1, inComponent: 1, animated: true)
                parent.selectedMonth = Int(todayMonth)!
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return .symWidth/3.5
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 40
        }
    }
}


#Preview {
    DatePicker(calendarViewModel: CalendarViewModel(calendarUseCase: CalendarUseCase(calendarRepository: CalendarRepository())), isShowingDateChangeSheet: .constant(false))
}
