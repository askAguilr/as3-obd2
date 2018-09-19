package  air.creatix.obd.commands{
import air.creatix.obd.Util;
	
	
	//cantidad de errores activos
public class PendingTroubleCodesCommand extends ObdCommand {
	public const PID="07";
	public const name="pendingtroublecodes";
	public var value:int=0;
	private const dtcLetters:Array = new Array("P", "C", "B", "U");
    private const hexArray = "0123456789ABCDEF".split("");
	
    public function PendingTroubleCodesCommand() {
        super(PID);
    }

	
	//calculate values
    override public function performCalculations():Object {
		var rbytes=air.creatix.obd.Util.toArray(response);
		var result=response;
		var workingData:String="";
		var codes="";
        var startIndex:int = 0;//Header size.
		var errorList:Array=new Array();
        var canOneFrame:String = response;
		var canOneFrameLength:int = canOneFrame.length;
        if (canOneFrameLength <= 16 && canOneFrameLength % 4 == 0) {//CAN(ISO-15765) protocol one frame.
            workingData = canOneFrame;//47yy{codes}
            startIndex = 4;//Header is 47yy, yy showing the number of data items.
        } else if (result.indexOf(":")>=0) {//CAN(ISO-15765) protocol two and more frames.
            workingData = result.split(".:").join("");//xxx47yy{codes}
            startIndex = 7;//Header is xxx47yy, xxx is bytes of information to follow, yy showing the number of data items.
        } else {//ISO9141-2, KWP2000 Fast and KWP2000 5Kbps (ISO15031) protocols.
			var myPattern:RegExp = /^47|[\r\n]47|[\r\n]/gi;  
            workingData = result.replace("^47|[\r\n]47|[\r\n]", "");
        }
        for (var begin = startIndex; begin < workingData.length; begin += 4) {
            var dtc:String = "";
			
			var tmp =air.creatix.obd.Util.toArray(workingData.charAt(begin));
            var b1:int = tmp[0];
            var ch1:int = ((b1 & 0xC0) >> 6);
            var ch2:int = ((b1 & 0x30) >> 4);
            dtc += dtcLetters[ch1];
            dtc += hexArray[ch2];
            dtc += workingData.substring(begin+1, begin + 4);
            if (dtc=="P0000") {
				Util.print("Codigo P0000");
                var tdata=new Object();
				tdata.value=value;
				tdata.codes=errorList;
				return tdata;
            }
			errorList.push(dtc);
            value++;
        }
		
		var data:Object=new Object();
		data.value=value;
		data.codes=errorList;
		return data;
    }
	//returns result as they are
	public function getResult(){
		return value;
	}

}

	
}
