using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Attention as Attn;

class BPMDelegate extends Ui.BehaviorDelegate {

    // reset
    function reset() {
        m_bpmCalculator.reset();

        Ui.requestUpdate();
    }

    // menu softkey resets
    function onMenu() {
        reset();
        
        if (Rez has :Menus && Rez.Menus has :TempoBPMMenu) {
            var menu = new Rez.Menus.TempoBPMMenu();
            menu.setTitle("Setup");
            Ui.pushView(menu, new BPMMenuDelegate(), Ui.SLIDE_IMMEDIATE);
        }
        
        return true;
    }
    
    // up/prev resets
    function onPreviousPage() {
        reset();
        return true;
    }
    
    // hold causes vibration and reset
    function onHold(evt) {
        var vibe = [new Attn.VibeProfile( 50, 100 )];
        Attn.vibrate(vibe);
        reset();
        return true;
    }
    
    // each tap recalculates BPM
    function onTap(evt) {
        onSelect();
        return true;
    }
    
    function onSelect() {
        m_bpmCalculator.onSample();
        
        Ui.requestUpdate();
        return true;
    }

}