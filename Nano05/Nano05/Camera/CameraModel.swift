//
//  CameraModel.swift
//  fruitDetector
//
//  Created by Luca Lacerda on 22/02/24.
//
import SwiftUI
import AVFoundation
import CoreImage
import CoreML
import Foundation

class CameraModel:NSObject, ObservableObject {
    
    @Published var frama:UIImage?
    private var lastFrames:[UIImage] = []
    private var captureSession:AVCaptureSession = AVCaptureSession()
    private var videoOutput:AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    private var context = CIContext()
    private var backCamera:AVCaptureDevice?
    private var backInput:AVCaptureDeviceInput?
    private var imageClassifier: HomeObjects?
    
    override init() {
        super.init()
        checkPermission()
        setupCaptureSession()
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (autorized) in
                if !autorized{
                    fatalError()
                }
            }
        default:
            fatalError()
        }
    }
    
    func setupCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.beginConfiguration()
            
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            self.setupInputs()
            
            self.setupOutputs()
            
            self.captureSession.commitConfiguration()
            
            self.captureSession.startRunning()
        }
    }
    
    func setupOutputs() {
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInitiated)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError()
        }
        
        videoOutput.connections.first?.videoRotationAngle = 90
    }
    
    func setupInputs() {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back){
            self.backCamera = device
        } else {
            fatalError()
        }
        guard let bInput = try? AVCaptureDeviceInput(device: self.backCamera!) else {fatalError()}
        backInput = bInput
        if !captureSession.canAddInput(backInput!) {
            fatalError()
        }
        captureSession.addInput(backInput!)
    }
    
    func classifyImage()-> String {
        do {
            let model = try HomeObjects(configuration: MLModelConfiguration())
            guard let pixelBuffer = frama?.toCVPixelBuffer() else { return "" }
            let prediction = try model.prediction(image: pixelBuffer)
            
            if verifyTarget(target: prediction.target){
                return prediction.target
            } else {
                return ""
            }
        } catch {
            // Lide com o erro aqui, por exemplo, imprimindo a mensagem de erro
            print("Erro ao classificar a imagem: \(error)")
        }
        return ""
    }
    
    func verifyTarget(target:String)-> Bool {
        var targetCount = 0
        let framesToAnalyze = self.lastFrames
        
        do{
            for frame in framesToAnalyze{
                let model = try HomeObjects(configuration: MLModelConfiguration())
                guard let pixelBuffer = frame.toCVPixelBuffer() else { return false }
                let prediction = try model.prediction(image: pixelBuffer)
                if prediction.target == target {
                    targetCount += 1
                }
            }
            if targetCount == 8 {
                return true
            } else {
                return false
            }
            
        }catch {
            print("erro ao classificar imagem")
        }
        return false
    }
    
    func lastFramesControl(uiImage:UIImage) {
        if lastFrames.count < 8 {
            lastFrames.append(uiImage)
        } else if lastFrames.count == 8 {
            lastFrames.removeFirst()
            lastFrames.append(uiImage)
        }
    }
    
}

extension CameraModel: AVCaptureVideoDataOutputSampleBufferDelegate{
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let uiImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {return}
        lastFramesControl(uiImage: uiImage)
        DispatchQueue.main.async { [unowned self] in
            self.frama = uiImage
        }
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return nil}
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {return nil}
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage
    }
}
