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
            sound?.numberOfLoops = 0
           
            if(!(sound?.isPlaying)!){
            sound?.play()
                
            }
            
            
            
            
            
            
        } catch {
        
        }

    
        
        
    }
    
    public func stopSounds(){
       // sound?.stop()
        sound?.pause()
        
        UIApplication.shared.cancelAllLocalNotifications()
        
        
    }
    
    
}
