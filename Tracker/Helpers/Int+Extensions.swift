import Foundation
extension Int {
     func days() -> String {
         var dayString: String!
         if "1".contains("\(self % 10)")      {dayString = NSLocalizedString("oneDay", comment: "")}
         if "234".contains("\(self % 10)")    {dayString = NSLocalizedString("twoDays", comment: "")}
         if "567890".contains("\(self % 10)") {dayString = NSLocalizedString("fiveDays", comment: "")}
         if 11...14 ~= self % 100             {dayString = NSLocalizedString("elevenDays", comment: "")}
    return "\(self) " + dayString
    }
}
