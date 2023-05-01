import Foundation

extension Date {
    func withoutTime() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        guard let date = Calendar.current.date(from: components) else { return Date() }
        return date
    }
}
