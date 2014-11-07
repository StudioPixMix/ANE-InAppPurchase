package com.studiopixmix.anes.InAppPurchase.event
{
	import flash.events.StatusEvent;

	/**
	 * Event dispatched when the ANE wants to log something.
	 */
	public class LogEvent extends InAppPurchaseANEEvent {
		// PROPERTIES
		public var message:String;
		
		// CONSTRUCTOR
		public function LogEvent(message:String) {
			super(InAppPurchaseANEEvent.LOG);
			
			this.message = message;
		}
		
		/**
		 * Builds a LogEvent from the given status event.
		 * The log message is in the "level" property of the event.
		 */
		public static function FromStatusEvent(statusEvent:StatusEvent):LogEvent {
			return new LogEvent(statusEvent.level);
		}
	}
}