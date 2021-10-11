unit RunProcess;

interface

uses
  Windows, SysUtils, Classes, ExtCtrls;

type
  TRunProcess = class(TObject)
  private
    FStartInfo: TStartupInfo;
    FProcessInfo: TProcessInformation;
    FCommandLine: string;
    FWaitTimer: TTimer;
    FAutoFree: Boolean;
    FOnProcessBegin: TNotifyEvent;
    FOnProcessEnd: TNotifyEvent;
  protected
    procedure CheckEnd(Sender: TObject);
  public
    constructor Create(const ACommandLine: string);
    destructor Destroy; override;
    function Execute: Boolean;
    property CommandLine: string read FCommandLine write FCommandLine;
    property AutoFree: Boolean read FAutoFree write FAutoFree;
    property ProcessInfo: TProcessInformation read FProcessInfo;
    property OnProcessBegin: TNotifyEvent read FOnProcessBegin
     write FOnProcessBegin;
    property OnProcessEnd: TNotifyEvent read FOnProcessEnd
     write FOnProcessEnd;
  end;

implementation

constructor TRunProcess.Create(const ACommandLine: string);
begin
  inherited Create;
  {>> Cr�ation du timer d'attente }
  FWaitTimer := TTimer.Create(nil);
  FWaitTimer.Interval := 100;
  FWaitTimer.Enabled := False;
  FWaitTimer.OnTimer := CheckEnd;

  {>> Init }
  FCommandLine := ACommandLine;
  FAutoFree := False;
end;

destructor TRunProcess.Destroy;
begin
  FWaitTimer.Free;
  inherited Destroy;
end;

function TRunProcess.Execute: Boolean;
begin
  {>> Remplit les infos }
  FillChar(FStartInfo, SizeOf(TStartupInfo), 0);
  FillChar(FProcessInfo, sizeOf(TProcessInformation), 0);
  FStartInfo.cb := SizeOf(TStartupInfo);

  {>> D�marre le processus }
  Result := CreateProcess(nil, PChar(FCommandLine), nil, nil, False, 0, nil,
   nil, FStartInfo, FProcessInfo);

  {>> Si bien d�marr�, d�marre le timer d'attente et appelle l'�venement }
  if Result then
  begin
    FWaitTimer.Enabled := True;
    if Assigned(FOnProcessBegin) then
      FOnProcessBegin(Self);
  end;
end;

procedure TRunProcess.CheckEnd(Sender: TObject);
begin
  {>> C'est fini si la fonciton d'attente r�ussit }
  if WaitForSingleObject(FProcessInfo.hProcess, 0) <> WAIT_TIMEOUT then
  begin
    {>> Arr�te le timer }
    FWaitTimer.Enabled := False;

    {>> D�clenche l'�venement de fin }
    if Assigned(FOnProcessEnd) then
      FOnProcessEnd(Self);

    {>> Se d�truit si demand� }
    if FAutoFree then
      Free;
  end;
end;


end.
