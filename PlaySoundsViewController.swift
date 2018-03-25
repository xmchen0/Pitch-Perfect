//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Xiao Mei Chen on 21/3/18.
//  Copyright © 2018 Xiao Mei Chen. All rights reserved.
//

// MARK: - To import modules so we can use the functions within it

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    // MARK: - To connect properties UI elements to code on second screen
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // MARK: - Properties & enumeration: To be used by class extension
    
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int { case slow = 0, fast, chipmunk, vader, echo, reverb }
    
    // MARK: - To define sound buttons
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        configureUI(.playing)
    }
    
    // MARK: - To stop button function
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }

    // MARK: - To setupAudio (refer to ext file 'playsounds-audio') to ensure audioEngine is properly setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    // MARK: - To configure the UI (refer to ext file 'playsounds-audio') so UI is not in playing state
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
        buttonsImage()
    }
    
    // MARK: - To format the content mode of UIButton images
    
    func buttonsImage() {
        let contentMode: UIViewContentMode = .scaleAspectFit
        snailButton.imageView?.contentMode = contentMode
        rabbitButton.imageView?.contentMode = contentMode
        chipmunkButton.imageView?.contentMode = contentMode
        vaderButton.imageView?.contentMode = contentMode
        reverbButton.imageView?.contentMode = contentMode
        echoButton.imageView?.contentMode = contentMode
        stopButton.imageView?.contentMode = contentMode
    }

}
