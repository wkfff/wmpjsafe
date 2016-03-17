{$INCLUDE eDefines.inc}

{ Define to check for RemObjects SDK 3.0 [vs. future versions] }
{.$DEFINE ROSDK4}
{$DEFINE ROSDK5}

{ Define to check for RemObjects SDK 3.0 and above [vs. older versions] }
{$DEFINE ROSDK3UP}
{$DEFINE ROSDK4UP}
{$DEFINE ROSDK5UP}

{ DXSock }

    { To use RemObjects with the standalone version of DXSock, simply remove the
      define below. Note that this has only been tested with DXSock 3.0, and that
      doing so requires a separate license for DXSock from Brain PatchWorks
      see http://www.bpdx.com for more information }

    {$DEFINE RemObjects_USE_RODX}

{ Internet Component Suite (ICS) }
    { Internet Component Suite - http://www.overbyte.be }
    
    {$DEFINE RemObjects_ICS_v5}
    {.$DEFINE RemObjects_ICS_v6}

{ Indy }

   { If you are using Indy 10.2.3 or the latest just uncomment the
     RemObjects_INDY10C DEFINE right below, and remove the Indy
     package references from the Requires section of RemObjects_Indy_Dx.dpk
     before re-compiling your RemObjects Indy package. }

  {.$DEFINE RemObjects_INDY10C}
  {$IFDEF RemObjects_INDY10C}
    {$DEFINE RemObjects_INDY10}  
    {$DEFINE RemObjects_INDY10B}
    {$DEFINE RemObjects_GLOBAL_INDY_DEFINE}
  {$ENDIF}

   { If you are using latest Indy 10 in Delphi 6 or 7, just uncomment the 
     RemObjects_INDY10_in_Delphi67 DEFINE right below, and remove the Indy 
     package references from the Requires section of RemObjects_Indy_Dx.dpk 
     before re-compiling your RemObjects Indy package. }

  {.$DEFINE RemObjects_INDY10_in_Delphi67}
  {$IFDEF RemObjects_INDY10_in_Delphi67}
    {$DEFINE RemObjects_INDY10}  
    {$DEFINE RemObjects_INDY10B}  
    {$DEFINE RemObjects_GLOBAL_INDY_DEFINE}
  {$ENDIF}

  {$IFNDEF RemObjects_GLOBAL_INDY_DEFINE}

    {$UNDEF RemObjects_INDY8}
    {$UNDEF RemObjects_INDY9}
    {$UNDEF RemObjects_INDY10}

    {$IFDEF FPC}
    	{$DEFINE RemObjects_INDY10}
    	{$DEFINE RemObjects_INDY10B}
      {$DEFINE RemObjects_INDY10C}
    {$ELSE}
      {$IFDEF DELPHI12UP}
        {$DEFINE RemObjects_INDY10}
        {$DEFINE RemObjects_INDY10B}
        {$DEFINE RemObjects_INDY10C}
      {$ELSE}
        {$IFDEF DELPHI10UP}
          {$DEFINE RemObjects_INDY10}
          {$DEFINE RemObjects_INDY10B}
        {$ELSE}
          {$IFDEF DELPHI9UP}
            {$DEFINE RemObjects_INDY10}
            {$DEFINE RemObjects_INDY10A}
          {$ELSE}
            {$IFDEF DELPHI7UP}
              {$DEFINE RemObjects_INDY9}
            {$ELSE}
              {$DEFINE RemObjects_INDY8}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}          
      {$ENDIF}

      {$IFDEF KYLIX}
        {$IFDEF KYLIX3UP}
          {$DEFINE RemObjects_INDY9}
        {$ELSE}
          {$DEFINE RemObjects_INDY8}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}

    { If you are using Indy 9 in Delphi 6 just uncomment the Indy9 DEFINE below,
      and remove the Indy package references from the Requires section of
      RemObjects_Indy_D6.dpk before compiling your RemObjects Indy package. }

    {.$DEFINE RemObjects_INDY9}

    {$IFDEF RemObjects_INDY9}
      {$UNDEF RemObjects_INDY8}
    {$ENDIF}

  {$ENDIF}

    { If you are using a newer version of Indy that properly works at designtime,
      you can set define the define below. If the define is not set (as is the
      default), Indy channels cannot be used to connect at designtime, trying so
      will display a warning message.

      If you enable this define and receive an Access Violation when trying to
      connect at designtime, then your Indy version does not yet include the
      fix for this problem. Please contact the Indy Crew for details.

      This problem applies to the Delphi Windows IDE's only; Kylix is not affected. }

    {.$DEFINE RemObjects_INDY_DESIGNTIME_FIX}

{ Thread Names in Debugger }

    {$IFDEF DELPHI7UP}
      {$DEFINE RemObjects_SetThreadName}
    {$ENDIF}

{ XML }

    {$IFDEF MSWINDOWS}
      {$DEFINE RemObjects_MSXML}
    {$ELSE}
      {$DEFINE RemObjects_OpenXML}
    {$ENDIF}

    { if we someone manually defined RemObjects_OpenXML, then undef RemObjects_MSXML }
    {$IFDEF RemObjects_OpenXML}
      {$UNDEF RemObjects_MSXML}
    {$ENDIF}

{ Encryption }

    {$IFDEF MSWINDOWS}
      {$DEFINE RemObjects_UseEncryption }
    {$ENDIF MSWINDOWS}

    {$IFDEF FPC}
      {$MODE DELPHI}
      {$UNDEF RemObjects_UseEncryption}
      {$DEFINE RemObjects_OpenXML}
      {$UNDEF RemObjects_MSXML}
    {$ENDIF}
 {$Q-,B-,R-}
