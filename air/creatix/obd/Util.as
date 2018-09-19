package air.creatix.obd{
	import flash.utils.ByteArray;
	public class Util {
		public static var trace_cache="";
		public static function toArray(hex:String):ByteArray {
			hex = hex.replace(/^0x|\s|:/gm,'');
			var a:ByteArray = new ByteArray;
			if ((hex.length&1)==1) hex="0"+hex;
			for (var i:uint=0;i<hex.length;i+=2) {
				a[i/2] = parseInt(hex.substr(i,2),16);
			}
			return a;
		}
		
		
		public static function removeRareChars(str:String):String
		{
			var r:RegExp = new RegExp(/[^a-zA-Z 0-9\.]+/g) ;
			var yourString = str.replace(r, "");
			return yourString;
		}
		
		public static function print(str:String){
			trace(str);
			trace_cache+=str+"\n";
		}
	}
	
}
