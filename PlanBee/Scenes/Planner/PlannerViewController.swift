//
//  PlannerViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import SnapKit
import FSCalendar

final class PlannerViewController: UIViewController {
    
    var selectDate = Date()
    let viewModel = TodoManager()
    
    private lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCalendar()
        configureCalendarLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presentEvents()
    }
}

private extension PlannerViewController {
    func configureView() {
        // 추후 추가
    }
    
    func configureCalendar() {
        calendarView.scope = .month
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.headerDateFormat = "YYYY년 MM월"
        // 헤더 폰트 설정
        calendarView.appearance.headerTitleFont = UIFont(name: "NotoSansKR-Medium", size: 16)
        // Weekday 폰트 설정
        calendarView.appearance.weekdayFont = UIFont(name: "NotoSansKR-Regular", size: 14)
        // 각각의 일(날짜) 폰트 설정 (ex. 1 2 3 4 5 6 ...)
        calendarView.appearance.titleFont = UIFont(name: "NotoSansKR-Regular", size: 14)
        // 헤더의 폰트 색상 설정
        calendarView.appearance.headerTitleColor = .systemOrange
        // 헤더의 폰트 정렬 설정
        // .center & .left & .justified & .natural & .right
        calendarView.appearance.headerTitleAlignment = .center
        // 헤더 높이 설정
        calendarView.headerHeight = 45
        
        // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.5 // 0.0 = 안보이게 설정
        
        // 이벤트 색상 표시
        calendarView.appearance.eventDefaultColor = .systemGreen
        calendarView.appearance.eventSelectionColor = .systemGreen
        
        // 평일 & 주말 색상 설정
        calendarView.appearance.titleDefaultColor = .label  // 평일
//        calendarView.appearance.titleWeekendColor = .link    // 주말
        calendarView.calendarWeekdayView.weekdayLabels.first!.textColor = .systemRed
        calendarView.calendarWeekdayView.weekdayLabels.last!.textColor = .systemBlue
        
//        // 다중 선택
//        calendarView.allowsMultipleSelection = true
//        // 꾹 눌러서 드래그 동작으로 다중 선택
//        calendarView.swipeToChooseGesture.isEnabled = true
    }
    
    func configureCalendarLayout() {
        view.addSubview(calendarView)
        
        calendarView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

private extension PlannerViewController {
    func presentEvents() {
        calendarView.reloadData()
    }
}

extension PlannerViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar,
                  numberOfEventsFor date: Date
    ) -> Int {
        if viewModel.getDateList().contains(date) {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar,
                  shouldSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition
    ) -> Bool {
        // 날짜 3개까지만 선택
        if calendar.selectedDates.count > 2 {
            return false
        } else {
            return true
        }
    }
    
    func calendar(_ calendar: FSCalendar,
                  didSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition
    ) {
        if selectDate == date {
            let plannerDetailVC = PlannerDetailViewController()
            plannerDetailVC.date = date
            plannerDetailVC.reloadCalendar = { [weak self] _ in
                guard let self = self else { return }
                presentEvents()
            }
            present(plannerDetailVC, animated: true)
        }
        selectDate = date
    }
    
//    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        print("해제")
//    }
    
//    // 토요일 파랑, 일요일 빨강으로 만들기
//    func calendar(_ calendar: FSCalendar,
//                  appearance: FSCalendarAppearance,
//                  titleDefaultColorFor date: Date
//    ) -> UIColor? {
//        let day = Calendar.current.component(.weekday, from: date) - 1
//
//        if Calendar.current.shortWeekdaySymbols[day] == "일" {
//            return .systemRed
//        } else if Calendar.current.shortWeekdaySymbols[day] == "토" {
//            return .link
//        } else {
//            return .label
//        }
//    }
}
