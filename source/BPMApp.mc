using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

var m_bpmCalculator;

class BPMApp extends App.AppBase {

    //! onStart() is called on application start up
    function onStart(state) {
    }

    //! onStop() is called when your application is exiting
    function onStop(state) {
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
        m_bpmCalculator = new SimpleBPMCalculator();
        //m_bpmCalculator = new BPMCalculator();
        m_bpmCalculator.initialize();
    }

    function onUpdate(dc)
    {   
        // clear display
        dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
        dc.clear();
        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
    
        var consistency = m_bpmCalculator.getConsistencyInfo();
        if (m_bpmCalculator.getBPM() > 0) {
            // display BPM info
            //var bpmString = "---";
            //if (consistency[3] == true) {
            //    bpmString = "" + m_bpmCalculator.getBPM().format("%.1f");
            //}
            
            // display BPM info
            var bpmString = "" + m_bpmCalculator.getBPM().format("%.1f");
            if (consistency[3] == true) {
                dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
            } else {
                dc.setColor( Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT );
            }
            dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - 60, Gfx.FONT_NUMBER_THAI_HOT, bpmString, Gfx.TEXT_JUSTIFY_CENTER );
            //var bpmLabelString = "BPM";
            //dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) + 5, Gfx.FONT_MEDIUM, bpmLabelString, Gfx.TEXT_JUSTIFY_CENTER );
            
            dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
            
            var min = 0;
            var sec = m_bpmCalculator.getSecsElapsed();
            
            // convert secs to mins and secs
            while (sec > 59) {
                min += 1;
                sec -= 60;
            }
            
            // format time
            var timerString = "" + min.format("%d") + ":" + sec.format("%02d");
            
            dc.drawText( (dc.getWidth() / 2), Gfx.getFontHeight(Gfx.FONT_MEDIUM), Gfx.FONT_MEDIUM, timerString, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER );
            
        } else {
            // display startup info
            var tapMsg = "Tap for tempo";
            dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - Gfx.getFontHeight(Gfx.FONT_MEDIUM), Gfx.FONT_MEDIUM, tapMsg, Gfx.TEXT_JUSTIFY_CENTER );
            var holdMsg = "Hold to reset";
            dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2), Gfx.FONT_MEDIUM, holdMsg, Gfx.TEXT_JUSTIFY_CENTER );
        }
        
        //var consistency = m_bpmCalculator.getConsistencyInfo();
        var numSamplesString;
        if (m_bpmCalculator.isSimple() == true) {
            numSamplesString = "" + consistency[0].format("%d") + " samples";
        } else {
            numSamplesString = "" + consistency[0].format("%d") + " / " + consistency[1].format("%d") + " / " + consistency[2].format("%d") + "%";
        }
        dc.drawText( (dc.getWidth() / 2), 2 * (dc.getHeight() / 3) + 10, Gfx.FONT_MEDIUM, numSamplesString, Gfx.TEXT_JUSTIFY_CENTER );
    }
}