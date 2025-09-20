using Toybox.System;

class SimpleBPMCalculator {
    // Static-like variables for the calculator
    var m_startTime;
    var m_numSamples;
    var m_bpm;
    var m_secsElapsed;

    function initialize() {
        m_startTime = 0;
        m_numSamples = 0;
        m_bpm = 0.0;
    }
    
    function onSample() {
        if (m_startTime == 0) {
            m_startTime = System.getTimer();
            m_secsElapsed = 0;
        }
        m_numSamples += 1;
        
        if (m_numSamples > 1) {
            var millis = System.getTimer() - m_startTime;
            var mins = millis / 60000.0;
            m_secsElapsed = mins * 60.0;
            m_bpm = (m_numSamples - 1) / mins;
        }
        
        return true;
    }
    
    function getBPM() {
        return m_bpm;
    }

    function getNumSamples() {
        return m_numSamples;
    }
    
    function getSecsElapsed() {
       return m_secsElapsed;
    }
    
    function isSimple() {
        return true;
    }
    
    function getConsistencyInfo() {    
        if (m_numSamples == 0) {
            return [ 0, 0, 0.0, false ];
        }
        
        return [ m_numSamples, m_numSamples, 100.0, true ];
    }
    
    function reset() {
        m_startTime = 0;
        m_numSamples = 0;
        m_bpm = 0.0;
        m_secsElapsed = 0;
    }
    
}