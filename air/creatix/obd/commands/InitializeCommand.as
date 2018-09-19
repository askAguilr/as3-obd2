package  air.creatix.obd.commands{

public class InitializeCommand extends ObdCommand {
    private var rpm:int = -1;

    public function InitializeCommand() {
        super("ATSP0");
    }

	//calculate values
    override public function performCalculations():Object {
		var data:Object=new Object();
		return data;
    }


}

	
}
