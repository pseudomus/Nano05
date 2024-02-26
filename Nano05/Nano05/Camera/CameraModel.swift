//
//  CameraModel.swift
//  fruitDetector
//
//  Created by Luca Lacerda on 22/02/24.
//
import SwiftUI
import AVFoundation
import CoreImage
import Foundation

class CameraModel:NSObject, ObservableObject {
    
    @Published var frama:UIImage?
    private var captureSession:AVCaptureSession = AVCaptureSession()
    private var videoOutput:AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    private var context = CIContext()
    private var backCamera:AVCaptureDevice?
    private var backInput:AVCaptureDeviceInput?
    
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
}

extension CameraModel: AVCaptureVideoDataOutputSampleBufferDelegate{
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {return}
        DispatchQueue.main.async { [unowned self] in
            self.frama = cgImage
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
