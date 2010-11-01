
import flash.display.DisplayObject;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import org.libspark.betweenas3.BetweenAS3;
import org.libspark.betweenas3.core.easing.IEasing;
import org.libspark.betweenas3.core.ticker.ITicker;
import org.libspark.betweenas3.core.tweens.AbstractTween;
import org.libspark.betweenas3.core.tweens.IITween;

class Matrix3DTween extends AbstractTween
{
	/**
	 * static ITicker cache.
	 */
	private static var _ticker:ITicker;
	
	/**
	 * initial Matrix3D storage.
	 */
	private var _start:Matrix3D;
	
	/**
	 * DisplayObject.
	 */
	public function get target():DisplayObject { return _target; }
	public function set target(value:DisplayObject):void {
		_start = value.transform.matrix3D.clone();
		_target = value;
	}
	private var _target:DisplayObject;
	
	/**
	 * Tween easing.
	 */
	public function get easing():IEasing { return _easing; }
	public function set easing(value:IEasing):void { _easing = value; }
	private var _easing:IEasing;
	
	/**
	 * Destination transform matrix.
	 */
	public function get matrix():Matrix3D { return _matrix; }
	public function set matrix(value:Matrix3D):void { _matrix = value; }
	private var _matrix:Matrix3D;
	
	/**
	 * Set or get duration.
	 */
	public function get time():Number { return _duration; }
	public function set time(value:Number):void { _duration = value; }
	
	/**
	 * Constructor.
	 *
	 * @param duration sleep duration.
	 * @param ticker   ticker object.
	 * @param position initial position.
	 */
	public function Matrix3DTween(ticker:ITicker = null, position:Number = 0) {
		if (!_ticker) {
			// create tmp tween to get the BetweenAS3's static ticker.
			var tmpTween:IITween = BetweenAS3.parallel() as IITween;
			_ticker = tmpTween.ticker;
		}
		
		super(ticker || _ticker, position);
	}
	
	/**
	 * 更新処理を行う。
	 */
	protected override function internalUpdate(time:Number):void
	{
		// check
		if (!_target) { throw new Error("target is not set"); }
		if (!_easing) { throw new Error("easing is not set"); }
		if (!_matrix) { throw new Error("matrix is not set"); }
		
		// get the factor (0.0~1.0)
		var factor:Number = 0.0;
		if (time > 0.0) {
			if (time < _duration) {
				factor = _easing.calculate(time, 0.0, 1.0, _duration);
			}
			else {
				factor = 1.0;
			}
		}
		
		// update the matrix
		_target.transform.matrix3D = interpolate(_start, _matrix, factor);
	}
	
	// forked from umhr's 【未完成】Matrix3D.interpolate(),
	// changed to handle matrices with scaling components (the builtin Matrix3D.interpolate doesn't)
	
	private function interpolate(thisMat:Matrix3D,toMat:Matrix3D,percent:Number):Matrix3D{
		var thisDecomp:Vector.<Vector3D> = thisMat.decompose("quaternion");
		var toDecomp:Vector.<Vector3D> = toMat.decompose("quaternion");
		
		var v0:Vector3D = thisDecomp[1];
		var v1:Vector3D = toDecomp[1];
		var cosOmega:Number = v0.w*v1.w + v0.x*v1.x + v0.y*v1.y + v0.z*v1.z;
		if(cosOmega < 0){
			v1.x = -v1.x;
			v1.y = -v1.y;
			v1.z = -v1.z;
			v1.w = -v1.w;
			cosOmega = -cosOmega;
		}
		var k0:Number;
		var k1:Number;
		if(cosOmega > 0.9999){
			k0 = 1 - percent;
			k1 = percent;
		}else{
			var sinOmega:Number = Math.sqrt(1 - cosOmega*cosOmega);
			var omega:Number = Math.atan2(sinOmega,cosOmega);
			var oneOverSinOmega:Number = 1/sinOmega;
			k0 = Math.sin((1-percent)*omega)*oneOverSinOmega;
			k1 = Math.sin(percent*omega)*oneOverSinOmega;
		}
		var scale_x:Number = thisDecomp[2].x*(1-percent) + toDecomp[2].x*percent;
		var scale_y:Number = thisDecomp[2].y*(1-percent) + toDecomp[2].y*percent;
		var scale_z:Number = thisDecomp[2].z*(1-percent) + toDecomp[2].z*percent;
		
		var tx:Number = thisDecomp[0].x*(1-percent) + toDecomp[0].x*percent;
		var ty:Number = thisDecomp[0].y*(1-percent) + toDecomp[0].y*percent;
		var tz:Number = thisDecomp[0].z*(1-percent) + toDecomp[0].z*percent;
		
		var x:Number = v0.x*k0+v1.x*k1;
		var y:Number = v0.y*k0+v1.y*k1;
		var z:Number = v0.z*k0+v1.z*k1;
		var w:Number = v0.w*k0+v1.w*k1;
		var _q:Vector.<Number> = new Vector.<Number>(16,true);
		_q[0] = (1-2*y*y-2*z*z)*scale_x;
		_q[1] = (2*x*y+2*w*z)*scale_x;
		_q[2] = (2*x*z-2*w*y)*scale_x;
		_q[3] = 0;
		_q[4] = (2*x*y-2*w*z)*scale_y;
		_q[5] = (1-2*x*x-2*z*z)*scale_y;
		_q[6] = (2*y*z+2*w*x)*scale_y;
		_q[7] = 0;
		_q[8] = (2*x*z+2*w*y)*scale_z;
		_q[9] = (2*y*z-2*w*x)*scale_z;
		_q[10] = (1-2*x*x-2*y*y)*scale_z;
		_q[11] = 0;
		_q[12] = tx;
		_q[13] = ty;
		_q[14] = tz;
		_q[15] = 1;
		
		return new Matrix3D(_q);
	}
}