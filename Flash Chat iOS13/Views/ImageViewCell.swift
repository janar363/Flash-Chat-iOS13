
import UIKit

class ImageViewCell: UITableViewCell {
    @IBOutlet weak var imageMsg: UIImageView!
    
    @IBOutlet weak var imageBubble: UIView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageBubble.layer.cornerRadius = imageBubble.layer.frame.height / 5
        imageMsg.layer.cornerRadius = imageBubble.layer.frame.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
