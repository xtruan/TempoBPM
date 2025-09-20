using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class BPMMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
    
        // handle main menu
        if (item == :mean_simple) {
            m_bpmCalculator = new SimpleBPMCalculator();
            m_bpmCalculator.initialize();
        } else if (item == :median_adv) {
            m_bpmCalculator = new BPMCalculator();
            m_bpmCalculator.initialize();
        }
        
    }
}