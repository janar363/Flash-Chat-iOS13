import UIKit
import AVKit

class CamViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    private let photoOutput = AVCapturePhotoOutput()
    private var imgData: Data?
    var captureButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back", style: .plain, target: nil, action: nil)
        
        
        captureButton = UIButton(frame: CGRect(x: Int(super.view.frame.width) / 2 - 50, y: Int(super.view.frame.height) - 100, width: 100, height: 100))
        captureButton.setTitle("Click", for: .normal)
        captureButton.layer.cornerRadius = captureButton.layer.frame.width / 2
        captureButton.backgroundColor = #colorLiteral(red: 0.2991024852, green: 0.7571563125, blue: 0.9707965255, alpha: 1)
        captureButton.addTarget(self, action: #selector(camButtonPressed), for: .touchUpInside)
        checkPermissions()
    }
    
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    self.startCaptureSession()
                }
            }
        case .restricted, .denied:
            print("Please grant permission to access camera from system preferences")
        case .authorized:
            DispatchQueue.main.async {
                self.startCaptureSession()
            }
            
        }
    }
    
    func startCaptureSession() {
        let captureSession = AVCaptureSession()
        
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
                
                if captureSession.canAddInput(deviceInput){
                    captureSession.addInput(deviceInput)
                }
            } catch {
                print("Problem setting up device input")
            }
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        let displayLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        displayLayer.videoGravity = .resizeAspectFill
        
        DispatchQueue.main.async {
            displayLayer.frame = self.view.frame
            super.view.addSubview(self.captureButton)
            
        }
        
        self.view.layer.addSublayer(displayLayer)
    
        
        
        captureSession.startRunning()
    }
    
    @objc func camButtonPressed(){
        setupCamSettings()
    }
    
    func setupCamSettings() {
        let photoSettings = AVCapturePhotoSettings()
        
        photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.availablePreviewPhotoPixelFormatTypes.first ?? "png"]
        
        print("Photo type \(photoSettings.availablePreviewPhotoPixelFormatTypes.first)")
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {return}
        print(type(of: imageData))
        
        imgData = imageData

        performSegue(withIdentifier: "previewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let target = segue.destination as? previewController
        
        target?.imageData = imgData
        
    }
}

