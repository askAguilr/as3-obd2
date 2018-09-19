//Generic command sends a command based on a string used in the constructor
package  air.creatix.obd.commands{

public class GenericCommand extends ObdCommand {
	public var command_str="";
    public function GenericCommand(str="ATSP0") {
        super(str);
		command_str=str;;
    }

	//calculate values
    override public function performCalculations():Object {
		var data:Object=new Object();
		return data;
    }


}

	
}
