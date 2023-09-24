//
//  PlannerViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import SnapKit
import FSCalendar
import SwiftUI

final class PlannerViewController: UIViewController {
    
    private let plannerView = PlannerView()
    private let viewModel = PlannerViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = plannerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentEvents()
        
        
        let result = KeychainManager.getKeychainStringValue(forKey: .token)
        print("=====> result: \(String(describing: result))")
    }
}

private extension PlannerViewController {
    func configure() {
        plannerView.calendarView.delegate = self
        plannerView.calendarView.dataSource = self
    }
    
    func presentEvents() {
        plannerView.calendarView.reloadData()
    }
}

extension PlannerViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar,
                  numberOfEventsFor date: Date
    ) -> Int {
        return viewModel.numOfEvent(date: date)
    }
    
    func calendar(_ calendar: FSCalendar,
                  didSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition
    ) {
        if viewModel.selectDate == date {
            let plannerDetailVC = PlannerDetailViewController(date: date)
            plannerDetailVC.reloadCalendar = { [weak self] _ in
                guard let self = self else { return }
                self.presentEvents()
            }
            present(plannerDetailVC, animated: true)
        }
        viewModel.selectDate = date
    }
    
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

struct PlannerVCPreView: PreviewProvider {
    static var previews: some View {
        let plannerVC = PlannerViewController()
        UINavigationController(rootViewController: plannerVC)
            .toPreview().edgesIgnoringSafeArea(.all)
    }
}
