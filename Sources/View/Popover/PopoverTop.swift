//
//  PopoverTop.swift
//
//  Created by NullSilck on 2025/3/15.
//

import SwiftUI

struct PopoverTop: View {

    @EnvironmentObject var appTimer: AppTimer
    @EnvironmentObject var appSetter: AppSetter

    @State private var buttonHovered = false
    @State private var isExpanded = false

    private var startFocusLabel = NSLocalizedString(
        "Popover.start.focus.label", comment: "开始专注")
    private var startTickLabel = NSLocalizedString(
        "Popover.start.tick.label", comment: "计时")
    private var stopLabel = NSLocalizedString(
        "Popover.stop.label", comment: "停止")

    var body: some View {
        VStack {
            VStack {
                // 状态指示器
                statusText
                    .foregroundColor(Color(appSetter.colorSet))
                let idleLabel =
                    appTimer.workIntervalLength
                    + appTimer.shortRestIntervalLength
                    + appTimer.longRestIntervalLength
                let workLabel = appTimer.consecutiveWorkIntervals + 1
                if idleLabel != 0 && appTimer.currentState == .idle
                    || workLabel != 0 && appTimer.currentState == .work
                {
                    Text(
                        String.localizedStringWithFormat(
                            appTimer.currentState == .work
                                ? NSLocalizedString(
                                    "Total.WorkIntervals", comment: "共记工作数")
                                : NSLocalizedString(
                                    "Total.Time", comment: "共记时间"),
                            appTimer.currentState == .work
                                ? workLabel : idleLabel)
                    )
                    .fontWeight(.thin).font(.caption2)
                    .foregroundColor(Color.gray.opacity(0.8))
                    .transition(
                        .asymmetric(insertion: .scale, removal: .opacity))
                }
            }
            // 专注/停止按钮
            Rectangle()
                .fill(Color(appSetter.colorSet))
                .clipShape(Capsule())
                .shadow(
                    color: Color(appSetter.colorSet).opacity(0.8), radius: 1
                )
                .frame(height: 40)
                .overlay {
                    Button(
                        action: {
                            appTimer.startStop()
                            withAnimation {
                                isExpanded.toggle()
                            }
                        },
                        label: {
                            HStack {
                                Image(
                                    systemName: appTimer.timer != nil
                                        ? "pause.fill" : "play.fill")
                                Text(
                                    appTimer.timer != nil
                                        ? (buttonHovered
                                            ? stopLabel
                                            : appTimer.timeLeftString)
                                        : startFocusLabel
                                )
                                .font(.system(.body).monospacedDigit())
                            }
                        }
                    )
                    .buttonStyle(.borderless)
                    .foregroundColor(Color.white)
                    .onHover { over in
                        buttonHovered = over
                    }
                }

        }.accentColor(Color(appSetter.colorSet))
    }

    // 定义状态显示文本
    private var statusText: some View {
        let status: String
        if appTimer.timer == nil {
            status = NSLocalizedString("Popover.status.ready", comment: "准备就绪")
        } else {
            switch appTimer.currentState {
            case .work:
                status = NSLocalizedString(
                    "Popover.status.working", comment: "专注中 Focusing...")
            case .rest:
                if appTimer.currentState == .rest {
                    status = NSLocalizedString(
                        "Popover.status.longRest", comment: "休息中 Long Break...")
                } else {
                    status = NSLocalizedString(
                        "Popover.status.shortRest", comment: "小憩中 Short Break.."
                    )
                }
            default:
                status = NSLocalizedString(
                    "Popover.status.ready", comment: "准备就绪")
            }
        }
        return Text(status)
            .font(.system(size: 24, weight: .bold))
    }

}

#Preview {
    PopoverView()
}
