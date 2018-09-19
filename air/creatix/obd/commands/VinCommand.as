package  air.creatix.obd.commands{
import air.creatix.obd.Util;
	
	
	//cantidad de errores activos
public class VinCommand extends ObdCommand {
    private var value="";
	public const PID="0902";
	public const name="vin";
    public function VinCommand() {
        super(PID);
    }

	//calculate values
    override public function performCalculations():Object {
		var rbytes=air.creatix.obd.Util.toArray(response);
        var result=response;
        var workingData="";
        if (result.indexOf(":")>=0) {//CAN(ISO-15765) protocol. //TODO: not working on CAN
            workingData = result.split(".:").join("").substring(9);//9 is xxx490201, xxx is bytes of information to follow.
           // Matcher m = Pattern.compile("[^a-z0-9 ]", Pattern.CASE_INSENSITIVE).matcher(convertHexToString(workingData));
           // if(m.find()) workingData = result.replaceAll("0:49", "").replaceAll(".:", "");
            workingData = result.split(".:").join("");
			workingData = result.split("0:49").join("");
        } else {//ISO9141-2, KWP2000 Fast and KWP2000 5Kbps (ISO15031) protocols.
			var re:RegExp = /(49020.)/;
            workingData = result.replace(re, "");
        }
		
        value = workingData.replace(/[\u0000-\u001f]/, "");		
		var data:Object=new Object();
		data.value=Number(value);
		return data;
    }
	//returns result as they are
	public function getResult(){
		return value;
	}

}

	
}
