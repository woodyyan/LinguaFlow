import Foundation

/// 防抖器 —— 用于输入时延迟触发翻译，避免每次按键都触发
final class Debouncer {
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    private let delay: TimeInterval

    init(delay: TimeInterval = 0.5, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }

    func debounce(action: @escaping () -> Void) {
        workItem?.cancel()
        let item = DispatchWorkItem(block: action)
        workItem = item
        queue.asyncAfter(deadline: .now() + delay, execute: item)
    }

    func cancel() {
        workItem?.cancel()
    }
}
