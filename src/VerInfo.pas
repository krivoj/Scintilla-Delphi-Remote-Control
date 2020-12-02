
unit VerInfo;

interface

uses Windows;

type
  TVersionInformation = class
  private
    FFileName: string;
    FLangData: string;
    FVerData: Pointer;
    function GetVersionValue(Index: string): string;
    function GetEmpty: Boolean;
  public
    constructor Create(AFileName: string);
    destructor Destroy; override;
    property VersionValue[Index: string]: string read GetVersionValue;
    property Empty: Boolean read GetEmpty;
  end;

implementation

function TVersionInformation.GetVersionValue(Index: string): string;
var
  ResPtr: Pointer;
  Dummy: DWORD;
begin
  // ResPtr is just a pointer and we don't need to release the memory
  // because it points to the block inside of the version information
  if Assigned(FVerData) and VerQueryValue(FVerData,PChar(FLangData+Index),ResPtr,Dummy) then Result:=PChar(ResPtr)
  else Result:='';
end;

function TVersionInformation.GetEmpty: Boolean;
begin
  Result:=not Assigned(FVerData);
end;

constructor TVersionInformation.Create(AFileName: string);
var
  C: array[0..MAX_PATH] of Char;
  VerSize,Dummy: DWORD;
  TransInfo: Pointer;
  LangInfo: array[1..2] of DWORD;
begin
  inherited Create;
  FFileName:=AFileName;
  if Assigned(FVerData) then FreeMem(FVerData);
  // retreive the file version size
  VerSize:=GetFileVersionInfoSize(PChar(FFileName),Dummy);
  if VerSize<>0 then
  begin
    // allocate the memory block to read the version information
    GetMem(FVerData,VerSize);
    // get the version information
    if GetFileVersionInfo(PChar(FFileName),Dummy,VerSize,FVerData) then
    begin
      // get the translation...
      if VerQueryValue(FVerData,'\VarFileInfo\Translation',TransInfo,Dummy) then
      begin
        // ...and save the common part of the block name into the FLangData field
        LangInfo[1]:=LoWord(PLongint(TransInfo)^);
        LangInfo[2]:=HiWord(PLongint(TransInfo)^);
        wvsprintf(@C,'\StringFileInfo\%04x%04x\',PChar(@LangInfo));
        FLangData:=C;
      end;
    end;
  end
  else FVerData:=nil;
end;

destructor TVersionInformation.Destroy;
begin
  if Assigned(FVerData) then FreeMem(FVerData);
  inherited;
end;

end.
