Class ITB.Installer
{

Parameter EnableUnitTestPortal = "yes";

XData Install
{
<Manifest>
    <Var Name="BasePath" Value="/opt/ITB4IRIS/"/> 
    <Var Name="SourcePath" Value="${BasePath}/src/"/> 
    <Var Name="ConfigPath" Value="${BasePath}/config/"/>
    <Log Text="Using namespace ${Namespace}" Level="0"/>
    <Namespace Name="${Namespace}" Create="no" Ensemble=""> 
        <Import File="${SourcePath}ITB.inc" Recurse="1" Flags="cuk" />
        <Import File="${SourcePath}" Recurse="1" Flags="cuk" />
        <Import File="${ConfigPath}" Recurse="1" Flags="cuk" />
    </Namespace>
</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
   #; Let XGL document generate code for this method. 
   Quit ##class(%Installer.Manifest).%Generate(%compiledclass,
      %code, "Install")
}

}
