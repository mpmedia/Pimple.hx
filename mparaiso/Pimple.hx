package mparaiso;

/**
 * Pimple.hx is a small Dependency Injection Container for Haxe
 * inspired by Pimple written by Fabien Potencier
 * @see https://github.com/fabpot/Pimple
 * @author MParaiso <mparaiso@online.fr>
 * @version 0.0.1
 */
class Pimple {
	private var _values:Hash<Dynamic>;
	public function new() {
		_values = new Hash<Dynamic>();
	}
	
	/**
     * Sets a parameter or an object.
     *
     * Objects must be defined as Closures.
     *
     * Allowing any PHP callable leads to difficult to debug problems
     * as function names (strings) are callable (creating a function with
     * the same a name as an existing parameter would break your container).
     *
     * @param string     The unique identifier for the parameter or object
     * @param mixed  The value of the parameter or a closure to defined an object
	 */
	public function set(key:String, value:Dynamic) {
		_values.set(key, value);
		return this;
	}
	

    /**
     * Returns a closure that stores the result of the given closure for
     * uniqueness in the scope of this instance of Pimple.
     *
     * @param Dynamic A closure to wrap for uniqueness
     *
     * @return Pimple->Dynamic The wrapped closure
     */
	public function share(func:Dynamic):Pimple->Dynamic {
		var r = null;
		var self = this;
		return function(p:Pimple) {
			if (r == null) r = func(p);
			return r;
		};
	}
	
	 /**
     * Gets a parameter or an object.
     *
     * @param string The unique identifier for the parameter or object
     *
     * @return Dynamic The value of the parameter or an object
     *
     * @throws InvalidArgumentException if the identifier is not defined
	 */
	public function get(key:String):Dynamic {
		if (_values.exists(key)) {
			var value = _values.get(key);
			if (Reflect.isFunction(value)) {
				return value(this);
			}
			return value;
		}else {
			throw Std.format("Identifier '$key' is not defined.");
		}
		return;
	}
	
	/**
     * Gets a parameter or the closure defining an object.
     *
     * @param string The unique identifier for the parameter or object
     *
     * @return mixed The value of the parameter or the closure defining an object
     *
     * @throws InvalidArgumentException if the identifier is not defined
	 */
	public function raw(key:String):Dynamic {
		if (!_values.exists(key)) throw Std.format('Identifier "$key" is not defined.');
		return _values.get(key);
	}
	
	 /**
     * Returns a closure that stores the result of the given closure for
     * uniqueness in the scope of this instance of Pimple.
     *
     * @param Dynamic A closure to wrap for uniqueness
     *
     * @return Void->Dynamic The wrapped closure
     */
	public function protect(value:Dynamic):Void->Dynamic {
		return function():Dynamic {
			return value;
		};
	}
	
	/**
	 * Returns all defined value names.
	 * @return Iterator<String> An array of value names
	 */
	public function keys():Iterator<String> {
		return _values.keys();
	}
}