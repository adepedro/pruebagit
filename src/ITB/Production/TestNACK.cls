Class ITB.Production.TestNACK Extends Ens.Production
{

/// Location and Revision of this file in Perforce (Auto-updating)
Parameter SrcVer = "$Id$";

XData ProductionDefinition
{
<Production Name="ITB.Production.TestNACK" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="HL7TCPOperation" Category="ER7" ClassName="ITB.HL7.BO.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="Port">7777</Setting>
    <Setting Target="Host" Name="SearchTableClass">EnsLib.HL7.SearchTable</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Host" Name="NACKControl">1</Setting>
  </Item>
  <Item Name="NACKTCPService" Category="ER7" ClassName="ITB.HL7.BS.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">NACKProcess</Setting>
    <Setting Target="Adapter" Name="Port">5555</Setting>
    <Setting Target="Host" Name="IgnoreInboundAck">0</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Adapter" Name="StayConnected">2</Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
  </Item>
  <Item Name="NACKProcess" Category="ER7" ClassName="ITB.HL7.BP.NACKProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="Target">HL7TCPOperation</Setting>
    <Setting Target="Host" Name="SearchTableClass">EnsLib.HL7.SearchTable</Setting>
  </Item>
  <Item Name="HL7FileService" Category="ER7" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HL7TCPOperation</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Test\ITB\inHL7</Setting>
    <Setting Target="Adapter" Name="ArchivePath"></Setting>
    <Setting Target="Adapter" Name="FileSpec">*.hl7</Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
  </Item>
  <Item Name="HL7TCPXMLOperation" Category="XML" ClassName="ITB.HL7.BO.TCPXMLOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="Port">6666</Setting>
    <Setting Target="Host" Name="SearchTableClass">EnsLib.HL7.SearchTable</Setting>
    <Setting Target="Host" Name="NACKControl">1</Setting>
  </Item>
  <Item Name="HL7FileXMLService" Category="XML" ClassName="ITB.HL7.BS.FileXMLService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\Test\ITB\inHL7</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.xml</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HL7TCPXMLOperation</Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
  </Item>
  <Item Name="NACKTCPXMLService" Category="XML" ClassName="ITB.HL7.BS.TCPXMLService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">NACKXMLProcess</Setting>
    <Setting Target="Adapter" Name="Port">4444</Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
  </Item>
  <Item Name="NACKXMLProcess" Category="XML" ClassName="ITB.HL7.BP.NACKProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="Target">HL7TCPXMLOperation</Setting>
    <Setting Target="Host" Name="SearchTableClass">EnsLib.HL7.SearchTable</Setting>
  </Item>
</Production>
}

}
