import Foundation

struct K {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let chatToCam = "ChatToCam"
    static let imageNib = "ImageViewCell"
    static let imageCellIdentifier = "ImageCell"
    static let chatToPreview = "chatToPreview"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
        static let bluishGray = "BrandBluishGray"
        static let darkGray = "BrandDarkGray"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let imageField = "image"
        static let dateField = "date"
        static let dataType = "type"
    }
}

