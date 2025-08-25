import SwiftUI

extension Font {
    static func poppinsRegular(size: CGFloat) -> Font {
        return Font.custom("Poppins-Regular", size: size)
    }
    
    static func poppinsSemibold(size: CGFloat) -> Font {
        return Font.custom("Poppins-Semibold", size: size)
    }
    // пример использования .font(.poppinsSemibold(size: 20))
}
