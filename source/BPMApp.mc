using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Attention as Attn;

var m_numSamples = 0;
var m_startTime = 0;
var m_bpm = 0;

class BPMApp extends App.AppBase {

    //! onStart() is called on application start up
    function onStart() {
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new BPMView(), new BPMDelegate() ];
    }

}

class BPMView extends Ui.View
{

    function onLayout(dc)
    {
    }

    function onUpdate(dc)
    {   
        var invertColors = false;
        if (!invertColors) {
            dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
        } else {
            dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_WHITE );
        }
        dc.clear();
        if (!invertColors) {
            dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        } else {
            dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT );
        }
    
        if (m_bpm > 0) {
            var bpmString = "" + m_bpm.format("%.2f");
            dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - 60, Gfx.FONT_NUMBER_THAI_HOT, bpmString, Gfx.TEXT_JUSTIFY_CENTER );
            var bpmLabelString = "BPM";
            dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) + 5, Gfx.FONT_MEDIUM, bpmLabelString, Gfx.TEXT_JUSTIFY_CENTER );
        } else {
            var tapMsg = "Tap for tempo";
            dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - 50, Gfx.FONT_MEDIUM, tapMsg, Gfx.TEXT_JUSTIFY_CENTER );
            var holdMsg = "Hold to reset";
            dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - 25, Gfx.FONT_MEDIUM, holdMsg, Gfx.TEXT_JUSTIFY_CENTER );
        }
        
        var numSamplesString = "" + m_numSamples + " samples";
        dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) + 45, Gfx.FONT_MEDIUM, numSamplesString, Gfx.TEXT_JUSTIFY_CENTER );
    }

}

class BPMDelegate extends Ui.BehaviorDelegate {

    function reset() {
        m_numSamples = 0;
        m_startTime = 0;
        m_bpm = 0;
        Ui.requestUpdate();
    }

    function onMenu() {
       reset();
    }
    
    function onHold() {
        var vibe = [new Attn.VibeProfile(  50, 100 )];
        Attn.vibrate(vibe);
        reset();
    }
    
    function onTap(evt) {
        if (m_startTime == 0) {
            m_startTime = System.getTimer();
        }
        m_numSamples += 1;
        
        if (m_numSamples > 1) {
            var millis = System.getTimer() - m_startTime;
            var mins = millis / 60000.0;
            m_bpm = (m_numSamples - 1) / mins;
        }
        
        Ui.requestUpdate();
    }

}