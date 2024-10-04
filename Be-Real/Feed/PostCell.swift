import UIKit
import Alamofire
import AlamofireImage
import MapKit

class PostCell: UITableViewCell {

    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var blurView: UIVisualEffectView!

    private var imageDataRequest: DataRequest?

    func configure(with post: Post, location: CLLocation?) {
        usernameLabel.text = post.user?.username

        if let imageFile = post.imageFile, let imageUrl = imageFile.url {
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    self?.postImageView.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                }
            }
        }

        captionLabel.text = post.caption

        var dateString = ""
        if let date = post.createdAt {
            dateString = DateFormatter.postFormatter.string(from: date)
        }

        if let latitude = post.latitude, let longitude = post.longitude {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
                if let error = error {
                    print("Failed to fetch city name: \(error.localizedDescription)")
                    self?.dateLabel.text = dateString
                    return
                }

                if let placemark = placemarks?.first, let city = placemark.locality {
                    self?.dateLabel.text = "\(dateString) - from \(city)"
                } else {
                    self?.dateLabel.text = dateString
                }
            }
        } else if let currentLocation = location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(currentLocation) { [weak self] placemarks, error in
                if let error = error {
                    print("Failed to fetch current city name: \(error.localizedDescription)")
                    self?.dateLabel.text = dateString
                    return
                }

                if let placemark = placemarks?.first, let city = placemark.locality {
                    self?.dateLabel.text = "\(dateString) - from \(city)"
                } else {
                    self?.dateLabel.text = dateString
                }
            }
        } else {
            dateLabel.text = dateString
        }

        if let currentUser = User.current,
           let lastPostedDate = currentUser.lastPostedDate,
           let postCreatedDate = post.createdAt,
           let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: lastPostedDate).hour {

            blurView.isHidden = abs(diffHours) < 24
        } else {
            blurView.isHidden = false
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        imageDataRequest?.cancel()
    }
}
