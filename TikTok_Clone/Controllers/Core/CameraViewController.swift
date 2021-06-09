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
    var captureOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()

    // Capture Preview
    // Capture Session이 모두 만들어지면 Capture Preview에 전달하므로 Capture Preview는 Optional?
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?

    // make "outputFileURL" globaly

    var recordedVideoURL: URL?

    // Create view for hole the camera
    // isolate views for down side is recode button and up side is cancel button.
    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()

    // previewLayer를 global 하게 만드는 이유는 user가 video를 after recoding, tapped x button
    // that is not wanna close hole camera, just want to reset recording(take the camera back)
    // so for that reset recording is reson of why are we make "previewLayer" globaly
    private var previewLayer: AVPlayerLayer?

    // Recording Custom Button
        // when initialize recordingBtn, give not fram init parameter
            // why? because make own custom size and ui
            // so, make btn frame in viewDidLayoutSubviews() func.
    private let recordButton: RecordButton = RecordButton()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // addSubviews
        view.addSubview(cameraView)

        self.view.backgroundColor = .systemBackground
        setUpCamera()
        // for stop capture video, close camera
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )

        // setup record button Action func
        view.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // make view frame is entire screen
        cameraView.frame = view.bounds

        // make recording button frame
        let size: CGFloat = 75
        recordButton.frame = CGRect(
            x: (view.width - size)/2,
            y: view.height - view.safeAreaInsets.bottom - size - 5,
            width: size,
            height: size
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // cameraVC의 tapBarController의 tabBar를 hidden 시킨다.
        // cameraNav를 눌렀을 때 camera가 깔금하게 전체 화면으로 띄우기 위해 tabBar를 hidden 시키는 것.
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Functions

    @objc private func didTapRecord() {
        if captureOutput.isRecording {
            // toggle recording button for update UI
            recordButton.toggle(for: .notRecording)
            // stop recording
            captureOutput.stopRecording()
            // this haptic function is not aggressive vibration it's very common settle vibration
            // when user done recording, play vibartion
            HapticsManager.shared.vibrateForSelection()
        } else {
            // this url is path of video?
            // url is array?
            guard var url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else {
                return
            }
            // this haptic function is not aggressive vibration it's very common settle vibration
            // when user not recording, play vibartion
            HapticsManager.shared.vibrateForSelection()

            url.appendPathComponent("video.mov")

            // toggle recording button for update UI
            recordButton.toggle(for: .recording)

            // delete primary video file
            // if user take multiple video, writting url over and over.
            // if didn't delete video url override the file over and over.
            // so delete prior url

            // traget url이 써지기 전이므로 굳이 throw를 do - catch나 error handling 할 필요가 없으므로 try? oprional로 간단하게 처리한다.
            try? FileManager.default.removeItem(at: url)

            captureOutput.startRecording(to: url,
                                         recordingDelegate: self
            )
        }

    }

    @objc private func didTapClose() {
        // rightBarButtonItem is if user like recording video and befor uploaded
        // but didTapCloser method is user doesn't like video.
        // so rightBarButtonItem is nil and
        navigationItem.rightBarButtonItem = nil
        recordButton.isHidden = false

        if previewLayer != nil {
            // actually lecture code is blow
            /*
             previewLayer?.removeFromSuperlayer()
             previewLayer = nil
             */

            // but i made func
            reset()
        } else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false

            // switch back to the primary tab
            tabBarController?.selectedIndex = 0

            // if tab the close button
                // brings the first tab screen
        }
    }

    private func reset() {
        previewLayer?.removeFromSuperlayer()
        previewLayer = nil
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

// MARK: - extension for confirm AVCaptureFileOutputRecordingDelegate about video recording
extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // ❗️ outputFileURL  = parameter mean's where the video from disk (The file URL of the file that is being written.)

        // error
        guard error == nil else {
            // if not recording video
            // give the alert to user
            let alert = UIAlertController(
                title: "Woops",
                message: "Something went wrong when recording your video",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        // when success recording print log
        print("Finished recording to url : \(outputFileURL.absoluteString)")

        recordedVideoURL = outputFileURL

        // save video code
        if UserDefaults.standard.bool(forKey: "save_video") {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }

        // caption for if user like recording video
        // and make next btn for the move to another stage
        // before uploaded post
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))

        // whem success recording, show preview video
        // pop on the camera view
        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds

        guard let previewLayer = previewLayer  else {
            return
        }
        // after recording stop(user is tapped recording button)
        recordButton.isHidden = true
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
    }

    @objc private func didTapNext() {
        guard let url = recordedVideoURL else {
            return
        }
        // this haptic function is not aggressive vibration it's very common settle vibration
        // when user tap next button for write caption, play vibartion
        HapticsManager.shared.vibrateForSelection()
        // push caption controller
        let vc = CaptionViewController(videoURL: url)
        navigationController?.pushViewController(vc, animated: true)
    }

}
