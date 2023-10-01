//
//  PlannerView.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import SnapKit
import FSCalendar

final class PlannerView: UIView {
    lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        return calendar
    }()
    
    init() {
        super.init(frame: .zero)
        setLayout()
        configureCalendar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PlannerView {
    func configureCalendar() {
        let fontName = "NotoSansKR-Regular"
        calendarView.scope = .month
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.headerDateFormat = "YYYY년 MM월"
        // 헤더 폰트 설정
        calendarView.appearance.headerTitleFont = UIFont(name: fontName, size: 16)
        // Weekday 폰트 설정
        calendarView.appearance.weekdayFont = UIFont(name: fontName, size: 14)
        // 각각의 일(날짜) 폰트 설정 (ex. 1 2 3 4 5 6 ...)
        calendarView.appearance.titleFont = UIFont(name: fontName, size: 14)
        // 헤더의 폰트 색상 설정
        calendarView.appearance.headerTitleColor = .systemOrange
        // 헤더의 폰트 정렬 설정
        // .center & .left & .justified & .natural & .right
        calendarView.appearance.headerTitleAlignment = .center
        // 헤더 높이 설정
        calendarView.headerHeight = 45
        
        // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.5  // 0.0 = 안보이게 설정
        
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
    
    func setLayout() {
        self.addSubview(calendarView)
        
        calendarView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
