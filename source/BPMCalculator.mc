using Toybox.System;

class BPMCalculator {
    // Static-like variables for the calculator
    hidden var m_tapTimes;
    hidden var m_intervals;
    hidden var m_startTime;
    hidden var m_numSamples;
    hidden var m_bpm;
    hidden var m_secsElapsed;
    hidden var m_percentConsistentTaps;
    hidden var m_validThreshold;
    hidden var m_maxSamples;

    function initialize() {
        m_tapTimes = [];
        m_intervals = [];
        m_startTime = 0;
        m_numSamples = 0;
        m_bpm = 0.0;
        m_validThreshold = 5;
        m_secsElapsed = 0;
        
        m_percentConsistentTaps = 13;  // 13% maximum deviation
        m_maxSamples = 30;             // Limit stored samples
        
    }

    function onSample() {
        var currentTime = System.getTimer();
        
        if (m_startTime == 0) {
            m_startTime = currentTime;
            m_tapTimes = [currentTime];
        } else {
            m_tapTimes.add(currentTime);
            m_secsElapsed = (currentTime - m_startTime) / 1000.0;
            
            // Calculate interval from previous tap
            var interval = currentTime - m_tapTimes[m_tapTimes.size() - 2];
            m_intervals.add(interval);
            
            // Limit stored samples to prevent memory issues
            if (m_intervals.size() > m_maxSamples) {
                // Remove first element (oldest)
                var newIntervals = m_intervals.slice(1, m_intervals.size());
                var newTapTimes = m_tapTimes.slice(1, m_tapTimes.size());
                m_intervals = newIntervals;
                m_tapTimes = newTapTimes;
            }
        }
        
        m_numSamples += 1;
        
        // Calculate BPM using median method if we have enough intervals
        if (m_intervals.size() >= 1) {
            var medianInterval = calculateMedian(m_intervals);
            var consistentIntervals = filterConsistentIntervals(m_intervals, medianInterval);
            
            var finalMedianInterval;
            if (consistentIntervals.size() > 0) {
                finalMedianInterval = calculateMedian(consistentIntervals);
            } else {
                finalMedianInterval = medianInterval;
            }
            
            // Convert to BPM (beats per minute)
            m_bpm = 60000.0 / finalMedianInterval;
            m_validThreshold = calculateValidThreshold(m_bpm);
        }
        
        return true;
    }

    function calculateMedian(values) {
        if (values.size() == 0) {
            return 0;
        }
        
        // Create a copy and sort it
        var sorted = [];
        for (var i = 0; i < values.size(); i++) {
            sorted.add(values[i]);
        }
        
        // Simple bubble sort (MonkeyC doesn't have built-in sort)
        for (var i = 0; i < sorted.size() - 1; i++) {
            for (var j = 0; j < sorted.size() - i - 1; j++) {
                if (sorted[j] > sorted[j + 1]) {
                    var temp = sorted[j];
                    sorted[j] = sorted[j + 1];
                    sorted[j + 1] = temp;
                }
            }
        }
        
        var mid = sorted.size() / 2;
        
        if (sorted.size() % 2 == 0) {
            // Even number of elements - average the two middle values
            return (sorted[mid - 1] + sorted[mid]) / 2.0;
        } else {
            // Odd number of elements - return middle value
            return sorted[mid];
        }
    }

    function filterConsistentIntervals(intervals, medianInterval) {
        var consistentIntervals = [];
        //var maxDeviation = (m_percentConsistentTaps / 100.0) * medianInterval;
        
        for (var i = 0; i < intervals.size(); i++) {
            var interval = intervals[i];
            var deviation = interval - medianInterval;
            if (deviation < 0) {
                deviation = -deviation; // Absolute value
            }
            
            var percentDeviation = (deviation / medianInterval) * 100.0;
            
            if (percentDeviation <= m_percentConsistentTaps) {
                consistentIntervals.add(interval);
            }
        }
        
        return consistentIntervals;
    }
    
    function calculateValidThreshold(bpm) {
        // calculate validity threshold, add 1 more tap for each 10 bpm over 30
        var validThreshold = Math.floor((bpm - 30) / 10.0);
        // bound dynamic range between 0 and 5
        if (validThreshold < 0) {
            validThreshold = 0;
        } else if (validThreshold > 5) {
            validThreshold = 5;
        }
        // add constant threshold
        validThreshold = validThreshold + 5;
        return validThreshold;
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
        return false;
    }

    function getConsistencyInfo() {
        if (m_intervals.size() == 0) {
            return [ m_numSamples, 0, 0.0, false ];
        }
        
        var medianInterval = calculateMedian(m_intervals);
        var consistentIntervals = filterConsistentIntervals(m_intervals, medianInterval);
        var isValid = (consistentIntervals.size() >= m_validThreshold);
        
        return [ 
            m_numSamples, 
            consistentIntervals.size(), 
            (consistentIntervals.size().toFloat() / m_intervals.size().toFloat()) * 100.0,
            isValid
        ];
    }

    function reset() {
        m_tapTimes = [];
        m_intervals = [];
        m_startTime = 0;
        m_numSamples = 0;
        m_bpm = 0.0;
        m_validThreshold = 5;
        m_secsElapsed = 0;
    }
}