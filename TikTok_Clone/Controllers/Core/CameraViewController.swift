//
//  CameraViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

/*
 apple 에서 제공하는 기본 Camera Framework(AVFoundation), UIImagePickerController,,는 Customizing 시 여러 제약이 따르므로 따른 외부 Framework를 사용하여 Camera를 Customizing
 해야한다.
 */


import AVFoundation
import UIKit

class CameraViewController: UIViewController {
    // ❗️각각의 Capture Session, Capture Device, Capture Output, Capture Preview 가 어떤 기능과 동작을 하는지 알아보고 공부해야 함.
    
    // Capture Session
    var captureSession: AVCaptureSession = AVCaptureSession()
    
    // Capture Device
    var videoCaptureDevice: AVCaptureDevice?
    
    // Capture Output
    var captureOutput:AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
    
    // Capture Preview
    // Capture Session이 모두 만들어지면 Capture Preview에 전달하므로 Capture Preview는 Optional?
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    
    // Create view for hole the camera
    // isolate views for down side is recode button and up side is cancel button.
    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    // configure camera

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraView)
        self.view.backgroundColor = .systemBackground
        setUpCamera()
        // for stop capture video, close camera
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // make view frame is entire screen
        cameraView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // cameraVC의 tapBarController의 tabBar를 hidden 시킨다.
        // cameraNav를 눌렀을 때 camera가 깔금하게 전체 화면으로 띄우기 위해 tabBar를 hidden 시키는 것.
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc private func didTapClose() {
        captureSession.stopRunning()
        tabBarController?.tabBar.isHidden = false
        
        // switch back to the primary tab
        tabBarController?.selectedIndex = 0
        
        // if tab the close button
            // brings the first tab screen
    }
    
    // ❗️❗️ camera 관련된 코드를 만들고 test 할 때 simulator에서는 정상 작동하지만 실제 device에서는 작동하지 않고 error이 날 수 있다(or crush)
    // 그 이유는 simulator는 camera가 없기 때문에 error을 내지 않기 때문이다 그러므로 camera 관련 code는 꼭 real device를 이용해서 test.
    
    func setUpCamera() {
        // Add Devices
        
        // get audio device
        if let audioDeviece = AVCaptureDevice.default(for: .audio) {
            // if able to get it make session
            let audioInput = try? AVCaptureDeviceInput(device: audioDeviece)
            if let audioInput = audioInput {
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
            }
            // get video device
            // device have different types of camera (front side camera, back side camera)
            
            if let videoDevice = AVCaptureDevice.default(for: .video) {
                if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
                    if captureSession.canAddInput(videoInput) {
                        captureSession.addInput(videoInput)
                    }
                }
            }
        }
        
        // Updata Session
        captureSession.sessionPreset = .hd1280x720
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        
        // Configure Previews
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        // c.f : capturePreviewLayer이 optional인 이유
            // global로 capturePreviewLayer property를 만들었는데 optional로 assign 했기 때문이다.
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        
        // make same frame size with view
        capturePreviewLayer?.frame = view.bounds
        
        // unwrapping capturePreviewLayer
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        
        // Enable camera start
        // actuall running session code in here
        captureSession.startRunning()
    }
}

// extension for confirm AVCaptureFileOutputRecordingDelegate about video recording
extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // ❗️ outputFileURL  = parameter mean's where the video from disk (The file URL of the file that is being written.)
        
        // error
        guard error == nil else {
            return
        }
        
        // success recording
        print("Finished recording to url : \(outputFileURL.absoluteString)")
    }
    
    
}
