//
//  AlarmSound.swift
//  GCTRACKV2BETA
//
//  Created by Carlos Torres on 26/11/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
import AVFoundation


public class AlarmSound{
    
    var sound : AVAudioPlayer? = nil
    var alarmSoundEffect: AVAudioPlayer!

    public func playSound(){
        let path = Bundle.main.path(forResource: "alarm", ofType:"wav")!
        let url = URL(fileURLWithPath: path)
        
        do {
            sound = try AVAudioPlayer(contentsOf: url)
            alarmSoundEffect = sound
            sound?.numberOfLoops = -1
           
            if(!(sound?.isPlaying)!){
            sound?.play()
                
            }
        } catch {
print("sound could not be played")
        
        }

    
        
        
    }
    
    public func stopSounds(){
        sound?.stop()
        
        
        UIApplication.shared.cancelAllLocalNotifications()
        
        
    }
    
    
}