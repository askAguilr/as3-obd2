package  air.creatix.obd.commands{
	import air.creatix.obd.sockets.*;
	import air.creatix.obd.Util;
	import flash.display.MovieClip;

public class ObdCommand {
	public var cmd:String;
	public var response:String;
    public function ObdCommand(command:String) {
        this.cmd = command;
    }

    public function sendCommand(p:ComSocket){
        p.write(cmd + "\r");
        p.flush();
		Util.print("--------->>>>>>>>"+cmd);
    }

    public function getCommandPID():String {
        return cmd;
    }
	
	public function receiveCommand(p:String){
		response=p;
		
	}
	
	public function performCalculations():Object {
		var data:Object=new Object();
		data.value=response;
		return data;
	}
	


}	
}
