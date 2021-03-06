/// TCP Inbound Adapter that reads incoming framed data (MLLP)
Class ITB.TCP.FramedInboundAdapter Extends (EnsLib.TCP.InboundAdapter, ITB.TCP.FramedCommon)
{

/// Location and Revision of this file in Perforce (Auto-updating)
Parameter SrcVer = "$Id$";

Parameter SERVICEINPUTCLASS = "%Stream.Object";

Parameter SERVICEOUTPUTCLASS = "%Stream.Object";

Parameter SETTINGS = "UseFileStream,PrefixChar,SuffixChar";

/// The minimum interval between invocations of the adapter by the Ensemble framework. For adapters that poll for
/// external events, this is the polling interval. However, most polling adapters will process all inputs immediately
/// if several are detected at one time. This is also the interval at which each Business Service will check for shutdown requests.
Property CallInterval As %Numeric(MINVAL = 0.1) [ InitialExpression = 0.1 ];

Method OnConnected() As %Status
{
	set tQuitErr=1  
	
	do {
		set tCharset=..Charset  
		set:$case($zcvt(..Charset,"L"),"default":1,"auto":1,:0) tCharset="UTF-8"
		set tStream=$$$NULLOREF
		
		// read input
		set tSC=..ReadFramedStream(.tStream,tCharset,..CallInterval,..ReadTimeout,1)
		if $$$ISERR(tSC) {
			if ..IsReadError(tSC) {
				set tSC=$$$ERROR($$$EnsErrInConnectionLost,"TCP Framed Read",..IOAddr,$$$StatusDisplayString(tSC))
				set tQuitErr=0  
				do ..Disconnect()
				if '$IsObject(tStream)||'tStream.Size set tTxt=$$$StatusText(tSC),tSC=$$$OK  
				if ..StayConnected<0 { 
					$$$LOGWARNING(tTxt) 
				} elseif ..%logConnections { 
					$$$LOGINFO(tTxt) 
				} else { 
					$$$sysTRACE(tTxt) 
				}
			}
			elseif $$$StatusEquals(tSC,$$$EnsErrTCPReadTimeoutExpired) {
				set tQuitErr=0
			}
			quit
		}
		
		// do not call BS if empty input
		if tStream.Size=0 quit
		
		// process input
		$$$ANEWINIOLOGENTRY($$$OK,"TCP ReadFramedStream on :"_..IOAddr,tStream)
		set tSC=..BusinessHost.ProcessInput(tStream, .tStreamOut)
		if $$$ISERR(tSC) {
			$$$ACLOSEIOLOGENTRY(tSC,"after TCP Framed ProcessInput error on :"_..IOAddr,tStreamOut)
			quit
		}
		
		// write output
		if $$$IsdefObject(tStreamOut) {
			$$$ASSERT(tStreamOut.%Extends("%Stream.Object")||tStreamOut.%Extends("%IO.I.Stream"))
			set tSC=..WriteFramedStream(tStreamOut,tCharset,1)
			if $$$ISERR(tSC) {
				if ..IsWriteError(tSC) {
					set tSC=$$$ERROR($$$EnsErrInConnectionLost,"TCP Framed Write",..IOAddr,$$$StatusDisplayString(tSC))
					set tQuitErr=0
					do ..Disconnect()
				}
				$$$ACLOSEIOLOGENTRY(tSC,"after TCP WriteFramedStream error on :"_..IOAddr,tStreamOut)
				quit
			}
			$$$ACLOSEIOLOGENTRY(tSC,"after TCP WriteFramedStream on :"_..IOAddr,tStreamOut)
		} else {
			$$$ACLOSEIOLOGENTRY(tSC,"after TCP ProcessInput on :"_..IOAddr,$$$NULLOREF)
		}
	} while 0
	
	
	// returning error status would cause this listener job to terminate
	if $$$ISERR(tSC) {
		// never quit the listener, but drop the connection on unrecognized error
		if tQuitErr&&..Connected&&..StayConnected { 
			$$$LOGERROR("Disconnecting due to "_$$$StatusDisplayString(tSC)) 
			set tSC=$$$OK  
			do ..Disconnect() 
		}
		if $$$ISERR(tSC) $$$TRACE($SYSTEM.Status.GetOneErrorText(tSC))
	}
	quit $$$OK
}

}
