package  
{
	import Box2D.Common.Math.b2Vec2;
	import com.actionsnippet.qbox.QuickObject;
	
	/**
	 * ...
	 * @author Sone
	 */
	public interface ExpObject 
	{
		function get expVector():b2Vec2;
		function get price():int;
		function update():void;
		function get quickObject():QuickObject;
	}	
}