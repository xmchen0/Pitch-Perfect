//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Xiao Mei Chen on 20/3/18.
//  Copyright © 2018 Xiao Mei Chen. All rights reserved.
//

// MARK: - To import modules so we can use the functions within it

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: - To connect properties UI elements to code on first screen
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
        let alert = UIAlertController(title: "Did you bring your towel?", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)
    
    // MARK: - To display UI objects on initial screen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        configUI(recording: false)
    }

    // MARK: - To re-record by navigating back to the first screen from the second
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordButton.isEnabled = true
        recordingLabel.text = "Tap to Record"
        stopRecordingButton.isEnabled = false
    }
    
    // MARK: - To enable and disable the recording button and setting label text
    
    func configUI(recording state: Bool) {
        recordingLabel.text = state ? "Recording in Session..." : "Tap to Record"
        recordButton.isEnabled = !state
        stopRecordingButton.isEnabled = state
    }
    
    // MARK: - To record audio and playback sound
    
    @IBAction func recordAudio(_ sender: Any) {
        configUI(recording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: - To stop recording
    
    @IBAction func stopRecording(_ sender: Any) {
        configUI(recording: true)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    // MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            recordButton.isEnabled = true
            stopRecordingButton.isHidden = true
            
            print("Recording was not successful")
            
            let alertController = UIAlertController(title: "Error", message: "Recording was not successful. Please try again.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - To programmatically segue from first screen to second screen
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: - To format the content mode of UIButton images
    
    func buttonsImage() {
        let contentMode: UIViewContentMode = .scaleAspectFit
        recordButton.imageView?.contentMode = contentMode
        stopRecordingButton.imageView?.contentMode = contentMode
    }
}
